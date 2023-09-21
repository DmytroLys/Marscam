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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.isHidden = true
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "ImageCell", bundle: nil), forCellReuseIdentifier: "ReusableCell")
        tableView.separatorStyle = .none
    }
}

extension ViewController: UITableViewDelegate {
    
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReusableCell", for: indexPath) as! ImageCell
        
        cell.setRoverName(name: "Curiosity")
        cell.setCameraTypeLabel(type: "Front Hazard Avoidance Camera")
        cell.setDateLabel(date: "June 6, 2019")
        return cell
    }
    
    
}

