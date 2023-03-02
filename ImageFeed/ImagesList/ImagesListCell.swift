//
//  ImagesListCell.swift
//  ImageFeed
//
//  Created by Viktoria Lobanova on 21.01.2023.
//
import UIKit

final class ImagesListCell: UITableViewCell {
    
    @IBOutlet var imageCell: UIImageView!
    @IBOutlet var dateCell: UILabel!
    @IBOutlet var likeOrDislakeButton: UIButton!
    static let reuseIdentifier = "ImagesListCell"
}
