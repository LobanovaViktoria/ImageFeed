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
    
    var avatarURLCalled: Bool = false
    var updateProfileDetailsCalled: Bool = false
    var cleanServicesDataCalled: Bool = false
   
    func avatarURL() -> URL? {
        avatarURLCalled = true
        return nil
    }
    
    func updateProfileDetails() -> [String]? {
        updateProfileDetailsCalled = true
        return nil
    }
    
    func logout() {
   
    }
  
    func cleanServicesData() {
        cleanServicesDataCalled = true
    }
    
    static func clean() {
    }
    
}
