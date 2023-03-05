//
//  OAuth2TokenStorage.swift
//  ImageFeed
//
//  Created by Viktoria Lobanova on 03.03.2023.
//

import Foundation

final class OAuth2TokenStorage {
    let kToken = "token"
    var token: String? {
        set {
            UserDefaults.standard.set(newValue, forKey: kToken)
        }
        get {
            UserDefaults.standard.string(forKey: kToken)
        }
    }
}
