//
//  ProfileViewPresenterSpy.swift
//  ImageFeedTests
//
//  Created by Viktoria Lobanova on 15.04.2023.
//

import ImageFeed
import Foundation
import WebKit

final class ProfilePresenterSpy: ProfilePresenterProtocol {
    
    weak var view: ProfileViewControllerProtocol?
    
    var logoutCalled: Bool = false
    
   
    func avatarURL() -> URL? {
        return nil
    }
    
    func updateProfileDetails() -> [String]? {
        return nil
    }
    
    func logout() {
    logoutCalled = true
    }
  
    func cleanServicesData() {
    }
    
    static func clean() {
    }
    
}
