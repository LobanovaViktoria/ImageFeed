//
//  AuthViewController.swift
//  ImageFeed
//
//  Created by Viktoria Lobanova on 28.02.2023.
//

import UIKit

protocol AuthViewControllerDelegate: AnyObject {
    func authViewController(_ vc: AuthViewController, didAuthenticateWithCode code: String)
}

final class AuthViewController: UIViewController {
    
    @IBAction func showWebView(_ sender: Any) {
        let webViewViewController = WebViewViewController()
        webViewViewController.modalPresentationStyle = .fullScreen
        webViewViewController.delegate = self
        present(webViewViewController, animated: true)
    }
    
    weak var delegate: AuthViewControllerDelegate?
}

extension AuthViewController: WebViewViewControllerDelegate {
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String) {
        delegate?.authViewController(self, didAuthenticateWithCode: code)
    }
    
    func webViewViewControllerDidCancel(_ vc: WebViewViewController) {
        dismiss(animated: true)
    }
}
