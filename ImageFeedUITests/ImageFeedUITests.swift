//
//  ImageFeedUITests.swift
//  ImageFeedUITests
//
//  Created by Viktoria Lobanova on 19.01.2023.
//

import XCTest
@testable import ImageFeed

class ImageFeedUITests: XCTestCase {
    private let app = XCUIApplication() // переменная приложения
    override func setUpWithError() throws {
        continueAfterFailure = false // настройка выполнения тестов, которая прекратит выполнения тестов, если в тесте что-то пошло не так
        
        app.launch() // запускаем приложение перед каждым тестом
    }
    
    func testAuth() throws {
        // тестируем сценарий авторизации
        app.buttons["Authenticate"].tap()
        let webView = app.webViews["UnsplashWebView"]
        
        sleep(2)
        
        let loginTextField = webView.descendants(matching: .textField).element
        sleep(2)
        
        loginTextField.tap()
        loginTextField.typeText("va_klevtsova@mail.ru")
        loginTextField.swipeUp()
        // webView.swipeUp()
        
        let passwordTextField = webView.descendants(matching: .secureTextField).element
        sleep(2)
        
        passwordTextField.tap()
        passwordTextField.typeText("Misha160189")
        webView.swipeUp()
        
        let webViewsQuery = app.webViews
        webViewsQuery.buttons["Login"].tap()
        
        let tablesQuery = app.tables
        let cell = tablesQuery.children(matching: .cell).element(boundBy: 0)
        
        sleep(2)
    }
    
    func testFeed() throws {
        // тестируем сценарий ленты
        
        let tablesQuery = app.tables
        
        let cell = tablesQuery.children(matching: .cell).element(boundBy: 0)
        cell.swipeUp()
        
        sleep(2)
        
        let cellToLike = tablesQuery.children(matching: .cell).element(boundBy: 1)
        
        cellToLike.buttons["noActive"].tap()
        sleep(2)
        
        cellToLike.buttons["yesActive"].tap()
        sleep(2)
        
        cellToLike.tap()
        
        sleep(2)
        
        let image = app.scrollViews.images.element(boundBy: 0)
        image.pinch(withScale: 3, velocity: 1)
        image.pinch(withScale: 0.5, velocity: -1)
        
        let navBackButtonWhiteButton = app.buttons["nav_back_button"]
        navBackButtonWhiteButton.tap()
    }
    
    func testProfile() throws {
        sleep(3)
        app.tabBars.buttons.element(boundBy: 1).tap()
        
        XCTAssertTrue(app.staticTexts["Viktoria Lobanova"].exists)
        XCTAssertTrue(app.staticTexts["@lobanova_viktoria"].exists)
        
        app.buttons["logoutButton"].tap()
        app.alerts["Bye bye!"].scrollViews.otherElements.buttons["Yes action"].tap()
    }
}


