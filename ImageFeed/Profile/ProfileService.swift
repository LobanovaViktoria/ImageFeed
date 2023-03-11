//
//  ProfileService.swift
//  ImageFeed
//
//  Created by Viktoria Lobanova on 08.03.2023.
//

import Foundation

struct ProfileResult: Codable {
    let userName: String?
    let firstName: String?
    let lastName: String?
    let bio: String?
    
    enum CodingKeys: String, CodingKey {
        case userName = "username"
        case firstName = "first_name"
        case lastName = "last_name"
        case bio = "bio"
    }
}

public struct Profile {
    let userName: String?
    let name: String?
    let loginName: String?
    let bio: String?
}

final class ProfileService {
    
    static let shared = ProfileService()
    private (set) var profile: Profile?
    
    public func fetchProfile(_ token: String, completion: @escaping (Result<Profile, Error>) -> Void) {
        guard let request = fetchProfileRequest(token) else { return }
        let decoder = JSONDecoder()
        let fulfillCompletion: (Result<Profile, Error>) -> Void = { result in
            DispatchQueue.main.async {
                completion(result)
                return
            }
        }
       
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data,
               let response = response,
               let statusCode = (response as? HTTPURLResponse)?.statusCode
            {
                if 200 ..< 300 ~= statusCode,
                   let profileResult = try? decoder.decode(ProfileResult.self, from: data) {
                    self.profile = Profile(userName: profileResult.userName ?? "", name: "\(profileResult.firstName ?? "") " + "\(profileResult.lastName ?? "")", loginName: "@\(profileResult.userName ?? "")" , bio: profileResult.bio ?? "")
                    fulfillCompletion(.success(self.profile!))
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
    
    private func fetchProfileRequest(_ token: String) -> URLRequest? {
        guard let url = URL(string: "https://api.unsplash.com") else { return nil }
        var request = URLRequest.makeHTTPRequest(
            path: "/me",
            httpMethod: "GET",
            baseURL: url)
        request?.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return request
    }
}

