//
//  ViewController.swift
//  Marscam
//
//  Created by Dmytro Lyshtva on 20.09.2023.
//

import UIKit

class ViewController: UIViewController {

    // MARK: - Properties
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet private weak var dateLabel: UILabel!
    private var apiManager = APIManager()
    private var photosList: [Photo] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.isHidden = true
        apiManager.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "ImageCell", bundle: nil), forCellReuseIdentifier: "ReusableCell")
        tableView.separatorStyle = .none
        
        apiManager.fetchPhotos()
    }
    
   private func convertDateString(_ input: String) -> String? {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd"

        if let date = inputFormatter.date(from: input) {
            let outputFormatter = DateFormatter()
            outputFormatter.dateFormat = "MMMM dd, yyyy"
            return outputFormatter.string(from: date)
        } else {
            return nil
        }
    }
}


// MARK: - UITableViewDelegate

extension ViewController: UITableViewDelegate {
    
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
        
        if let convertDate = convertDateString(cellDay) {
            cell.setDateLabel(date: convertDate)
        }
        
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

