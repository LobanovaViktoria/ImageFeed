//
//  ImagesListViewPresenter.swift
//  ImageFeed
//
//  Created by Viktoria Lobanova on 07.04.2023.
//

import Foundation

public protocol ImagesListViewPresenterProtocol {
    var view: ImagesListViewControllerProtocol? { get set }
}

final class ImagesListViewPresenter: ImagesListViewPresenterProtocol {
    weak var view: ImagesListViewControllerProtocol?
    
    
}
