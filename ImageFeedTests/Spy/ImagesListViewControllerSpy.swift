//
//  ImagesListViewControllerSpy.swift
//  ImageFeedTests
//
//  Created by Viktoria Lobanova on 16.04.2023.
//

import Foundation
import ImageFeed

final class ImagesListViewControllerSpy: ImagesListViewControllerProtocol {
    var presenter: ImageFeed.ImagesListPresenterProtocol?
    
    var configCellCalled: Bool = false
        
}
