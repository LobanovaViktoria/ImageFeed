//
//  ProfileViewControllerSpy.swift
//  ImageFeed
//
//  Created by Viktoria Lobanova on 07.04.2023.
//

import ImageFeed
import UIKit
import Kingfisher

final class ProfileViewControllerSpy: UIViewController, ProfileViewControllerProtocol {
    
    var presenter: ImageFeed.ProfileViewPresenterProtocol?

    func configure(_ presenter: ProfileViewPresenterProtocol) {
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

