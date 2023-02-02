//
//  ViewController.swift
//  ImageFeed
//
//  Created by Viktoria Lobanova on 19.01.2023.
//
import UIKit

class ImagesListViewController: UIViewController {
    
    @IBOutlet private var tableView: UITableView!
    
    private let photosName: [String] = Array(0..<21).map{ "\($0)" }
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
    }
    
    func configCell(for cell: ImagesListCell, with indexPath: IndexPath) {
        guard let photosName = UIImage(named: photosName[indexPath.row]) else {
            return print("Невозможно получить картинку с таким именем")
        }
        
        cell.imageCell.image = photosName
        cell.dateCell.text = dateFormatter.string(from: Date())
        
        if indexPath.row % 2 == 0 {
            cell.likeOrDislakeButton.imageView?.image = UIImage(named: "yesActive")
        } else {
            cell.likeOrDislakeButton.imageView?.image = UIImage(named: "noActive")
        }
    }
}

extension ImagesListViewController: UITableViewDelegate {
    
    // Метод отвечает за действия, которые будут выполнены при тапе по ячейке таблицы
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // Метод, который вычисляет высоту ячейки
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let photosName = UIImage(named: photosName[indexPath.row]) else {
            return 0
        }
        let imageInsets = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
        let imageViewWidth = tableView.bounds.width - imageInsets.left - imageInsets.right
        let heightForRowAt = photosName.size.height * imageViewWidth / photosName.size.width + imageInsets.top + imageInsets.bottom
        return heightForRowAt
    }
}

extension ImagesListViewController: UITableViewDataSource {
    
    // Метод, который определяет количество ячеек в секции таблицы
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photosName.count
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

