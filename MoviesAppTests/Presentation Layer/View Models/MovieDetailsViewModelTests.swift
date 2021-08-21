//
//  MovieDetailsViewModelTests.swift
//  MoviesAppTests
//
//  Created by Lior Tal on 21/08/2021.
//  Copyright © 2021 Lior Tal. All rights reserved.
//

import XCTest
import Combine
@testable import MoviesApp

final class MovieDetailsViewModelTests: XCTestCase {
    private let appState = CurrentValueSubject<AppState, Never>(AppState())
    private lazy var mockedMoviesInteractor = MockedMoviesInteractor()
    private lazy var diContainer: DIContainer = {
        DIContainer.init(appState: appState,
                         interactors: .mocked(moviesInteractor: mockedMoviesInteractor))
    }()
    private lazy var fakeMovie = FakeMovies.all[0]
    
    var testableObject: RealMovieDetailsViewModel?
    
    override func setUp() {
        super.setUp()
        appState.value = AppState()
        testableObject = RealMovieDetailsViewModel(diContainer: diContainer, movie: fakeMovie)
    }
    
    func test_updateMovie() throws {
        let testableObject = try XCTUnwrap(testableObject)
        // Given
        let favorite = true
        let movieId = 436969
        mockedMoviesInteractor.actions = MockedList(expectedActions: [
            .updateMovie(movieId, favorite)
        ])
        
        // When
        testableObject
            .updateMovie(id: movieId, favorite: favorite)
        
        // Then
        mockedMoviesInteractor.verify()
    }
    
    override func tearDown() {
        testableObject = nil
        super.tearDown()
    }
}
