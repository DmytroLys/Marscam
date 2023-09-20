//
//  LaunchViewController.swift
//  Marscam
//
//  Created by Dmytro Lyshtva on 20.09.2023.
//

import UIKit
import Lottie

class LaunchViewController: UIViewController {
    
    
    var logoView: UIView!
    private var animationView: LottieAnimationView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureLogoView()
        configureAnimation()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false) { timer in
            self.navigateToMainViewController()
        }
        
    }
    
    func configureLogoView() {
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
    
    func configureAnimation() {
        
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
    
    func navigateToMainViewController() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let mainVC = storyboard.instantiateViewController(identifier: "NavigationController")
        mainVC.modalPresentationStyle = .fullScreen
        mainVC.modalTransitionStyle = .crossDissolve
        self.present(mainVC, animated: true, completion: nil)
    }
}
