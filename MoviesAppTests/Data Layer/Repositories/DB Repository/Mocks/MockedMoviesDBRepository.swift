//
//  MockedMoviesDBRepository.swift
//  MoviesAppTests
//
//  Created by Lior Tal on 21/08/2021.
//  Copyright © 2021 Lior Tal. All rights reserved.
//

import XCTest
import SwiftUI
import Combine
@testable import MoviesApp

final class MockedMoviesDBRepository: Mock, MoviesDBRepository {
    enum Action: Equatable {
        case fetchMovies(Bool)
        case fetchMovie(id: Int)
        case store(moviesListWebModel: MoviesListWebModel, movieType: MovieType, favorite: Bool)
        case storeImage(data: Data?, movieId: Int)
        case updateMovie(id: Int, favorite: Bool)
        case delete(movieId: Int)
    }
    var actions = MockedList<Action>(expectedActions: [])
    
    var fetchMoviesResult: Result<[Movie], Error> = .failure(MockedError.valueNeedToBeSet)
    var fetchMovieResult: Result<[Movie], Error> = .failure(MockedError.valueNeedToBeSet)
    var storeMoviesListWebModelResult: Result<[Movie], Error> = .failure(MockedError.valueNeedToBeSet)
    var storeImageResult: Result<[Movie], Error> = .failure(MockedError.valueNeedToBeSet)
    var updateMovieResult: Result<Movie?, Error> = .failure(MockedError.valueNeedToBeSet)
    var deleteResult: Result<Void, Error> = .failure(MockedError.valueNeedToBeSet)
    
    func fetchMovies(favorites: Bool) -> AnyPublisher<[Movie], Error> {
        add(.fetchMovies(favorites))
        return fetchMoviesResult.publish()
    }
    
    func fetchMovie(id: Int) -> AnyPublisher<[Movie], Error> {
        add(.fetchMovie(id: id))
        return fetchMovieResult.publish()
    }
    
    func store(moviesListWebModel: MoviesListWebModel, movieType: MovieType, favorite: Bool) -> AnyPublisher<[Movie], Error> {
        add(.store(moviesListWebModel: moviesListWebModel, movieType: movieType, favorite: favorite))
        return storeMoviesListWebModelResult.publish()
    }
    
    func storeImage(data: Data?, movieId: Int) -> AnyPublisher<[Movie], Error> {
        add(.storeImage(data: data, movieId: movieId))
        return storeImageResult.publish()
    }
    
    func updateMovie(id: Int, favorite: Bool) -> AnyPublisher<Movie?, Error> {
        add(.updateMovie(id: id, favorite: favorite))
        return updateMovieResult.publish()
    }
    
    func delete(movieId: Int) -> AnyPublisher<Void, Error> {
        add(.delete(movieId: movieId))
        return deleteResult.publish()
    }
}
