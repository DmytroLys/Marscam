//
//  ViewController.swift
//  Marscam
//
//  Created by Dmytro Lyshtva on 20.09.2023.
//

import UIKit
import RealmSwift

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
            dateLabel.text = date
        }
    }
    
    
    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var roverNameLabel: UILabel!
    @IBOutlet private weak var cameraNameLabel: UILabel!
    
    private var apiManager = APIManager()
    var photosList: [Photo] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.isHidden = true
        apiManager.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "ImageCell", bundle: nil), forCellReuseIdentifier: "ReusableCell")
        tableView.separatorStyle = .none
        
    }
    
    
    @IBAction func roverFilterTapped(_ sender: UIButton) {
        let modalVC = PopUpModalViewController.present(initialView: self, delegate: self)
            modalVC.pickerData = ["All","Curiosity", "Opportunity", "Spirit"]
            modalVC.modalTitle = "Rover"
            modalVC.context = .rover
        
    }
    
    @IBAction func cameraFilterTapped(_ sender: UIButton) {
        let modalVC = PopUpModalViewController.present(initialView: self, delegate: self)
        modalVC.pickerData = ["All","Front Hazard Avoidance Camera", "Rear Hazard Avoidance Camera", "Mast Camera", "Chemistry and Camera Complex", "Mars Hand Lens Imager", "Mars Descent Imager", "Navigation Camera", "Panoramic Camera","Miniature Thermal Emission Spectrometer (Mini-TES)"]
        modalVC.modalTitle = "Camera"
        modalVC.context = .camera
    }
    
    @IBAction func dateFilterTapped(_ sender: UIButton) {
        
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
        ac.addAction(UIAlertAction(title: "Save", style: .default, handler: saveFunction))
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
    
        present(ac,animated: true)
    }
    
    func saveFunction(action: UIAlertAction) {
        
        let history = FilterHistory()
        history.date = dateLabel.text!
        history.roverName = roverName
        history.cameraName = cameraName
        
        let realm = try! Realm()
        
        try! realm.write {
            realm.add(history)
        }
    }
    
    @IBAction func goToHistoryTapped(_ sender: UIButton) {
        self.performSegue(withIdentifier: "goToHistory", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToHistory" {
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
        imageView.loadImage(from: url)
        let fullScreenVC = FullScreenImageViewController(imageView: imageView)
        fullScreenVC.modalPresentationStyle = .overFullScreen
        fullScreenVC.modalPresentationCapturesStatusBarAppearance = true
        self.present(fullScreenVC, animated: true, completion: nil)
        
    }
}
// MARK: - UITableViewDataSource
extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photosList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReusableCell", for: indexPath) as! ImageCell
        
        let cellRoverName = photosList[indexPath.row].rover.name
        let cellCameraType = photosList[indexPath.row].camera.full_name
        let cellDay = photosList[indexPath.row].earth_date
        let imageURL = photosList[indexPath.row].img_src
        
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
            self.tableView.reloadData()
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
            case .camera:
                cameraName = value
            case .none:
                // Handle or ignore
                break
            }
    }
    
    
    func didTapAccept(selectedValue: String?) {
        guard let filter = selectedValue else { return }
        print(filter)
    }
    
    func didTapCancel() {
        self.dismiss(animated: true)
    }
    
    
    
    
}

