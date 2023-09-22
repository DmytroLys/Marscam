//
//  HistoryViewController.swift
//  Marscam
//
//  Created by Dmytro Lyshtva on 22.09.2023.
//

import UIKit

class HistoryViewController: UIViewController {

    var filtersHistoryList : [FilterHistory] = []
    
    @IBOutlet weak var emptyHistoryImage: UIImageView!
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(UINib(nibName: "FilterTableViewCell", bundle: nil), forCellReuseIdentifier: "HistoryCell")

    }
    @IBAction func backButton(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
}

extension HistoryViewController: UITableViewDelegate {
    
}

extension HistoryViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if filtersHistoryList.count > 1 {
            emptyHistoryImage.isHidden = true
        }
        print(filtersHistoryList.count)
        return filtersHistoryList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryCell",for: indexPath) as! FilterTableViewCell
        
        let cellDate = filtersHistoryList[indexPath.row].date
        let cellRoverName = filtersHistoryList[indexPath.row].roverName
        let cellCameraName = filtersHistoryList[indexPath.row].cameraName
        
        cell.setDateLabel(date: cellDate)
        cell.setRoverName(name: cellRoverName)
        cell.setCameraTypeLabel(type: cellCameraName)
        
        return cell
    }
    
}
