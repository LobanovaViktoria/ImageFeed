//
//  ImagesListCell.swift
//  ImageFeed
//
//  Created by Viktoria Lobanova on 21.01.2023.
//
import UIKit

final class ImagesListCell: UITableViewCell {
    
    @IBOutlet weak var imageCell: UIImageView!
    @IBOutlet weak var dateCell: UILabel!
    @IBOutlet weak var likeOrDislakeButton: UIButton!
    static let reuseIdentifier = "ImagesListCell"
}
