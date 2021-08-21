//
//  MoviesWebRepository.swift
//  MoviesApp
//
//  Created by Lior Tal on 21/08/2021.
//  Copyright © 2021 Lior Tal. All rights reserved.
//

import Foundation
import Combine

protocol MoviesWebRepository: WebRepository {
    func getMovies(by movieType: MovieType, page: Int) -> AnyPublisher<MoviesListWebModel, Error>
}

class RealMoviesWebRepository: MoviesWebRepository {
    let bgQueue = DispatchQueue(label: "movies_web_repository_queue")
    let session: URLSession
    let baseURL: String
    
    init(session: URLSession, baseURL: String) {
        self.session = session
        self.baseURL = baseURL
    }
    
    func getMovies(by movieType: MovieType, page: Int) -> AnyPublisher<MoviesListWebModel, Error> {
        var endpoint: MoviesEndpoint
        
        switch movieType {
        case .upcoming:
            endpoint = MoviesEndpoint.getUpcomingMovies
        case .topRated:
            endpoint = MoviesEndpoint.getTopRatedMovies
        case .nowPlaying:
            endpoint = MoviesEndpoint.getNowPlayingMovies
        }
        
        return requestURL(endpoint: endpoint, page: page)
    }
}
