//
//  WebViewPresenter.swift
//  ImageFeed
//
//  Created by Viktoria Lobanova on 15.04.2023.
//

import Foundation

private struct APIConstants {
    static let authorizeURLString = "https://unsplash.com/oauth/authorize"
    static let authorizathionPath = "/oauth/authorize/native"
    static let code = "code"
}

public protocol WebViewPresenterProtocol {
    func viewDidLoad()
    func didUpdateProgressValue(_ newValue: Double)
    func code(from url: URL) -> String?
    var view: WebViewViewControllerProtocol? { get set }
}

final class WebViewPresenter: WebViewPresenterProtocol {
  
    weak var view: WebViewViewControllerProtocol?
    
    func viewDidLoad() {
        var urlComponents = URLComponents(string: APIConstants.authorizeURLString)
        urlComponents?.queryItems = [
            URLQueryItem(name: "client_id", value: accessKey),
            URLQueryItem(name: "redirect_uri", value: redirectURI),
            URLQueryItem(name: "response_type", value: "code"),
            URLQueryItem(name: "scope", value: accessScope)
        ]
        guard let url = urlComponents?.url else { return }
        let request = URLRequest(url: url)
        didUpdateProgressValue(0)
        view?.load(request: request)
    }
    
    func didUpdateProgressValue(_ newValue: Double) {
        let newProgressValue = Float(newValue)
        view?.setProgressValue(newProgressValue)
        
        let shouldHideProgress = shouldHideProgress(for: newProgressValue)
        view?.setProgressHidden(shouldHideProgress)
    }
    
    func shouldHideProgress(for value: Float) -> Bool {
        abs(value - 1.0) <= 0.0001
    }
    
    func code(from url: URL) -> String? {
        if let urlComponents = URLComponents(string: url.absoluteString),
           urlComponents.path == APIConstants.authorizathionPath,
           let items = urlComponents.queryItems,
           let codeItem = items.first(where: { $0.name == APIConstants.code }) {
            return codeItem.value
        } else {
            return nil
        }
    }   
}
