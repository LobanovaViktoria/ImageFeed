//
//  ProfileViewControllerSpy.swift
//  ImageFeedTests
//
//  Created by Viktoria Lobanova on 15.04.2023.
//

import ImageFeed
import UIKit
import Kingfisher

final class ProfileViewControllerSpy: UIViewController, ProfileViewControllerProtocol {
    
    var presenter: ImageFeed.ProfilePresenterProtocol?

    func configure(_ presenter: ProfilePresenterProtocol) {
        self.presenter = presenter
        self.presenter?.view = self
    }
    
    
    func updateAvatar() {
      
    }
    
    private func updateProfileDetails() {
          }
    
    @objc
    private func didTapLogoutButton() {
       
    }
 
    func switchToSplashViewController() {
        }
    
    func showAlert() {
        presenter?.logout()
    }
}

