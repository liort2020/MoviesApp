//
//  MoviesEndpoint.swift
//  MoviesApp
//
//  Created by Lior Tal on 21/08/2021.
//  Copyright © 2021 Lior Tal. All rights reserved.
//

import Foundation

extension RealMoviesWebRepository {
    enum MoviesEndpoint: Endpoint {
        case getUpcomingMovies
        case getTopRatedMovies
        case getNowPlayingMovies
                
        var path: String {
            switch self {
            case .getUpcomingMovies:
                return "/movie/upcoming"
            case .getTopRatedMovies:
                return "/movie/top_rated"
            case .getNowPlayingMovies:
                return "/movie/now_playing"
            }
        }
        
        var method: HTTPMethod {
            switch self {
            case .getUpcomingMovies,
                 .getTopRatedMovies,
                 .getNowPlayingMovies:
                return .get
            }
        }
        
        var headers: [String : String]? {
            ["Content-Type": "application/json"]
        }
        
        func queryParameters(page: Int?) -> [String: String]? {
            var queryParameters = ["api_key": Constants.apiKey]
            
            if let page = page {
                queryParameters["page"] = "\(page)"
            }
            return queryParameters
        }
        
        func body() throws -> Data? {
            return nil
        }
    }
}
