//
//  MockedMoviesListViewModel.swift
//  MoviesAppTests
//
//  Created by Lior Tal on 21/08/2021.
//  Copyright © 2021 Lior Tal. All rights reserved.
//

import XCTest
@testable import MoviesApp

class MockedMoviesListViewModel: Mock, MoviesListViewModel {
    // MARK: MoviesListViewModel
    var diContainer: DIContainer
    var routing: MoviesListViewRouting
    var movies: [Movie]
    var isLoading: Bool
    
    enum Action: Equatable {
        case load(Bool)
        case fetchMovies(enableIsLoading: Bool)
        case fetchImages(enableIsLoading: Bool)
    }
    var actions = MockedList<Action>(expectedActions: [])
    
    init(diContainer: DIContainer, routing: MoviesListViewRouting, movies: [Movie] = [], isLoading: Bool = false) {
        self.diContainer = diContainer
        self.routing = routing
        self.movies = movies
        self.isLoading = isLoading
    }
    
    func load(favorites: Bool = false) {
        add(.load(favorites))
    }
    
    func fetchMovies(enableIsLoading: Bool) {
        add(.fetchMovies(enableIsLoading: enableIsLoading))
    }
    
    func fetchImages(enableIsLoading: Bool) {
        add(.fetchImages(enableIsLoading: enableIsLoading))
    }
}
