//
//  ImagesListCell.swift
//  ImageFeed
//
//  Created by Viktoria Lobanova on 21.01.2023.
//
import UIKit
import Kingfisher

final class ImagesListCell: UITableViewCell {
    
    @IBOutlet var cellImageView: UIImageView!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var likeOrDislakeButton: UIButton!
    static let reuseIdentifier = "ImagesListCell"
   

    override func prepareForReuse() {
        super.prepareForReuse()
        
        // Отменяем загрузку, чтобы избежать багов при переиспользовании ячеек
        cellImageView.kf.cancelDownloadTask()
    }
}


