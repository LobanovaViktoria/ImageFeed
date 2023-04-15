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
    
    let webView = WKWebView()
    
    let progressView = UIProgressView()
    
    private var estimatedProgressObservation: NSKeyValueObservation?
    
    private lazy var backButton: UIButton = {
        let button = UIButton.systemButton(
            with: UIImage(named: "nav_back_button_black")!,
            target: self,
            action: #selector(didTapBackButton)
        )
        button.tintColor = .ypBlack
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    weak var delegate: WebViewViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addSubviews()
        setupLayout()
        
        progressView.progressTintColor = .ypBlack
        webView.navigationDelegate = self
        webView.translatesAutoresizingMaskIntoConstraints = false
        progressView.translatesAutoresizingMaskIntoConstraints = false
        
        estimatedProgressObservation = webView.observe(
            \.estimatedProgress,
             options: [],
             changeHandler: { [weak self] _, _ in
                 guard let self = self else { return }
                 self.updateProgress()
             })
        
        loadWebView()
    }
    
    @objc private func didTapBackButton() {
        delegate?.webViewViewControllerDidCancel(self)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        updateProgress()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    private func updateProgress() {
        progressView.progress = Float(webView.estimatedProgress)
        progressView.isHidden = fabs(webView.estimatedProgress - 1.0) <= 0.0001
    }
    
    private func addSubviews() {
        view.addSubview(webView)
        view.addSubview(backButton)
        view.addSubview(progressView)
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            
            webView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 0),
            webView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0),
            webView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 0),
            webView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            backButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 0),
            backButton.heightAnchor.constraint(equalToConstant: 50),
            backButton.widthAnchor.constraint(equalToConstant: 51),
            
            progressView.topAnchor.constraint(equalTo: backButton.bottomAnchor),
            progressView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 0),
            progressView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 0),
            progressView.heightAnchor.constraint(equalToConstant: 2),
     ])
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
        guard let url = urlComponents?.url else { return }
        let request = URLRequest(url: url)
       // guard let webView = webView else { return }
        webView.load(request)
        updateProgress()
    }
    
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
    func webView(_ webView: WKWebView,
                 decidePolicyFor navigationAction: WKNavigationAction,
                 decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if let code = fetchCode(from: navigationAction) {
            delegate?.webViewViewController(self, didAuthenticateWithCode: code)
            decisionHandler(.cancel)
        } else {
            decisionHandler(.allow)
        }
    }
}





