//
//  TabViewController.swift
//  TimeLogApp
//
//  Created by Apple on 2020/03/20.
//  Copyright © 2020年 Baminami. All rights reserved.
//

import Foundation
import UIKit

class TabViewController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        makeTabViewController()
    }
    
    private func makeTabViewController() {
        // ページを格納する配列
        var viewControllers: [UIViewController] = []
        
        // 1ページ目になるViewController
        let firstVC = TopViewController()
        firstVC.tabBarItem = UITabBarItem(tabBarSystemItem: .search, tag: 1)
        viewControllers.append(firstVC)
        
        // 2ページ目になるViewController
        let secondVC = HistoryViewController(nibName: "HistoryViewController", bundle: nil)
        secondVC.tabBarItem = UITabBarItem(tabBarSystemItem: .favorites, tag: 2)
        viewControllers.append(secondVC)
        
        // 3ページ目になるViewController
        let thirdVC = RedMineViewController()
        thirdVC.tabBarItem = UITabBarItem(tabBarSystemItem: .contacts, tag: 3)
        viewControllers.append(thirdVC)
        
        // ViewControllerをセット
        let tabBarController = UITabBarController()
        tabBarController.setViewControllers(viewControllers, animated: false)
        
        self.viewControllers = viewControllers
    }
    
    
}
