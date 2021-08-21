//
//  MockedMoviesInteractor.swift
//  MoviesAppTests
//
//  Created by Lior Tal on 21/08/2021.
//  Copyright © 2021 Lior Tal. All rights reserved.
//

import XCTest
import SwiftUI
import Combine
@testable import MoviesApp

class MockedMoviesInteractor: Mock, MoviesInteractor {
    enum Action: Equatable {
        case load(Bool)
        case fetchMovies(Int)
        case fetchMovie(Int)
        case fetchImages
        case updateMovie(Int, Bool)
    }
    var actions = MockedList<Action>(expectedActions: [])
    
    var loadResponse: Result<[Movie], Error> = .failure(MockedError.valueNeedToBeSet)
    var fetchMoviesResponse: Result<[Movie], Error> = .failure(MockedError.valueNeedToBeSet)
    var fetchMovieResponse: Result<[Movie], Error> = .failure(MockedError.valueNeedToBeSet)
    var fetchImagesResponse: Result<[Movie], Error> = .failure(MockedError.valueNeedToBeSet)
    var updateMovieResponse: Result<Movie?, Error> = .failure(MockedError.valueNeedToBeSet)
    
    func load(favorites: Bool = false) -> AnyPublisher<[Movie], Error> {
        add(.load(favorites))
        return loadResponse.publish()
    }
    
    func fetchMovies(page: Int, completionHandler: @escaping (AnyPublisher<[Movie], Error>) -> Void) {
        add(.fetchMovies(page))
        completionHandler(fetchMoviesResponse.publish())
    }
    
    func fetchMovie(id: Int) -> AnyPublisher<[Movie], Error> {
        add(.fetchMovie(id))
        return fetchMovieResponse.publish()
    }
    
    func fetchImages(completionHandler: @escaping (AnyPublisher<[Movie], Error>) -> Void) {
        add(.fetchImages)
        completionHandler(fetchImagesResponse.publish())
    }
    
    func updateMovie(id: Int, favorite: Bool) -> AnyPublisher<Movie?, Error> {
        add(.updateMovie(id, favorite))
        return updateMovieResponse.publish()
    }
}
