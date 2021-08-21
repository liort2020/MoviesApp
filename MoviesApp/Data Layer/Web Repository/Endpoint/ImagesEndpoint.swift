//
//  ImagesEndpoint.swift
//  MoviesApp
//
//  Created by Lior Tal on 21/08/2021.
//  Copyright © 2021 Lior Tal. All rights reserved.
//

import Foundation

extension RealImagesWebRepository {
    enum ImagesEndpoint: Endpoint {
        case getPosterImage(path: String)
        
        var path: String {
            switch self {
            case let .getPosterImage(path):
                return path
            }
        }
        
        var method: HTTPMethod {
            switch self {
            case .getPosterImage:
                return .get
            }
        }
        
        var headers: [String : String]? {
            ["Content-Type": "application/json"]
        }
        
        func queryParameters(page: Int? = nil) -> [String: String]? {
            ["api_key": Constants.apiKey]
        }
        
        func body() throws -> Data? {
            return nil
        }
    }
}
