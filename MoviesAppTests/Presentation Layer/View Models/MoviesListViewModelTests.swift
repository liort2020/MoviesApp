//
//  MoviesListViewModelTests.swift
//  MoviesAppTests
//
//  Created by Lior Tal on 21/08/2021.
//  Copyright © 2021 Lior Tal. All rights reserved.
//

import XCTest
import Combine
@testable import MoviesApp

final class MoviesListViewModelTests: XCTestCase {
    private let appState = CurrentValueSubject<AppState, Never>(AppState())
    private lazy var mockedMoviesInteractor = MockedMoviesInteractor()
    private lazy var diContainer: DIContainer = {
        DIContainer.init(appState: appState,
                         interactors: .mocked(moviesInteractor: mockedMoviesInteractor))
    }()
    private lazy var fakeMovies = FakeMovies.all
    private lazy var isLoading = false
    
    var testableObject: RealMoviesListViewModel?
    
    override func setUp() {
        super.setUp()
        appState.value = AppState()
        testableObject = RealMoviesListViewModel(diContainer: diContainer,
                                                 movies: fakeMovies,
                                                 isLoading: isLoading)
    }
    
    func test_load() throws {
        let testableObject = try XCTUnwrap(testableObject)
        // Given
        let loadFavorites = false
        mockedMoviesInteractor.actions = MockedList(expectedActions: [
            .load(loadFavorites)
        ])
        
        // When
        testableObject
            .load()
        
        // Then
        mockedMoviesInteractor.verify()
    }
    
    override func tearDown() {
        testableObject = nil
        super.tearDown()
    }
}
