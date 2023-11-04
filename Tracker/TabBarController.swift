//
//  TabBarController.swift
//  Tracker
//
//  Created by Eduard Karimov on 31/10/2023.
//

import Foundation
import UIKit

final class TabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Экземпляры контроллеров
        let trackerViewController = TrackerViewController()
        let statViewController = StatViewController()
        
        let activeImageTracker = UIImage(named: "Tab Bar Item")
        let inactiveImageTracker = UIImage(named: "Tab Bar Item inactive")
        
        trackerViewController.tabBarItem = UITabBarItem(
            title: nil,
            image: inactiveImageTracker,
            selectedImage: activeImageTracker
        )
        
        let activeImageStat = UIImage(named: "Tab Bar Item stat active")
        let inactiveImageStat = UIImage(named: "Tab Bar Item2")
        
        statViewController.tabBarItem = UITabBarItem(
            title: nil, 
            image: inactiveImageStat,
            selectedImage: activeImageStat
        )
        
        let trackerNavigationController = UINavigationController(rootViewController: trackerViewController)

        let statNavigationController = UINavigationController(rootViewController: statViewController)
        
        self.viewControllers = [trackerNavigationController, statNavigationController]
        
        tabBar.barTintColor = UIColor(red: 26/255, green: 27/255, blue: 34/255, alpha: 1.0)
        
        if let navController = viewControllers?.first as? UINavigationController {
            for _ in navController.viewControllers {
            }
        }
    }
}
