//
//  ProfileViewPresenterSpy.swift
//  ImageFeed
//
//  Created by Viktoria Lobanova on 07.04.2023.
//

import ImageFeed
import Foundation
import WebKit

final class ProfileViewPresenterSpy: ProfileViewPresenterProtocol {
    func updateProfileDetails() -> [String]? {
        return nil
    }
    
    weak var view: ProfileViewControllerProtocol?
    var logoutCalled: Bool = false
    
   
    func avatarURL() -> URL? {
//        guard let profileImageURL = ProfileImageService.shared.avatarURL,
//            let url = URL(string: profileImageURL)
//        else { return nil }
        return nil
    }
    
    func logout() {
    logoutCalled = true
    OAuth2TokenStorage().token = nil
//        ProfileViewPresenter.clean()
//        cleanServicesData()
//        view?.switchToSplashViewController()
    }
  
    func cleanServicesData() {
//        ImagesListService.shared.clean()
//        ProfileService.shared.clean()
//        ProfileImageService.shared.clean()
        
    }
    static func clean() {
//        // Очищаем все куки из хранилища
//        HTTPCookieStorage.shared.removeCookies(since: Date.distantPast)
//        // Запрашиваем все данные из локального хранилища
//        WKWebsiteDataStore.default().fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
//            // Массив полученных записей удаляем из хранилища
//            records.forEach { record in
//                WKWebsiteDataStore.default().removeData(ofTypes: record.dataTypes, for: [record], completionHandler: {})
//            }
//        }
    }
    
}
