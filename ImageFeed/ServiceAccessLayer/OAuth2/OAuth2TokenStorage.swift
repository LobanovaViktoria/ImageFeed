//
//  OAuth2TokenStorage.swift
//  ImageFeed
//
//  Created by Viktoria Lobanova on 03.03.2023.
//

import Foundation
import SwiftKeychainWrapper

final class OAuth2TokenStorage {
    let kToken = "token"
    var token: String? {
        set {
            let isSuccess = KeychainWrapper.standard.set(kToken, forKey: "token")
            guard isSuccess else {
                fatalError("Невозможно сохранить token")
            }
        }
        get {
            KeychainWrapper.standard.string(forKey: kToken)
        }
    }
}
