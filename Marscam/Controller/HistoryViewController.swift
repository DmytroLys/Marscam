//
//  HistoryViewController.swift
//  Marscam
//
//  Created by Dmytro Lyshtva on 22.09.2023.
//

import UIKit
import RealmSwift

class HistoryViewController: UIViewController {
    
    var filtersHistoryList : [FilterHistory] = [] {
        didSet {
            return filtersHistoryList.reverse()
        }
    }
    
    @IBOutlet weak var emptyHistoryImage: UIImageView!
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.register(UINib(nibName: Constants.FilterTableViewCell.name, bundle: nil), forCellReuseIdentifier: Constants.FilterTableViewCell.cellReuseIdentifier)
        
    }
    @IBAction func backButton(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    @objc private func deleteData(action: UIAlertAction) {
        if let indexPath = self.tableView.indexPathForSelectedRow {
            
            
            let realm = try! Realm()
            let objects = realm.objects(FilterHistory.self)
            
            try!  realm.write {
                realm.delete(objects[indexPath.row])
            }
            
            self.filtersHistoryList.remove(at: indexPath.row)
            
            
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    private func useData(action: UIAlertAction) {
        guard let indexPath = self.tableView.indexPathForSelectedRow else { return }
            let selectedFilter = filtersHistoryList[indexPath.row]
            
        let photos = Array(selectedFilter.photos).compactMap { photoRealm -> Photo? in
            
            guard let url = URL(string: photoRealm.imageURL) else {
                    print("Failed to create URL from string: \(photoRealm.imageURL)")
                    return nil
                }
            
            let dummyCamera = Camera(name: photoRealm.cameraName, full_name: photoRealm.cameraName)
            let dummyRover = Rover(name: photoRealm.roverName)
            
            
            
            return Photo(
                camera: dummyCamera,
                img_src: url,
                earth_date: photoRealm.date,
                rover: dummyRover
            )
        }
            print(photos)
            
            NotificationCenter.default.post(name: .useFilterFromHistory, object: nil, userInfo: ["photos": photos, "filter": selectedFilter])
        self.dismiss(animated: true)
    }
    
}

extension HistoryViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let ac = UIAlertController(title: "", message: "Menu Filter", preferredStyle: .actionSheet)
        ac.addAction(UIAlertAction(title: "Use", style: .default,handler: useData))
        ac.addAction(UIAlertAction(title: "Delete", style: .destructive,handler: deleteData(action:)))
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        present(ac, animated: true)
    }
}

extension HistoryViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if filtersHistoryList.count >= 1 {
            emptyHistoryImage.isHidden = true
        }
        return filtersHistoryList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.FilterTableViewCell.cellReuseIdentifier,for: indexPath) as! FilterTableViewCell
        
        let cellDate = filtersHistoryList[indexPath.row].date
        let cellRoverName = filtersHistoryList[indexPath.row].roverName
        let cellCameraName = filtersHistoryList[indexPath.row].cameraName
        
        cell.setDateLabel(date: cellDate)
        cell.setRoverName(name: cellRoverName)
        cell.setCameraTypeLabel(type: cellCameraName)
        
        return cell
    }
    
}
