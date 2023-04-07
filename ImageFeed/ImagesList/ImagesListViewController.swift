//
//  ViewController.swift
//  ImageFeed
//
//  Created by Viktoria Lobanova on 19.01.2023.
//
import UIKit
import Kingfisher

public protocol ImagesListViewControllerProtocol: AnyObject {
    var presenter: ImagesListViewPresenterProtocol? { get set }
}

final class ImagesListViewController: UIViewController, ImagesListViewControllerProtocol {
    
    var presenter: ImagesListViewPresenterProtocol?
    
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
    weak var delegate: ImagesListCellDelegate?
    
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
    
    func configure(_ presenter: ImagesListViewPresenterProtocol) {
        self.presenter = presenter
        self.presenter?.view = self
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
    
    func configCell(for cell: ImagesListCell, with indexPath: IndexPath) {
        if let urlString = imagesListService.photos[indexPath.row].thumbImageURL,
           let imagesURL = URL(string: urlString) {
            cell.cellImageView.kf.indicatorType = .activity
            cell.cellImageView.kf.setImage(with: imagesURL,
                                           placeholder: UIImage(named: "scribble")) { [weak self] _ in
                guard let self = self else { return }
                self.tableView.reloadRows(at: [indexPath], with: .automatic)
            }
            
            if let date = imagesListService.photos[indexPath.row].createdAt {
                cell.dateLabel.text = dateFormatter.string(from: date)
            } else {
                cell.dateLabel.text = ""
            }
            let isLiked = imagesListService.photos[indexPath.row].isLiked == false
            let likeImage = isLiked ? UIImage(named: "noActive") : UIImage(named: "yesActive")
            cell.likeOrDislakeButton.setImage(likeImage, for: .normal)
            cell.selectionStyle = .none
        }
    }
}

extension ImagesListViewController: UITableViewDelegate {
    
    // Метод отвечает за действия, которые будут выполнены при тапе по ячейке таблицы
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let viewController = SingleImageViewController()
        
        if let urlFullString = imagesListService.photos[indexPath.row].largeImageURL,
           let imageFullURL = URL(string: urlFullString) {
            viewController.imageURL = imageFullURL
        }
        viewController.modalPresentationStyle = .fullScreen
        present(viewController, animated: true)
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
    
    private func showError() {
        let alertController = UIAlertController(
            title: "Что-то пошло не так(",
            message: "Не удалось войти в систему",
            preferredStyle: .alert)
        let action = UIAlertAction(
            title: "OK",
            style: .default,
            handler: nil)
        alertController.addAction(action)
        present(alertController, animated: true, completion: nil)
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
        imageListCell.delegate = self
        
        configCell(for: imageListCell, with: indexPath)
        
        return imageListCell
    }
}

extension ImagesListViewController: ImagesListCellDelegate {
    func imageListCellDidTapLike(_ cell: ImagesListCell) {
        
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        let photo = photos[indexPath.row]
        // Покажем лоадер
        UIBlockingProgressHUD.show()
        imagesListService.changeLike(photoId: photo.id, isLike: photo.isLiked) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case.success:
                // Синхронизируем массив картинок с сервисом
                self.photos = self.imagesListService.photos
                // Изменим индикацию лайка картинки
                cell.setIsLiked(isLiked: self.photos[indexPath.row].isLiked)
                // Уберем лоадер
                UIBlockingProgressHUD.dismiss()
            case.failure:
                // Уберём лоадер
                UIBlockingProgressHUD.dismiss()
                // Покажем, что что-то пошло не так
                self.showError()
            }
        }
    }
}

