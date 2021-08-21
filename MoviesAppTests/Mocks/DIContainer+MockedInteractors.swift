//
//  DIContainer+MockedInteractors.swift
//  MoviesAppTests
//
//  Created by Lior Tal on 21/08/2021.
//  Copyright © 2021 Lior Tal. All rights reserved.
//

import XCTest
@testable import MoviesApp

extension DIContainer.Interactors {
    static func mocked(moviesInteractor: MoviesInteractor = MockedMoviesInteractor()) -> DIContainer.Interactors {
        DIContainer.Interactors(moviesInteractor: moviesInteractor)
    }
}
