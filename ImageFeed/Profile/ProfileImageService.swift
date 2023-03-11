//
//  ProfileImageService.swift
//  ImageFeed
//
//  Created by Viktoria Lobanova on 09.03.2023.
//

import Foundation

struct UserResult: Codable {
    let profileImage: ImageURL?
    
    enum KodingKeys: String, CodingKey {
        case profileImage = "profile_image"
    }
}

struct ImageURL: Codable {
    let small: URL?
}
    
final class ProfileImageService {
    static let DidChangeNotification = Notification.Name(rawValue: "ProfileImageProviderDidChange")
    static let shared = ProfileImageService()
    private (set) var avatarURL: String?
    
    // метод для получения URL small версии аватарки пользователя
    
    private func fetchProfileImageRequest(_ token: String, username: String) -> URLRequest? {
        guard let url = URL(string: "https://api.unsplash.com") else { return nil }
        var request = URLRequest.makeHTTPRequest(
            path: "/users/\(username)",
            httpMethod: "GET",
            baseURL: url)
        request?.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return request
    }
    
    func fetchProfileImageURL(_ token: String, username: String?, completion: ((Result<String?, Error>) -> Void)?) {
        guard let username = username else { return }
        guard let request = fetchProfileImageRequest(token, username: username) else { return }
        let decoder = JSONDecoder()
        let fulfillCompletion: (Result<String?, Error>) -> Void = { result in
            DispatchQueue.main.async {
                completion?(result)
                NotificationCenter.default
                    .post(name: ProfileImageService.DidChangeNotification, object: self, userInfo: ["URL" : self.avatarURL ?? ""])
                return
            }
        }
       
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data,
               let response = response,
               let statusCode = (response as? HTTPURLResponse)?.statusCode
            {
                if 200 ..< 300 ~= statusCode,
                   let userResult = try? decoder.decode(UserResult.self, from: data) {
                    self.avatarURL = userResult.profileImage?.small?.absoluteString
                    fulfillCompletion(.success(self.avatarURL))
                } else {
                    fulfillCompletion(.failure(NetworkError.httpStatusCode(statusCode)))
                }
            } else if let error = error {
                fulfillCompletion(.failure(NetworkError.urlRequestError(error)))
            } else {
                fulfillCompletion(.failure(NetworkError.urlSessionError))
            }
        }
        task.resume()
    }
    
}
