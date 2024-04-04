//
//  ViewController.swift
//  RickMorty
//
//  Created by Amine CHATATE on 10/12/2023.
//

import UIKit

final class RMTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        setUpTabs()
    }
    
    private func setUpTabs() {
        
        let charactersNavigationController = createTabs(title: "Characters", imageName: "person", tag: 1, viewController: RMCharacterViewController())
        let locationNavigationController = createTabs(title: "Location", imageName: "globe", tag: 2, viewController: RMLocationViewController())
        let episodeNavigationController = createTabs(title: "Episode", imageName: "tv", tag: 3, viewController: RMEpisodeViewController())
        let settingsNavigationController = createTabs(title: "Settings", imageName: "gear", tag: 4, viewController: RMSettingsViewController())

        let navigationControllerArray = [charactersNavigationController, locationNavigationController, episodeNavigationController, settingsNavigationController]
        
        setViewControllers(navigationControllerArray, animated: true)
        
    }

    private func createTabs(title: String, imageName: String, tag: Int, viewController: UIViewController) -> UINavigationController {
        
        viewController.navigationItem.largeTitleDisplayMode = .automatic
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.tabBarItem = UITabBarItem(title: title, image: UIImage(systemName: imageName), tag: tag)
        navigationController.navigationBar.prefersLargeTitles = true
                
        return navigationController
        
    }

}

