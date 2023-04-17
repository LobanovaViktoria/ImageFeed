//
//  WebViewViewControllerSpy.swift
//  ImageFeedTests
//
//  Created by Viktoria Lobanova on 15.04.2023.
//

import Foundation
import ImageFeed

final class WebViewViewControllerSpy:  WebViewViewControllerProtocol {
    var presenter: ImageFeed.WebViewPresenterProtocol?
    
    var loadRequestCalled: Bool = false
        
    func load(request: URLRequest) {
        loadRequestCalled = true
    }
    
    func setProgressValue(_ newValue: Float) {
        
    }
    
    func setProgressHidden(_ isHidden: Bool) {
       
    }
    
}



