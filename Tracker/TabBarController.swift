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
        
        let activeImage = UIImage(named: "Tab Bar Item")
        let inactiveImage = UIImage(named: "Tab Bar Item2")
        
        trackerViewController.tabBarItem = UITabBarItem(
            title: nil,
            image: inactiveImage,
            selectedImage: activeImage
        )
        
//        statViewController.tabBarItem = UITabBarItem(
//            title: nil, image: inactiveImage, selectedImage: activeImage
//        )
        
        let trackerNavigationController = UINavigationController(rootViewController: trackerViewController)

  //      let statNavigationController = UINavigationController(rootViewController: statViewController)
        
        self.viewControllers = [trackerViewController]
    }
}
