//
//  QuotesTabBarController.swift
//  Quotes
//
//  Created by Nick Nguyen on 4/21/20.
//  Copyright © 2020 Nick Nguyen. All rights reserved.
//

import UIKit

class QuotesTabBarController : UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UITabBar.appearance().tintColor = UIColor(named: "textColor")
        viewControllers = [createMainQuoteNC(),createDetailNC()]
    }
    
    
    func createMainQuoteNC() -> UINavigationController {
        
        let vc = QuoteCollectionViewController(collectionViewLayout: UICollectionViewFlowLayout())
        vc.title = "Quote"
        vc.tabBarItem = UITabBarItem(title: "Quote", image: UIImage(systemName: "heart.fill"), selectedImage: nil)
        
        return UINavigationController(rootViewController: vc)
    }
    
    func createDetailNC() -> UINavigationController {
        let detailVC = FavoriteQuoteTableViewController()
        detailVC.title = "Detail"
        detailVC.tabBarItem = UITabBarItem(tabBarSystemItem: .favorites, tag: 1)
        return UINavigationController(rootViewController: detailVC)
    }
    
}
