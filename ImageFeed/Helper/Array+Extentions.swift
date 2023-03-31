//
//  Array+Extentions.swift
//  ImageFeed
//
//  Created by Viktoria Lobanova on 30.03.2023.
//

import Foundation

extension Array {
    func withReplaced(itemAt: Int, newValue: Photo) -> [Photo] {
        var photos = ImagesListService.shared.photos
        photos.replaceSubrange(itemAt...itemAt, with: [newValue])
        return photos
    }
}
