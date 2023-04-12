//
//  ProfileViewTests.swift
//  ImageFeedTests
//
//  Created by Viktoria Lobanova on 07.04.2023.
//

import XCTest
@testable import ImageFeed

final class ProfileViewTests: XCTestCase {
    func testProfileViewCallsLogout() {
        //given
        let viewController = ProfileViewControllerSpy()
        let presenter = ProfileViewPresenterSpy()
        viewController.configure(presenter)
        
        //when
        _ = viewController.showAlert()
        
        //then
        XCTAssert(presenter.logoutCalled)
    }
    
    func testProfileViewLogoutTokenIsEqualNil() {
        //given
        let viewController = ProfileViewControllerSpy()
        let presenter = ProfileViewPresenterSpy()
        viewController.configure(presenter)
        
        //when
        presenter.logout()
        
        //then
        XCTAssertNil(OAuth2TokenStorage().token)
    }
}
