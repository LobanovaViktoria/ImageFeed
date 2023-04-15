//
//  ImagesListPresenter.swift
//  ImageFeed
//
//  Created by Viktoria Lobanova on 15.04.2023.
//

import Foundation

public protocol ImagesListPresenterProtocol {
    var view: ImagesListViewControllerProtocol? { get set }
}

final class ImagesListPresenter: ImagesListPresenterProtocol {
    weak var view: ImagesListViewControllerProtocol?  
}
