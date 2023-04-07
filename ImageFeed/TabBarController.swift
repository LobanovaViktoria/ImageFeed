//
//  TabBarController.swift
//  ImageFeed
//
//  Created by Viktoria Lobanova on 13.03.2023.
//

import UIKit

final class TabBarController: UITabBarController {
    override func awakeFromNib() {
        super.awakeFromNib()
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        
        let imagesListViewController = storyboard.instantiateViewController(withIdentifier: "ImagesListViewController") as! ImagesListViewController
        imagesListViewController.configure(ImagesListViewPresenter())
        
        let profileViewController = ProfileViewController()
        profileViewController.configure(ProfileViewPresenter())
        profileViewController.tabBarItem = UITabBarItem(title: nil, image: UIImage(named: "tab_profile_active"), selectedImage: nil)
        profileViewController.updateAvatar()
        self.viewControllers = [imagesListViewController, profileViewController]
        
    }
}
