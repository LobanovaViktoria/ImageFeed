//
//  ImagesListService.swift
//  ImageFeed
//
//  Created by Viktoria Lobanova on 18.03.2023.
//

import Foundation

struct PhotoResult: Decodable {
    let id: String
    let createdAt: String?
    let welcomeDescription: String?
    let isLiked: Bool?
    let urls: ImageUrlsResult?
    let width: Int?
    let height: Int?
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case createdAt = "created_at"
        case welcomeDescription = "description"
        case isLiked = "liked_by_user"
        case urls = "urls"
        case width = "width"
        case height = "height"
    }
}

struct ImageUrlsResult: Decodable {
    let thumbImageURL: String?
    let largeImageURL: String?
    
    enum CodingKeys: String, CodingKey {
        case thumbImageURL = "thumb"
        case largeImageURL = "full"
    }
}

struct LikePhotoResult: Decodable {
    let photo: PhotoResult?
}

struct Photo {
    let id: String
    let size: CGSize
    let createdAt: Date?
    let welcomeDescription: String?
    let thumbImageURL: String?
    let largeImageURL: String?
    let isLiked: Bool
}

final class ImagesListService {
    static let didChangeNotification = Notification.Name(rawValue: "ImagesListServiceDidChange")
    static let shared = ImagesListService()
    private (set) var photos: [Photo] = []
    private var lastLoadedPage: Int?
    private let perPage = "10"
    private var task: URLSessionTask?
}

extension ImagesListService {
    
    func fetchPhotosNextPage() {
        //Логика для предотвращения гонки
        assert(Thread.isMainThread)
        task?.cancel()
        
        let page = lastLoadedPage == nil ? 1 : lastLoadedPage! + 1
        guard let token = OAuth2TokenStorage().token else { return }
        //Формирование URLRequest на получение картинок с unsplash.com
        guard let request = fetchImagesListRequest(token, page: String(page), perPage: perPage) else { return }
        
        //создание URLSessionDataTask на получение картинок с unsplash.com
        
        let task = URLSession.shared.objectTask(for: request) { [weak self] (result: Result<[PhotoResult], Error>) in
            DispatchQueue.main.async {
                guard let self = self else { return }
                self.task = nil
                switch result {
                case .success(let photoResults):
                    for photoResult in photoResults {
                        self.photos.append(self.convert(photoResult))
                    }
                    self.lastLoadedPage = page
                    NotificationCenter.default
                        .post(
                            name: ImagesListService.didChangeNotification,
                            object: self,
                            userInfo: ["Images" : self.photos])
                case .failure(_):
                    break
                }
            }
        }
        self.task = task
        task?.resume()
        
    }
    
    private func convert(_ photoResult: PhotoResult) -> Photo {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        let date = dateFormatter.date(from:photoResult.createdAt ?? "")
        
        return Photo.init(id: photoResult.id,
                          size: CGSize(width: photoResult.width ?? 0, height: photoResult.height ?? 0),
                          createdAt: date,
                          welcomeDescription: photoResult.welcomeDescription,
                          thumbImageURL: photoResult.urls?.thumbImageURL,
                          largeImageURL: photoResult.urls?.largeImageURL,
                          isLiked: photoResult.isLiked ?? false)
    }
    
    private func fetchImagesListRequest(_ token: String, page: String, perPage: String) -> URLRequest? {
        guard let url = URL(string: "https://api.unsplash.com") else { return nil }
        var request = URLRequest.makeHTTPRequest(
            path: "/photos?page=\(page)&&per_page=\(perPage)",
            httpMethod: "GET",
            baseURL: url)
        request?.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return request
    }
    
    func changeLike(photoId: String, isLike: Bool, _ completion: @escaping (Result<Void, Error>) -> Void) {
        //Логика для предотвращения гонки
        assert(Thread.isMainThread)
        task?.cancel()
        
        guard let token = OAuth2TokenStorage().token else { return }
        //Формирование URLRequest на получение картинок с unsplash.com
        guard let request = postLikeRequest(token, photoId: photoId) else { return }
        
        //создание URLSessionDataTask для проставления лайка unsplash.com
        let task = URLSession.shared.objectTask(for: request) { [weak self] (result: Result<LikePhotoResult, Error>) in
            guard let self = self else { return }
            self.task = nil
            switch result {
            case .success(let photoResult):
                let isLiked = photoResult.photo?.isLiked ?? false
                if let index = self.photos.firstIndex(where: { $0.id == photoResult.photo?.id }) {
                    // Текущий элемент
                    let photo = self.photos[index]
                    // Копия элемента с инвертированным значением isLiked
                    let newPhoto = Photo(
                        id: photo.id,
                        size: photo.size,
                        createdAt: <#T##Date?#>,
                        welcomeDescription: <#T##String?#>,
                        thumbImageURL: <#T##String?#>,
                        largeImageURL: <#T##String?#>,
                        isLiked: <#T##Bool#>)
                }
                
                
                //var photos = ImagesListService.shared.photos
                print("isLiked = \(String(describing: isLiked))")
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
        self.task = task
        task?.resume()
    }
    
    private func postLikeRequest(_ token: String, photoId: String) -> URLRequest? {
        //POST /photos/:id/like
        guard let url = URL(string: "https://api.unsplash.com") else { return nil }
        var requestPost = URLRequest.makeHTTPRequest(
            path: "photos/\(photoId)/like",
            httpMethod: "POST",
            baseURL: url)
        requestPost?.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return requestPost
    }
    
    private func deleteLikeRequest(_ token: String, photoId: String, isLike: Bool) -> URLRequest? {
        //DELETE /photos/:id/like
        guard let url = URL(string: "https://api.unsplash.com") else { return nil }
        var requestDelete = URLRequest.makeHTTPRequest(
            path: "photos/\(photoId)/like",
            httpMethod: "DELETE",
            baseURL: url)
        requestDelete?.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return requestDelete
    }
}
