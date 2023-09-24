//
//  ViewController.swift
//  Marscam
//
//  Created by Dmytro Lyshtva on 20.09.2023.
//

import UIKit
import RealmSwift
import Kingfisher

class ViewController: UIViewController {
    
    // MARK: - Properties
    
    @IBOutlet private weak var tableView: UITableView!
    
    
    private var roverName: String = "All" {
        didSet {
            roverNameLabel.text = roverName
        }
    }
    
    private var cameraName: String = "All" {
        didSet {
            cameraNameLabel.text = cameraName
        }
    }
    
    private var date: String = "" {
        didSet {
            dateLabel.text = convertDateString(date)
        }
    }
    
    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var roverNameLabel: UILabel!
    @IBOutlet private weak var cameraNameLabel: UILabel!
    
    private var apiManager = APIManager()
    var photosList: [Photo] = []
    
    var filteredPhotosList: [Photo] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        filteredPhotosList = photosList
        
        navigationController?.navigationBar.isHidden = true
        apiManager.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: Constants.ImageCell.name, bundle: nil), forCellReuseIdentifier: Constants.ImageCell.cellReuseIdentifier)
        tableView.separatorStyle = .none
        
    }
    
    
    @IBAction func roverFilterTapped(_ sender: UIButton) {
        let modalVC =  PopUpModalViewController.present(initialView: self, delegate: self, style: .filter)
        modalVC.pickerData = Constants.PickerData.roverData
        modalVC.modalTitle = "Rover"
        modalVC.context = .rover
    }
    
    @IBAction func cameraFilterTapped(_ sender: UIButton) {
        let modalVC = PopUpModalViewController.present(initialView: self, delegate: self, style: .filter)
        modalVC.pickerData = Constants.PickerData.cameraData
        modalVC.modalTitle = "Camera"
        modalVC.context = .camera
    }
    
    @IBAction func dateFilterTapped(_ sender: UIButton) {
        let modalVC = PopUpModalViewController.present(initialView: self, delegate: self, style: .date)
        modalVC.modalTitle = "Date"
        modalVC.context = .date
    }
    
    func filterBasedOnSelection() {
        filteredPhotosList = photosList

            if roverName != "All" {
                filteredPhotosList = filteredPhotosList.filter({ $0.rover.name == roverName })
            }

            if cameraName != "All" {
                filteredPhotosList = filteredPhotosList.filter({ $0.camera.full_name == cameraName })
            }
    }
    
    func setView(view: UIView, hidden: Bool) {
        UIView.transition(with: view, duration: 0.5, options: .transitionCrossDissolve, animations: {
            view.isHidden = hidden
        })
    }
    
    
    private func convertDateString(_ input: String) -> String? {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd"
        
        if let date = inputFormatter.date(from: input) {
            let outputFormatter = DateFormatter()
            outputFormatter.dateFormat = "MMMM dd, yyyy"
            outputFormatter.locale = Locale(identifier: "en_US")
            return outputFormatter.string(from: date)
        } else {
            return nil
        }
    }
    
    @IBAction func addHistoryTapped(_ sender: UIButton) {
        
        let ac = UIAlertController(title: "Save Filters", message: "The current filters and the date you have chosen can be saved to the filter history.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Save", style: .default, handler: handleSaveFilterHistory))
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        present(ac,animated: true)
    }
    
    func handleSaveFilterHistory(action: UIAlertAction) {
        
        let history = FilterHistory()
        history.date = dateLabel.text ?? ""
        history.roverName = roverName
        history.cameraName = cameraName
        
        let realm = try! Realm()
        
        try! realm.write {
            realm.add(history)
        }
    }
    
    @IBAction func goToHistoryTapped(_ sender: UIButton) {
        self.performSegue(withIdentifier: Constants.Segues.goToHistoryController, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.Segues.goToHistoryController {
            let destinationVC = segue.destination as? HistoryViewController
            
            let realm = try! Realm()
            
            let filterHistory = realm.objects(FilterHistory.self)
            
            let arrayFilters = Array(filterHistory)
            
            destinationVC?.filtersHistoryList = arrayFilters
        }
    }
    
    
    
}


// MARK: - UITableViewDelegate

extension ViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let url = photosList[indexPath.row].img_src
        
        let imageView = UIImageView()
        imageView.kf.setImage(with: url)
        let fullScreenVC = FullScreenImageViewController(imageView: imageView)
        fullScreenVC.modalPresentationStyle = .overFullScreen
        fullScreenVC.modalPresentationCapturesStatusBarAppearance = true
        self.present(fullScreenVC, animated: true, completion: nil)
        
    }
}
// MARK: - UITableViewDataSource
extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredPhotosList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.ImageCell.cellReuseIdentifier, for: indexPath) as! ImageCell
        
        let cellRoverName = filteredPhotosList[indexPath.row].rover.name
        let cellCameraType = filteredPhotosList[indexPath.row].camera.full_name
        let cellDay = filteredPhotosList[indexPath.row].earth_date
        let imageURL = filteredPhotosList[indexPath.row].img_src
        
        if let convertDate = convertDateString(cellDay) {
            cell.setDateLabel(date: convertDate)
        }
        
        cell.setImageView(url: imageURL)
        cell.setRoverName(name: cellRoverName)
        cell.setCameraTypeLabel(type: cellCameraType)
        
        return cell
    }
}

// MARK: - APIManagerDelegate
extension ViewController : APIManagerDelegate {
    
    func didUpdatePhotos(_ apiManager: APIManager, photos: [Photo]) {
    
        photosList = photos
        
        DispatchQueue.main.async {
            self.filteredPhotosList = self.photosList
        }
    }
    
    func didFailWithError(error: Error) {
        
        print(error.localizedDescription)
    }
}

// MARK: - PopUpModalDelegate

extension ViewController: PopUpModalDelegate {
    func didTapAccept(selectedValue: String?, context: PickerContext?) {
        guard let value = selectedValue else { return }
        
        switch context {
        case .rover:
            roverName = value
            filterBasedOnSelection()
        case .camera:
            cameraName = value
            filterBasedOnSelection()
        case .date :
            apiManager.fetchPhotos(date: value)
            roverName = "All"
            cameraName = "All"
            date = value
        case .none:
            // Handle or ignore
            break
        }
    }
    
    func didTapCancel() {
        self.dismiss(animated: true)
    }
}

