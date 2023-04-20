//
//  ImageFeedUITests.swift
//  ImageFeedUITests
//
//  Created by Viktoria Lobanova on 19.01.2023.
//

import XCTest
@testable import ImageFeed

final class ImageFeedUITests: XCTestCase {
    private let app = XCUIApplication() // переменная приложения
    
    override func setUpWithError() throws {
        
        continueAfterFailure = false
        app.launch() // запускаем приложение перед каждым тестом
    }
    
    func testAuth() throws {
        // тестируем сценарий авторизации
        
        // Нажать кнопку авторизации
        /*
              У приложения мы получаем список кнопок на экране и получаем нужную кнопку по тексту на ней
              Далее вызываем функцию tap() для нажатия на этот элемент
            */
        app.buttons["Authenticate"].tap()
        //sleep(5)
            // Подождать, пока экран авторизации открывается и загружается
        let webView = app.webViews["UnsplashWebView"]
        sleep(5)
        print(webView.buttons)
        // Ввести данные в форму
        let loginTextField = webView.descendants(matching: .textField).element
        sleep(5)
        
        loginTextField.tap()
        loginTextField.typeText("va_klevtsova@mail.ru")
        loginTextField.swipeUp() //поможет скрыть клавиатуру после ввода текста
        
        let passwordTextField = webView.descendants(matching: .secureTextField).element
        sleep(5)
        
        passwordTextField.tap()
        passwordTextField.typeText("Misha160189")
        webView.swipeUp()
        
        // Нажать кнопку логина
        let webViewsQuery = app.webViews
        webViewsQuery.buttons["Login"].tap()
         
        let tablesQuery = app.tables
        let cell = tablesQuery.children(matching: .cell).element(boundBy: 0)
        sleep(5)
        //XCTAssertTrue(cell.waitForExistence(timeout: 5)) // Подождать, пока открывается экран ленты
        print(app.debugDescription)
    }
    
//    func testFeed() throws {
//        let tablesQuery = app.tables
//
//        let cell = tablesQuery.children(matching: .cell).element(boundBy: 0)
//        XCTAssertTrue(cell.waitForExistence(timeout: 2)) // Подождать, пока открывается экран ленты
//        // Подождать, пока открывается и загружается экран ленты
//        // Сделать жест «смахивания» вверх по экрану для его скролла
//        cell.swipeUp()
//        sleep(2)
        
//        let cellToLike = tablesQuery.children(matching: .cell).element(boundBy: 1)
//        // Поставить лайк в ячейке верхней картинки
//
//        cellToLike.buttons["likeOrDislakeButton"].tap()
//        XCTAssertTrue(cellToLike.waitForExistence(timeout: 4))
//
        // Отменить лайк в ячейке верхней картинки
//        cellToLike.buttons["likeOrDislakeButton"].tap()
//        XCTAssertTrue(cellToLike.waitForExistence(timeout: 2))
//
//        // Нажать на верхнюю ячейку
//        cellToLike.tap()
//
//        // Подождать, пока картинка открывается на весь экран
//        XCTAssertTrue(cellToLike.waitForExistence(timeout: 5))
//
//        let image = app.scrollViews.images.element(boundBy: 0)
//
//        // Увеличить картинку
//        image.pinch(withScale: 3, velocity: 1)
        
//        // Уменьшить картинку
//        image.pinch(withScale: 0.5, velocity: -1)
//
//        // Вернуться на экран ленты
//        let backButton = app.buttons["backButton"]
//        backButton.tap()
//        XCTAssertTrue(backButton.waitForExistence(timeout: 2))
//    }
    
//    func testProfile() throws {
//
//        // Подождать, пока открывается и загружается экран ленты
//        let tablesQuery = app.tables
//
//        let cell = tablesQuery.children(matching: .cell).element(boundBy: 0)
//        XCTAssertTrue(cell.waitForExistence(timeout: 2))
//
//        // Перейти на экран профиля
//        let profile = app.tabBars.buttons.element(boundBy: 1)
//        profile.tap()
//
//        // Проверить, что на нём отображаются ваши персональные данные
//        XCTAssertTrue(app.staticTexts["Viktoria Lobanova"].exists)
//        XCTAssertTrue(app.staticTexts["@lobanova_viktoria"].exists)
//        XCTAssertTrue(app.staticTexts["Hello, world"].exists)
//
//        // Нажать кнопку логаута
//        app.buttons["logoutButton"].tap()
//        app.alerts["Пока, пока!"].scrollViews.otherElements.buttons["OK"].tap()
//
//        // Проверить, что открылся экран авторизации
//        let webView = app.webViews["UnsplashWebView"]
//        XCTAssert(webView.isEnabled)
//    }
}
