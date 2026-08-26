//
//  RMTabBarController.swift
//  RickAndMorty
//
//  Created by Rahul Acharya on 23/07/26.
//

import UIKit

/// Controller to house tabs and root tab controllers
final class RMTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        configureTabBar()
        setUpTabs()
    }
    
    
    private func configureTabBar() {
//
//        let appearance = UITabBarAppearance()
//
//        appearance.configureWithTransparentBackground()
//        appearance.backgroundColor = .clear
//        appearance.backgroundEffect = nil
//        appearance.shadowColor = .clear
//
//        tabBar.standardAppearance = appearance
//        tabBar.scrollEdgeAppearance = appearance
//        tabBar.backgroundColor = .clear
//        tabBar.barTintColor = .clear
//
//        tabBar.isTranslucent = true
        
        if #available(iOS 26.0, *) {
            let appearance = UITabBarAppearance()
            appearance.configureWithTransparentBackground()
            appearance.backgroundColor = .clear
            appearance.backgroundEffect = nil
            appearance.shadowColor = .clear

            tabBar.standardAppearance = appearance
            tabBar.scrollEdgeAppearance = appearance

            tabBar.isTranslucent = true
            tabBar.backgroundColor = .clear
            tabBar.barTintColor = .clear
        } else {
            tabBar.isTranslucent = true
            tabBar.backgroundImage = UIImage()
            tabBar.shadowImage = UIImage()
            tabBar.backgroundColor = .clear
        }
    }
    
    private func setUpTabs() {
        let characterVC = RMCharacterViewController()
        let locationVC = RMLocationViewController()
        let episodeVC = RMEpisodeViewController()
        let settingsVC = RMSettingsViewController()
        
        characterVC.navigationItem.largeTitleDisplayMode = .automatic
        locationVC.navigationItem.largeTitleDisplayMode = .automatic
        episodeVC.navigationItem.largeTitleDisplayMode = .automatic
        settingsVC.navigationItem.largeTitleDisplayMode = .automatic
        
        let nav1 = UINavigationController(rootViewController: characterVC)
        let nav2 = UINavigationController(rootViewController: locationVC)
        let nav3 = UINavigationController(rootViewController: episodeVC)
        let nav4 = UINavigationController(rootViewController: settingsVC)
        
        nav1.tabBarItem = UITabBarItem(
            title: "Characters",
            image: UIImage(systemName: "person"),
            tag: 1
        )
        nav2.tabBarItem = UITabBarItem(
            title: "Locations",
            image: UIImage(systemName: "globe"),
            tag: 2
        )
        nav3.tabBarItem = UITabBarItem(
            title: "Episodes",
            image: UIImage(systemName: "tv"),
            tag: 3
        )
        nav4.tabBarItem = UITabBarItem(
            title: "Settings",
            image: UIImage(systemName: "gear"),
            tag: 4
        )
        
        for nav in [nav1, nav2, nav3, nav4] {
            nav.navigationBar.prefersLargeTitles = true
        }
        setViewControllers(
            [nav1, nav2, nav3, nav4],
            animated: true
        )
    }
}
