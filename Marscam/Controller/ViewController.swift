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
    
    let datePicker = UIDatePicker()
    
    private var roverName: String = "All" {
        didSet {
            
        }
    }
    
    private var cameraName: String = "All" {
        didSet {
            
        }
    }
    
    private var date: String = "" {
        didSet {
            dateLabel.text = date
        }
    }
    
    
    @IBOutlet private weak var dateLabel: UILabel!
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
        
    }
    
    @IBAction func cameraFilterTapped(_ sender: UIButton) {
        
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
        history.cameraName = roverName
        
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

