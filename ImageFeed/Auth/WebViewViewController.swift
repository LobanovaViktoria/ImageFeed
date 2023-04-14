//
//  WebViewViewController.swift
//  ImageFeed
//
//  Created by Viktoria Lobanova on 28.02.2023.
//

import UIKit
import WebKit

public protocol WebViewViewControllerProtocol: AnyObject {
    var presenter: WebViewPresenterProtocol? { get set }
    func load(request: URLRequest)
    func setProgressValue(_ newValue: Float)
    func setProgressHidden(_ isHidden: Bool)
}

protocol WebViewViewControllerDelegate: AnyObject {
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String)
    func webViewViewControllerDidCancel(_ vc:WebViewViewController)
}

final class WebViewViewController: UIViewController, WebViewViewControllerProtocol, WebViewViewControllerDelegate {
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String) {
        
    }
    
    func webViewViewControllerDidCancel(_ vc: WebViewViewController) {
        dismiss(animated: true)
    }
    
    
    //    @IBOutlet private var webView: WKWebView!
    //@IBOutlet private var progressView: UIProgressView!
    
    let webView = WKWebView()
    let progressView = UIProgressView()
    
    private lazy var navBackButton: UIButton = {
        let button = UIButton.systemButton(
            with: UIImage(named: "nav_back_button_black")!,
            target: self,
            action: #selector(Self.didTapBackButton)
        )
        button.accessibilityIdentifier = "navBackButton"
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    var presenter: WebViewPresenterProtocol?
    
    private var estimatedProgressObservation: NSKeyValueObservation?
    
    weak var delegate: WebViewViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
       // presenter?.viewDidLoad()
        addSubviews()
        setupLayout()
        let authHelper = AuthHelper()
        let webViewViewController = WebViewViewController()
        let webViewPresenter = WebViewPresenter(authHelper: authHelper)
        webViewViewController.presenter = webViewPresenter
        let request = authHelper.authRequest()
        load(request: request)
        presenter?.didUpdateProgressValue(0)
        webViewPresenter.view = webViewViewController
        webViewViewController.delegate = self
        webView.navigationDelegate = self
        
        
        estimatedProgressObservation = webView.observe(
            \.estimatedProgress,
             options: [],
             changeHandler: { [weak self] _, _ in
                 guard let self = self else { return }
                 self.presenter?.didUpdateProgressValue(self.webView.estimatedProgress)
             })
    }
    
    @objc private func didTapBackButton(_ sender: Any?) {
        delegate?.webViewViewControllerDidCancel(self)
        print("Press button")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    private func addSubviews() {
        view.addSubview(webView)
        webView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(navBackButton)
        
        view.addSubview(progressView)
        progressView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            
//            webView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            webView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 0),
            webView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0),
            webView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 0),
            
            navBackButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 55),
            navBackButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 9),
            
            progressView.topAnchor.constraint(equalTo: navBackButton.bottomAnchor),
            progressView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 0),
            progressView.bottomAnchor.constraint(equalTo: webView.safeAreaLayoutGuide.topAnchor, constant: 0),
            progressView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 0)
            
            
        ])
    }
    
    func load(request: URLRequest) {
        webView.load(request)
    }
    
    func setProgressValue(_ newValue: Float) {
        progressView.progress = newValue
    }
    
    func setProgressHidden(_ isHidden: Bool) {
        progressView.isHidden = isHidden
    }
}

private extension WebViewViewController {
    
    func fetchCode(from navigationAction: WKNavigationAction) -> String? {
        if let url = navigationAction.request.url {
            return presenter?.code(from: url)
        }
        return nil
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





