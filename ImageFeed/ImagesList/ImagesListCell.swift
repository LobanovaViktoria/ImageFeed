//
//  ImagesListCell.swift
//  ImageFeed
//
//  Created by Viktoria Lobanova on 21.01.2023.
//
import UIKit
import Kingfisher

protocol ImagesListCellDelegate: AnyObject {
    func imageListCellDidTapLike(_ cell: ImagesListCell)
}

final class ImagesListCell: UITableViewCell {
    
    @IBOutlet var cellImageView: UIImageView!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var likeOrDislakeButton: UIButton!
    weak var delegate: ImagesListCellDelegate?
    
    static let reuseIdentifier = "ImagesListCell"
    
    @IBAction private func likeOrDislikeButtonTapped(_ sender: Any) {
        delegate?.imageListCellDidTapLike(self)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        // Отменяем загрузку, чтобы избежать багов при переиспользовании ячеек
        cellImageView.kf.cancelDownloadTask()
    }
    
    func setIsLiked(isLiked: Bool) {
        let isLiked = isLiked ? UIImage(named: "yesActive") : UIImage(named: "noActive")
        likeOrDislakeButton.setImage(isLiked, for: .normal)
    }
}


