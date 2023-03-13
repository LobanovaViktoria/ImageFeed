//
//  OAuth2TokenStorage.swift
//  ImageFeed
//
//  Created by Viktoria Lobanova on 03.03.2023.
//

import Foundation
import SwiftKeychainWrapper

final class OAuth2TokenStorage {
    private let kToken = "token"
    var token: String? {
        set {
            guard let token = newValue else {
                KeychainWrapper.standard.removeObject(forKey: kToken)
                return
            }
            let isSuccess = KeychainWrapper.standard.set(token, forKey: kToken)
            guard isSuccess else {
                fatalError("Невозможно сохранить token")
            }
        }
        get {
            KeychainWrapper.standard.string(forKey: kToken)
        }
    }
}
