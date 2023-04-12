//
//  ProfileViewPresenter.swift
//  ImageFeed
//
//  Created by Viktoria Lobanova on 06.04.2023.
//


import Foundation
import WebKit

public protocol ProfileViewPresenterProtocol {
    var view: ProfileViewControllerProtocol? { get set }
    func avatarURL() -> URL?
    func updateProfileDetails() -> [String]?
    func logout()
    static func clean()
}

final class ProfileViewPresenter: ProfileViewPresenterProtocol {
    
    weak var view: ProfileViewControllerProtocol?
    
    func avatarURL() -> URL? {
        guard let profileImageURL = ProfileImageService.shared.avatarURL,
            let url = URL(string: profileImageURL)
        else { return nil }
        return url
    }
    
    func updateProfileDetails() -> [String]? {
        guard let userName = ProfileService.shared.profile?.name,
              let userLogin = ProfileService.shared.profile?.loginName,
              let userStatus = ProfileService.shared.profile?.bio
        else { return nil }
        
        return [userName, userLogin, userStatus]
    }
    
    func logout() {
        OAuth2TokenStorage().token = nil
        ProfileViewPresenter.clean()
        cleanServicesData()
        view?.switchToSplashViewController()
    }
  
    func cleanServicesData() {
        ImagesListService.shared.clean()
        ProfileService.shared.clean()
        ProfileImageService.shared.clean()
        
    }
    static func clean() {
        // Очищаем все куки из хранилища
        HTTPCookieStorage.shared.removeCookies(since: Date.distantPast)
        // Запрашиваем все данные из локального хранилища
        WKWebsiteDataStore.default().fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
            // Массив полученных записей удаляем из хранилища
            records.forEach { record in
                WKWebsiteDataStore.default().removeData(ofTypes: record.dataTypes, for: [record], completionHandler: {})
            }
        }
    }
    
}
