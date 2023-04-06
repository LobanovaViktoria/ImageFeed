//
//  ProfileImageService.swift
//  ImageFeed
//
//  Created by Viktoria Lobanova on 09.03.2023.
//

import Foundation

struct UserResult: Decodable {
    let profileImage: ImageURL?
    
    enum CodingKeys: String, CodingKey {
        case profileImage = "profile_image"
    }
}

struct ImageURL: Decodable {
    let small: String?
}

final class ProfileImageService {
    static let didChangeNotification = Notification.Name(rawValue: "ProfileImageProviderDidChange")
    static let shared = ProfileImageService()
    private (set) var avatarURL: String?
    private var task: URLSessionTask?
    
    func clean() {
        avatarURL = nil
        task?.cancel()
        task = nil
    }
}

extension ProfileImageService {
    
    func fetchProfileImageURL(_ token: String, username: String?, completion: @escaping (Result<String?, Error>) -> Void) {
        
        //Логика для предотвращения гонки
        assert(Thread.isMainThread)
        task?.cancel()
        
        //Формирование URLRequest на получение публичных данных своего профиля
        guard let username = username else { return }
        guard let request = fetchProfileImageRequest(token, username: username) else { return }
        
        //создание URLSessionDataTask на получение публичных данных своего профиля
        
        let task = URLSession.shared.objectTask(for: request) { [weak self] (result: Result<UserResult, Error>) in
            guard let self = self else { return }
            self.task = nil
            switch result {
            case .success(let userResult):
                self.avatarURL = userResult.profileImage?.small
                completion(.success(self.avatarURL))
                NotificationCenter.default
                    .post(
                        name: ProfileImageService.didChangeNotification,
                        object: self,
                        userInfo: ["URL" : self.avatarURL ?? ""])
            case .failure(let error):
                completion(.failure(error))
            }
        }
        self.task = task
        task?.resume()
    }
    
    private func fetchProfileImageRequest(_ token: String, username: String) -> URLRequest? {
        var request = URLRequest.makeHTTPRequest(
            path: "/users/\(username)",
            httpMethod: "GET",
            baseURL: AuthConfiguration.standart.defaultBaseURL)
        request?.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return request
    }
}
