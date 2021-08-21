//
//  MockedMovieDetailsViewModel.swift
//  MoviesAppTests
//
//  Created by Lior Tal on 21/08/2021.
//  Copyright © 2021 Lior Tal. All rights reserved.
//

import XCTest
@testable import MoviesApp

class MockedMovieDetailsViewModel: Mock, MovieDetailsViewModel {
    // MARK: MovieDetailsViewModel
    var diContainer: DIContainer
    var routing: MovieDetailsViewRouting
    var movie: Movie
    
    enum Action: Equatable {
        case updateMovie(Int, Bool)
    }
    var actions = MockedList<Action>(expectedActions: [])
    
    func updateMovie(id: Int, favorite: Bool) {
        add(.updateMovie(id, favorite))
    }
    
    init(diContainer: DIContainer, routing: MovieDetailsViewRouting, movie: Movie) {
        self.diContainer = diContainer
        self.routing = routing
        self.movie = movie
    }
}
