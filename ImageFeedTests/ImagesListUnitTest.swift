//
//  ImagesListUnitTest.swift
//  ImageFeedTests
//
//  Created by Viktoria Lobanova on 16.04.2023.
//

import XCTest
@testable import ImageFeed

final class ImagesListUnitTest: XCTestCase {
    
    func testDateToString() {
        //given
        let viewController = ImagesListViewController()
        let presenter = ImagesListPresenter()
        viewController.configure(presenter)
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd HH:mm"
        guard let date = formatter.date(from: "2022/08/31 22:31") else {
            return
        }
        
        //when
        let code = presenter.dateString(date)
        
        //then
        XCTAssertEqual(code, "31 августа 2022 г.")
    }
    
    func testInvalidDateToString() {
        //given
        let viewController = ImagesListViewController()
        let presenter = ImagesListPresenter()
        viewController.configure(presenter)
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd HH:mm"
        guard let date = formatter.date(from: "2022/08/31 22:31") else {
            return
        }
        
        //when
        let code = presenter.dateString(date)
        
        //then
        XCTAssertFalse(code == "30 августа 2022 г.")
    }
}
