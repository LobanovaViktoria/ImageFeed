//
//  ProfileViewTests.swift
//  ImageFeedTests
//
//  Created by Viktoria Lobanova on 15.04.2023.
//

import XCTest
@testable import ImageFeed

final class ProfileUnitTests: XCTestCase {
   
    func testProfileViewLogoutTokenIsEqualNil() {
        //given
        let viewController = ProfileViewController()
        let presenter = ProfilePresenter()
        viewController.configure(presenter)
        
        //when
        presenter.logout()
        
        //then
        XCTAssertEqual(OAuth2TokenStorage().token, nil)
    }
    
    func testProfilePresenterCallsAvatarURL() {
        //given
        let viewController = ProfileViewController()
        let presenter = ProfilePresenterSpy()
        viewController.presenter = presenter
        presenter.view = viewController
        
        //when
        viewController.viewDidLoad()
        
        //then
        XCTAssertTrue(presenter.avatarURLCalled) //behaviour verification
    }
    
    func testProfilePresenterCallsUpdateProfileDetails() {
        //given
        let viewController = ProfileViewController()
        let presenter = ProfilePresenterSpy()
        viewController.presenter = presenter
        presenter.view = viewController
        
        //when
        viewController.viewDidLoad()
        
        //then
        XCTAssertTrue(presenter.updateProfileDetailsCalled) //behaviour verification
    }
    
    func testProfilePresenterCleanServicesData() {
        //given
        let viewController = ProfileViewController()
        let presenter = ProfilePresenterSpy()
        viewController.presenter = presenter
        presenter.view = viewController
        
        //when
        presenter.logout()
        
        //then
        XCTAssertTrue(presenter.cleanServicesDataCalled) //behaviour verification
    }
    
    func testProfilePresenterChangedViewControllerAfterLogout() {
        //given
        let viewController = ProfileViewController()
        let presenter = ProfilePresenter()
        viewController.presenter = presenter
        presenter.view = viewController
        
        //when
        presenter.logout()
        
        guard let window = UIApplication.shared.windows.first else {
            assertionFailure("Invalid Configuration")
            return
        }
        
        //then
        XCTAssertTrue(window.rootViewController?.isKind(of: SplashViewController.self) == true) //behaviour verification
    }
}
