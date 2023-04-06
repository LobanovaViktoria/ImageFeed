//
//  WebViewViewControllerSpy.swift
//  ImageFeed
//
//  Created by Viktoria Lobanova on 06.04.2023.
//

import ImageFeed
import Foundation
import UIKit

final class WebViewViewControllerSpy: UIViewController, WebViewViewControllerProtocol {
    var loadRequestCalled: Bool = false
    var presenter: ImageFeed.WebViewPresenterProtocol?
    
    func load(request: URLRequest) {
        loadRequestCalled = true
    }
    
    func setProgressValue(_ newValue: Float) {
        
    }
    
    func setProgressHidden(_ isHidden: Bool) {
        
    }
    
    
}
