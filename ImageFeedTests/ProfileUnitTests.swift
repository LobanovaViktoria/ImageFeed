//
//  ProfileViewTests.swift
//  ImageFeedTests
//
//  Created by Viktoria Lobanova on 15.04.2023.
//

import XCTest
@testable import ImageFeed

final class ProfileUnitTests: XCTestCase {
    func testProfileViewCallsLogout() {
        //given
        let viewController = ProfileViewController()
        let presenter = ProfilePresenterSpy()
        viewController.configure(presenter)
        
        //when
        viewController.showAlert()
        //then
        XCTAssertTrue(presenter.logoutCalled)
    }
    
    func testProfileViewLogoutTokenIsEqualNil() {
        //given
        let viewController = ProfileViewControllerSpy()
        let presenter = ProfilePresenterSpy()
        viewController.configure(presenter)
        
        //when
        presenter.logout()
        
        //then
        XCTAssertEqual(OAuth2TokenStorage().token, nil)
    }
}
