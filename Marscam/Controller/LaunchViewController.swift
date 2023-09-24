//
//  LaunchViewController.swift
//  Marscam
//
//  Created by Dmytro Lyshtva on 20.09.2023.
//

import UIKit
import Lottie

class LaunchViewController: UIViewController {
    

    private var logoView: UIView!
    private var animationView: LottieAnimationView?
    private var apiManager = APIManager()
    private var photosList: [Photo] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureLogoView()
        configureAnimation()
        apiManager.delegate = self
        apiManager.fetchPhotos()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.Segues.goToViewController {
            let destinationVC = segue.destination as? ViewController
            destinationVC?.photosList = photosList
        }
    }
    
   private func configureLogoView() {
        logoView = UIView()
        view.addSubview(logoView)
        
        logoView.translatesAutoresizingMaskIntoConstraints = false
        logoView.widthAnchor.constraint(equalToConstant: 123).isActive = true
        logoView.heightAnchor.constraint(equalToConstant: 123).isActive = true
        logoView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        logoView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        logoView.layer.cornerRadius = 30
        logoView.backgroundColor = UIColor(named: "accentOne")
    }
    
   private func configureAnimation() {
        
        animationView = LottieAnimationView(name: "Loader_Test")
        animationView!.contentMode = .scaleAspectFill
        animationView!.loopMode = .loop
        animationView!.animationSpeed = 1.0
        view.addSubview(animationView!)
        
        animationView!.translatesAutoresizingMaskIntoConstraints = false
        
        
        animationView?.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -114).isActive = true
        animationView?.heightAnchor.constraint(equalToConstant: 34).isActive = true
        animationView?.widthAnchor.constraint(equalToConstant: 222).isActive = true
        animationView?.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        animationView!.play()
    }
}

extension LaunchViewController :APIManagerDelegate {
    func didUpdatePhotos(_ apiManager: APIManager, photos: [Photo]) {
        photosList = photos
        
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: Constants.Segues.goToViewController, sender: self)
        }
    }
    
    func didFailWithError(error: Error) {
        printContent(error)
    }
}
