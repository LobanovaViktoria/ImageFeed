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
    
    var likeOrDislikeAction: (() -> Void)?
    
    static let reuseIdentifier = "ImagesListCell"
   

    @IBAction func likeOrDislikeButtonTapped(_ sender: Any) {
        if let action = likeOrDislikeAction {
            action()
        }
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        
        // Отменяем загрузку, чтобы избежать багов при переиспользовании ячеек
        cellImageView.kf.cancelDownloadTask()
    }
}


