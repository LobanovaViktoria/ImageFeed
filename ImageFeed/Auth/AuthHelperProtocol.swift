//
//  AuthHelperProtocol.swift
//  ImageFeed
//
//  Created by Viktoria Lobanova on 15.04.2023.
//

import Foundation

protocol AuthHelperProtocol {
    func authRequest() -> URLRequest?
    func code(from url: URL) -> String?
}

class AuthHelper: AuthHelperProtocol {
   
    let configuration: AuthConfiguration
    
    private let authorizathionPath = "/oauth/authorize/native"
    private let code = "code"
    
    init(configuration: AuthConfiguration = .standart) {
        self.configuration = configuration
    }
    
    func authRequest() -> URLRequest? {
        guard let url = authURL() else { return nil }
        return URLRequest(url: url)
    }
    
    func authURL() -> URL? {
        var urlComponents = URLComponents(string: configuration.authURLString)
        urlComponents?.queryItems = [
            URLQueryItem(name: "client_id", value: configuration.accessKey),
            URLQueryItem(name: "redirect_uri", value: configuration.redirectURI),
            URLQueryItem(name: "response_type", value: "code"),
            URLQueryItem(name: "scope", value: configuration.accessScope)
        ]
        guard let url = urlComponents?.url else { return nil }
        return url
    }
    
    func code(from url: URL) -> String? {
        if let urlComponents = URLComponents(string: url.absoluteString),
           urlComponents.path == authorizathionPath,
           let items = urlComponents.queryItems,
           let codeItem = items.first(where: { $0.name == code }) {
            return codeItem.value
        } else {
            return nil
        }
    }
}
