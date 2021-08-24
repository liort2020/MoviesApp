//
//  WebError.swift
//  MoviesApp
//
//  Created by Lior Tal on 21/08/2021.
//  Copyright © 2021 Lior Tal. All rights reserved.
//

import Foundation

enum WebError: Error {
    case invalidURL
    case noResponse
    case httpCode(HTTPError)
}

enum HTTPError: Error {
    case badRequest
    case unauthorized
    case notFound
    case unprocessableRequest
    case serverError
    case unknown
    
    init(code: Int) {
        switch code {
        case 400:
            self = .badRequest
        case 401:
            self = .unauthorized
        case 404:
            self = .notFound
        case 422:
            self = .unprocessableRequest
        case 500:
            self = .serverError
        default:
            self = .unknown
        }
    }
}

extension HTTPURLResponse {
    func isValidStatusCode() -> Bool {
        (200...299).contains(statusCode)
    }
}
