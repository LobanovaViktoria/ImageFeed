//
//  ViewController.swift
//  ImageFeed
//
//  Created by Viktoria Lobanova on 19.01.2023.
//
import UIKit
import Kingfisher

final class ImagesListViewController: UIViewController {
    
    @IBOutlet private var tableView: UITableView!
    
    private let showSingleImageSegueIdentifier = "ShowSingleImage"
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter
    }()
    
    private var photos: [Photo] = []
    private let imagesListService = ImagesListService.shared
    private var imagesListServiceObserver: NSObjectProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
        imagesListServiceObserver = NotificationCenter.default.addObserver(
            forName: ImagesListService.didChangeNotification,
            object: nil, queue: .main
        ) { [weak self] _ in
            guard let self = self else { return }
            self.updateTableViewAnimated()
        }
        imagesListService.fetchPhotosNextPage()
    }
    
    private func updateTableViewAnimated() {
        let oldCount = photos.count
        let newCount = imagesListService.photos.count
        if oldCount != newCount {
            photos = imagesListService.photos
            tableView.performBatchUpdates{
                var indexPath: [IndexPath] = []
                for i in oldCount..<newCount {
                    indexPath.append(IndexPath(row: i, section: 0))
                }
                tableView.insertRows(at: indexPath, with: .automatic)
            } completion: { _ in }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showSingleImageSegueIdentifier {
            let viewController = segue.destination as? SingleImageViewController
            let indexPath = sender as? IndexPath
            guard let index = indexPath?.row else { return }
            //            let image = UIImage(named: photosName[index])
            //            viewController?.image = image
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
    
    func configCell(for cell: ImagesListCell, with indexPath: IndexPath) {
        if let urlString = imagesListService.photos[indexPath.row].thumbImageURL,
           let imagesURL = URL(string: urlString) {
            cell.cellImageView.kf.indicatorType = .activity
            cell.cellImageView.kf.setImage(with: imagesURL,
                                           placeholder: UIImage(named: "scribble")) { [weak self] _ in
                guard let self = self else { return }
                self.tableView.reloadRows(at: [indexPath], with: .automatic)
            }
            
            cell.dateLabel.text = dateFormatter.string(from: imagesListService.photos[indexPath.row].createdAt ?? Date())
            
            let isLiked = imagesListService.photos[indexPath.row].isLiked == false
            let likeImage = isLiked ? UIImage(named: "noActive") : UIImage(named: "yesActive")
            cell.likeOrDislakeButton.setImage(likeImage, for: .normal)
            
            cell.likeOrDislikeAction = { [weak self] in
                guard let self = self else { return }
                let photoId = self.imagesListService.photos[indexPath.row].id
                cell.likeOrDislakeButton.setImage(UIImage(named: "yesActive"), for: .normal)
                self.imagesListService.changeLike(photoId: photoId, isLike: true) { [weak self] result in
                    guard let self = self else { return }
                    switch result {
                    case .success(_):
                        break
                    case .failure(_):
                        print("не удалось поставить лайк")
                        cell.likeOrDislakeButton.imageView?.image = UIImage(named: "noActive")
                    }
                }
            }
        }
    }
}

extension ImagesListViewController: UITableViewDelegate {
    
    // Метод отвечает за действия, которые будут выполнены при тапе по ячейке таблицы
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: showSingleImageSegueIdentifier, sender: indexPath)
    }
    
    // Метод, который вычисляет высоту ячейки
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let imagesHeight = imagesListService.photos[indexPath.row].size.height
        let imagesWidth = imagesListService.photos[indexPath.row].size.width
        let imageInsets = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
        let imageViewWidth = tableView.bounds.width - imageInsets.left - imageInsets.right
        let heightForRowAt = imagesHeight * imageViewWidth / imagesWidth + imageInsets.top + imageInsets.bottom
        return heightForRowAt
    }
}

extension ImagesListViewController: UITableViewDataSource {
    
    // Метод, который определяет количество ячеек в секции таблицы
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return imagesListService.photos.count
    }
    
    // Если indexPath соответствует индексу последней строки в таблице, то вызывается fetchPhotosNextPage()
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == tableView.numberOfRows(inSection: 0) - 1 {
            imagesListService.fetchPhotosNextPage()
        }
    }
    
    // Метод протокола, который возвращает ячейку
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ImagesListCell.reuseIdentifier, for: indexPath)
        
        guard let imageListCell = cell as? ImagesListCell else {
            return UITableViewCell()
        }
        configCell(for: imageListCell, with: indexPath)
        
        return imageListCell
    }
}


