//
//  URLSession+Extentions.swift
//  ImageFeed
//
//  Created by Viktoria Lobanova on 12.03.2023.
//

import Foundation

extension URLSession {
    func objectTask<T: Decodable>(
        for request: URLRequest,
        completion: @escaping (Result<T, Error>) -> Void
    ) -> URLSessionTask? {
        let decoder = JSONDecoder()
        let task = request.data(for: request) { (result: Result<Data, Error>) in
            let response = result.flatMap { data -> Result<T, Error> in
                Result {
                    try decoder.decode(T.self, from: data)
                }
            }
            completion(response)
        }
        return task
    }
}
