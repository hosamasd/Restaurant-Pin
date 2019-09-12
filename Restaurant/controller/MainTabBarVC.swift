//
//  MainTabBarVC.swift
//  Restaurant
//
//  Created by hosam on 9/11/19.
//  Copyright © 2019 hosam. All rights reserved.
//

import UIKit

class MainTabBarVC: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        setupViewControllers()
    }
    
    fileprivate func setupViewControllers() {
        
        let layout = UICollectionViewFlowLayout()
        let home = templateNavControllerVC(title: "Home".localized, selectedImage: #imageLiteral(resourceName: "favorite"), rootViewController: RestaurantHomeVC(collectionViewLayout: layout))
        let about = templateNavControllerVC(title: "About".localized, selectedImage: #imageLiteral(resourceName: "about"), rootViewController: AboutVC())
        
        tabBar.tintColor = UIColor(r: 235, g: 75, b: 27)
        tabBar.barTintColor = UIColor(r: 236, g: 240, b: 241)
        viewControllers = [
            home,
            about
        ]
        
        guard let items = tabBar.items else { return }
        
        for item in items {
            item.imageInsets = UIEdgeInsets(top: 4, left: 0, bottom: -4, right: 0)
        }
    }
    
    fileprivate func templateNavControllerVC(title: String, selectedImage: UIImage, rootViewController: UIViewController ) -> UINavigationController {
        let navController = UINavigationController(rootViewController: rootViewController)
        navigationController?.navigationBar.prefersLargeTitles = true
        rootViewController.navigationItem.title = title
        navController.tabBarItem.title = title
        navController.tabBarItem.image = selectedImage
        return navController
    }
}
