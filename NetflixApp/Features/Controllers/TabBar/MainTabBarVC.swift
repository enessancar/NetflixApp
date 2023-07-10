//
//  ViewController.swift
//  NetflixApp
//
//  Created by Enes Sancar on 10.07.2023.
//

import UIKit

final class MainTabBarVC: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureVC()
    }
    
    private func configureVC() {
        viewControllers = [
            createNavController(for: HomeVC(), title: "Home", imageName: "house"),
            createNavController(for: UpcomingVC(), title: "Coming Soon", imageName: "play.circle"),
            createNavController(for: SearchVC(), title: "Top Search", imageName: "magnifyingglass"),
            createNavController(for: DownloadsVC(), title: "Downloads", imageName: "arrow.down.to.line")
        ]
    }
    
    fileprivate func createNavController(for viewController: UIViewController, title: String, imageName: String) -> UIViewController {
        
        let navController = UINavigationController(rootViewController: viewController)
        navController.navigationBar.prefersLargeTitles = true
        viewController.navigationItem.title = title
        viewController.view.backgroundColor = .systemBackground
        navController.tabBarItem.title = title
        navController.tabBarItem.image = UIImage(systemName: imageName)
        tabBar.tintColor = .label
        return navController
    }
}

