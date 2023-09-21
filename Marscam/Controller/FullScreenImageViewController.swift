//
//  FullScreenImageViewController.swift
//  Marscam
//
//  Created by Dmytro Lyshtva on 22.09.2023.
//

import UIKit

class FullScreenImageViewController: UIViewController {
    
    
    // MARK: - Properties
    var imageView: UIImageView!
    var backButton: UIButton!
    
    // MARK: - Init
    init(imageView: UIImageView) {
        super.init(nibName: nil, bundle: nil)
        self.imageView = imageView
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle method
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        
        cofigureImageView()
        configureButton()
    }
    
    func cofigureImageView () {
        
        imageView.frame = view.bounds
        imageView.contentMode = .scaleAspectFit
        imageView.isUserInteractionEnabled = true
        view.addSubview(imageView!)
    }
    
    func configureButton() {
        backButton = UIButton()
        
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.setImage(UIImage(named: "close"), for: .normal)
        view.addSubview(backButton)
        
        backButton.heightAnchor.constraint(equalToConstant: 44).isActive = true
        backButton.widthAnchor.constraint(equalToConstant: 44).isActive = true
        
        let safeArea = view.safeAreaLayoutGuide
        
        backButton.topAnchor.constraint(equalTo: safeArea.topAnchor,constant: 14).isActive = true
        backButton.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor,constant: 14).isActive = true
        
        backButton.addTarget(self, action: #selector(dismissFullscreenImage), for: .touchUpInside)
    }
    
    
    @objc func dismissFullscreenImage() {
        self.dismiss(animated: true, completion: nil)
    }
}
