//
//  RootViewController.swift
//  Live Streaming App
//
//  Created by Sudayn on 5/4/2024.
//


import UIKit
import Combine

class RootViewController: UINavigationController {
    
    private var cancellable: AnyCancellable?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        handleLogin()
    }
    
    func handleLogin() {
        cancellable = AppModel
            .shared
            .$authState
            .sink { state in
                switch state {
                case .Loading:
                    if let loadingViewController: LoadingViewController = Storyboards.instantiateViewController(from: "Main", withIdentifier: "LoadingViewController") {
                        self.setViewControllers([loadingViewController], animated: false)
                    } else {
                        print("Failed")
                    }
                    break
                case .NotLoggedIn:
                    if let authViewController: AuthViewController = Storyboards.instantiateViewController(from: "Main", withIdentifier: "AuthViewController") {
                        self.setViewControllers([authViewController], animated: false)
                    } else {
                        print("Failed")
                    }
                    break
                case .LoggedIn:
                    if let tabbarController: TabBarController = Storyboards.instantiateViewController(from: "Main", withIdentifier: "TabBarController") {
                        self.setViewControllers([tabbarController], animated: false)
                    } else {
                        print("Failed")
                    }
                    break
                }
                
            }
    }
}
