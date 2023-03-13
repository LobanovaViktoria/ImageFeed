//
//  NetworkError.swift
//  ImageFeed
//
//  Created by Viktoria Lobanova on 12.03.2023.
//

import Foundation

enum NetworkError: Error {
    case httpStatusCode(Int)
    case urlRequestError(Error)
    case urlSessionError
}
