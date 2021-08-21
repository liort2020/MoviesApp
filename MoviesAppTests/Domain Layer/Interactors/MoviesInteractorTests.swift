//
//  MoviesInteractorTests.swift
//  MoviesAppTests
//
//  Created by Lior Tal on 21/08/2021.
//  Copyright © 2021 Lior Tal. All rights reserved.
//

import XCTest
import Combine
import CoreData
@testable import MoviesApp

final class MoviesInteractorTests: XCTestCase {
    private let appState = CurrentValueSubject<AppState, Never>(AppState())
    private lazy var mockedMoviesWebRepository = MockedMoviesWebRepository()
    private lazy var mockedImagesWebRepository = MockedImagesWebRepository()
    private lazy var mockedMoviesDBRepository = MockedMoviesDBRepository()
    private lazy var fakeMovies = FakeMovies.all
    private static let expectationsTimeOut: TimeInterval = 5.0
    private static let fetchAllExpectationsTimeOut: TimeInterval = 10.0
    private var subscriptions = Set<AnyCancellable>()
    
    var testableObject: RealMoviesInteractor?
    
    override func setUp() {
        super.setUp()
        appState.value = AppState()
        testableObject = RealMoviesInteractor(moviesWebRepository: mockedMoviesWebRepository,
                                              imagesWebRepository: mockedImagesWebRepository,
                                              moviesDBRepository: mockedMoviesDBRepository,
                                              appState: appState)
    }
    
    func test_load() throws {
        let testableObject = try XCTUnwrap(testableObject)
        let expectation = expectation(description: "load")
        
        // Given
        let fetchFavorites = false
        mockedMoviesWebRepository.actions = MockedList(expectedActions: [])
        mockedImagesWebRepository.actions = MockedList(expectedActions: [])
        mockedMoviesDBRepository.actions = MockedList(expectedActions: [
            .fetchMovies(fetchFavorites)
        ])
        
        // Set DBRepository response
        mockedMoviesDBRepository.fetchMoviesResult = .success(fakeMovies)
        
        // When
        testableObject
            .load()
            .sink { completion in
                if let error = completion.checkError() {
                    XCTFail("Unexpected error: \(error.localizedDescription)")
                }
            } receiveValue: { movies in
                // Then
                XCTAssertFalse(movies.isEmpty)
                XCTAssertEqual(movies.count, self.fakeMovies.count, "Receive \(movies.count) items instead of \(self.fakeMovies.count) items")
                self.mockedMoviesWebRepository.verify()
                self.mockedImagesWebRepository.verify()
                self.mockedMoviesDBRepository.verify()
                expectation.fulfill()
            }
            .store(in: &subscriptions)
        
        wait(for: [expectation], timeout: Self.expectationsTimeOut)
    }
    
    func test_fetchAll() throws {
        let testableObject = try XCTUnwrap(testableObject)
        let expectation = expectation(description: "fetchAll")
        
        // Given
        let page = 1
        let fetchFavorites = false
        mockedMoviesWebRepository.actions = MockedList(expectedActions: [
            .getMovies(movieType: .upcoming, page: page),
            .getMovies(movieType: .topRated, page: page),
            .getMovies(movieType: .nowPlaying, page: page)
        ])
        mockedMoviesDBRepository.actions = MockedList(expectedActions: [
            .fetchMovies(fetchFavorites)
        ])
        
        // Set MoviesWebRepository response
        let moviesListWebModel: MoviesListWebModel = try XCTUnwrap(MockedMovie.load(fromResource: MockedMovie.mockedMoviesFileName))
        mockedMoviesWebRepository.getMoviesResponse = .success(moviesListWebModel)
        
        // Set DBRepository response
        mockedMoviesDBRepository.fetchMoviesResult = .success(fakeMovies)
        mockedMoviesDBRepository.storeMoviesListWebModelResult = .success(fakeMovies)
        
        // When
        testableObject
            .fetchMovies(page: page) { publisher in
                publisher
                    .sink { completion in
                        if let error = completion.checkError() {
                            XCTFail("Unexpected error: \(error.localizedDescription)")
                        }
                    } receiveValue: { movies in
                        // Then
                        XCTAssertFalse(movies.isEmpty)
                        XCTAssertEqual(movies.count, self.fakeMovies.count, "Receive \(movies.count) items instead of \(self.fakeMovies.count) items")
                        self.mockedMoviesWebRepository.verify()
                        self.mockedImagesWebRepository.verify()
                        expectation.fulfill()
                    }
                    .store(in: &self.subscriptions)
            }
        
        wait(for: [expectation], timeout: Self.fetchAllExpectationsTimeOut)
    }
    
    func test_fetchMovie() throws {
        let testableObject = try XCTUnwrap(testableObject)
        let expectation = expectation(description: "fetchMovie")
        
        // Given
        let movieId = 436969
        let onlyOneFakeMovie = [try XCTUnwrap(fakeMovies.first)]
        mockedMoviesWebRepository.actions = MockedList(expectedActions: [])
        mockedMoviesDBRepository.actions = MockedList(expectedActions: [
            .fetchMovie(id: movieId)
        ])
        
        // Set MoviesWebRepository response
        let moviesListWebModel: MoviesListWebModel = try XCTUnwrap(MockedMovie.load(fromResource: MockedMovie.mockedMoviesFileName))
        mockedMoviesWebRepository.getMoviesResponse = .success(moviesListWebModel)
        
        // Set DBRepository response
        mockedMoviesDBRepository.fetchMovieResult = .success(onlyOneFakeMovie)
        mockedMoviesDBRepository.storeMoviesListWebModelResult = .success(onlyOneFakeMovie)
        
        // When
        testableObject
            .fetchMovie(id: movieId)
            .sink { completion in
                if let error = completion.checkError() {
                    XCTFail("Unexpected error: \(error.localizedDescription)")
                }
            } receiveValue: { movies in
                // Then
                XCTAssertFalse(movies.isEmpty)
                XCTAssertEqual(movies.count, onlyOneFakeMovie.count, "Receive \(movies.count) items instead of \(onlyOneFakeMovie.count) items")
                self.mockedMoviesWebRepository.verify()
                self.mockedImagesWebRepository.verify()
                self.mockedMoviesDBRepository.verify()
                expectation.fulfill()
            }
            .store(in: &self.subscriptions)
        
        wait(for: [expectation], timeout: Self.fetchAllExpectationsTimeOut)
    }
    
    func test_fetchImages() throws {
        let testableObject = try XCTUnwrap(testableObject)
        let expectation = expectation(description: "fetchImages")
        
        // Given
        let fetchFavorites = false
        let emptyImageData: Data? = Data()
        mockedMoviesWebRepository.actions = MockedList(expectedActions: [])
        mockedImagesWebRepository.actions = MockedList(expectedActions: fakeMovies.map { .download(imagePath: $0.posterPath) })
        
        var dbRepositoryExpectedActions: [MockedMoviesDBRepository.Action] = []
        dbRepositoryExpectedActions.append(.fetchMovies(fetchFavorites))
        dbRepositoryExpectedActions.append(contentsOf: fakeMovies.map { .storeImage(data: emptyImageData,
                                                                                    movieId: Int($0.id)) })
        dbRepositoryExpectedActions.append(.fetchMovies(fetchFavorites))
        mockedMoviesDBRepository.actions = MockedList(expectedActions: dbRepositoryExpectedActions)
        
        // Set DBRepository response
        mockedMoviesDBRepository.fetchMoviesResult = .success(fakeMovies)
        
        // When
        testableObject
            .fetchImages { publisher in
                publisher
                    .sink { completion in
                        if let error = completion.checkError() {
                            XCTFail("Unexpected error: \(error.localizedDescription)")
                        }
                    } receiveValue: { movies in
                        // Then
                        XCTAssertFalse(movies.isEmpty)
                        XCTAssertEqual(movies.count, self.fakeMovies.count, "Receive \(movies.count) items instead of \(self.fakeMovies.count) items")
                        self.mockedMoviesWebRepository.verify()
                        self.mockedImagesWebRepository.verify()
                        self.mockedMoviesDBRepository.verify()
                        expectation.fulfill()
                    }
                    .store(in: &self.subscriptions)
            }
        
        wait(for: [expectation], timeout: Self.expectationsTimeOut)
    }
    
    func test_updateMovie() throws {
        let testableObject = try XCTUnwrap(testableObject)
        let expectation = expectation(description: "updateMovie")
        
        // Given
        let onlyOneFakeMovie = try XCTUnwrap(fakeMovies.first)
        let movieId = Int(onlyOneFakeMovie.id)
        let isFavorite = onlyOneFakeMovie.favorite
        mockedMoviesWebRepository.actions = MockedList(expectedActions: [])
        mockedImagesWebRepository.actions = MockedList(expectedActions: [])
        mockedMoviesDBRepository.actions = MockedList(expectedActions: [
            .updateMovie(id: movieId, favorite: isFavorite)
        ])
        
        // Set DBRepository response
        mockedMoviesDBRepository.updateMovieResult = .success(onlyOneFakeMovie)
        
        // When
        testableObject
            .updateMovie(id: movieId, favorite: isFavorite)
            .sink { completion in
                if let error = completion.checkError() {
                    XCTFail("Unexpected error: \(error.localizedDescription)")
                }
            } receiveValue: { movie in
                // Then
                XCTAssertNotNil(movie)
                XCTAssertEqual(movie?.favorite, isFavorite, "Expected to receive a favorite: \(isFavorite)")
                self.mockedMoviesWebRepository.verify()
                self.mockedImagesWebRepository.verify()
                self.mockedMoviesDBRepository.verify()
                expectation.fulfill()
            }
            .store(in: &self.subscriptions)
        
        wait(for: [expectation], timeout: Self.expectationsTimeOut)
    }
    
    override func tearDown() {
        testableObject = nil
        subscriptions.removeAll()
        super.tearDown()
    }
}
