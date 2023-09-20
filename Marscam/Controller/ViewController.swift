//
//  ViewController.swift
//  Marscam
//
//  Created by Dmytro Lyshtva on 20.09.2023.
//

import UIKit

class ViewController: UIViewController {

    // MARK: - Properties
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.isHidden = true
        
    }


    @objc func calendarPickerDidTapped(_ sender: Any) {
        
        print(#function)
    }
    
}

