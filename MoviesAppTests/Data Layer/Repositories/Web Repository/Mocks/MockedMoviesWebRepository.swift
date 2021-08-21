//
//  MockedMoviesWebRepository.swift
//  MoviesAppTests
//
//  Created by Lior Tal on 21/08/2021.
//  Copyright © 2021 Lior Tal. All rights reserved.
//

import XCTest
import Combine
@testable import MoviesApp

final class MockedMoviesWebRepository: TestWebRepository, Mock, MoviesWebRepository {
    enum Action: Equatable {
        case getMovies(movieType: MovieType, page: Int)
    }
    var actions = MockedList<Action>(expectedActions: [])
    
    var getMoviesResponse: Result<MoviesListWebModel, Error> = .failure(MockedError.valueNeedToBeSet)
    
    func getMovies(by movieType: MovieType, page: Int) -> AnyPublisher<MoviesListWebModel, Error> {
        add(.getMovies(movieType: movieType, page: page))
        return getMoviesResponse.publish()
    }
}

enum WebRepositoryError: Error {
    case invalidPublisher
}
