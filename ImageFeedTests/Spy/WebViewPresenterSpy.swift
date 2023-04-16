//
//  WebViewPresenterSpy.swift
//  ImageFeed
//
//  Created by Viktoria Lobanova on 15.04.2023.
//

import Foundation

final class WebViewPresenterSpy: WebViewPresenterProtocol {
    
    var view: WebViewViewControllerProtocol?
    var viewDidLoadCalled: Bool = false
    
    
    func viewDidLoad() {
        viewDidLoadCalled = true
    }
    
    func didUpdateProgressValue(_ newValue: Double) {
        
    }
    
    func code(from url: URL) -> String? {
        return nil
    }
    
}


