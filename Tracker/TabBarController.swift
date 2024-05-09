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
        let trackerViewController = TrackerViewController(categories: [], completedTrackers: [], newCategories: [], color: [], emodji: [])
        let statViewController = StatViewController()
        
        let activeImageTracker = UIImage(named: "blue ball")
        let inactiveImageTracker = UIImage(named: "grey ball")
        
        trackerViewController.tabBarItem = UITabBarItem(
            title: "Трекеры",
            image: inactiveImageTracker,
            selectedImage: activeImageTracker
        )
        
        let activeImageStat = UIImage(named: "blue animal")
        let inactiveImageStat = UIImage(named: "grey animal")
        
        statViewController.tabBarItem = UITabBarItem(
            title: "Статистика", 
            image: inactiveImageStat,
            selectedImage: activeImageStat
        )
        
        let trackerNavigationController = UINavigationController(rootViewController: trackerViewController)

        let statNavigationController = UINavigationController(rootViewController: statViewController)
        
        self.viewControllers = [trackerNavigationController, statNavigationController]
        
        tabBar.barTintColor = UIColor(red: 26/255, green: 27/255, blue: 34/255, alpha: 1.0)
        
    }
}
