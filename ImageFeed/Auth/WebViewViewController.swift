//
//  WebViewViewController.swift
//  ImageFeed
//
//  Created by Viktoria Lobanova on 28.02.2023.
//

import UIKit
import WebKit

private struct APIConstants {
    static let authorizeURLString = "https://unsplash.com/oauth/authorize"
    static let code = "code"
    static let authorizathionPath = "/oauth/authorize/native"
}

protocol WebViewViewControllerDelegate: AnyObject {
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String)
    func webViewViewControllerDidCancel(_ vc:WebViewViewController)
    }

final class WebViewViewController: UIViewController {
    
    @IBOutlet private var webView: WKWebView!
    
    weak var delegate: WebViewViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        webView.navigationDelegate = self
        
        loadWebView()
    }
    
    @IBAction private func didTapBackButton(_ sender: Any?) {
        delegate?.webViewViewControllerDidCancel(self)
    }
}
    private extension WebViewViewController {
        func loadWebView() {
            var urlComponents = URLComponents(string: APIConstants.authorizeURLString)
            urlComponents?.queryItems = [
            URLQueryItem(name: "client_id", value: accessKey),
            URLQueryItem(name: "redirect_uri", value: redirectURI),
            URLQueryItem(name: "response_type", value: "code"),
            URLQueryItem(name: "scope", value: accessScope)
            ]
            if let url = urlComponents?.url {
                let request = URLRequest(url: url)
                webView.load(request)
            }
        }
        
//        func fetchCode(from url: URL?) -> String? {
//            if let url = url,
//            let components = URLComponents(string: url.absoluteString),
//               components.path == APIConstants.authorizathionPath,
//               let codeItem = components.queryItems?.first(where: { $0.name == APIConstants.code }) {
//                return codeItem.value
//            } else {
//                return nil
//            }
//        }
        
        func fetchCode(from navigationAction: WKNavigationAction) -> String? {
            if let url = navigationAction.request.url,
            let components = URLComponents(string: url.absoluteString),
               components.path == APIConstants.authorizathionPath,
               let items = components.queryItems,
               let codeItem = items.first(where: { $0.name == APIConstants.code }) {
                return codeItem.value
            } else {
                return nil
            }
        }
    }

extension WebViewViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
       // print("ITS LIT", navigationAction.request.url)
       
        if let code = fetchCode(from: navigationAction) {
            delegate?.webViewViewController(self, didAuthenticateWithCode: code)
            decisionHandler(.cancel)
        } else {
            decisionHandler(.allow)
        }
    }
}


    
   

