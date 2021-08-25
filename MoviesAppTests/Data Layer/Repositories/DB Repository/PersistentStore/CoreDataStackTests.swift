//
//  CoreDataStackTests.swift
//  MoviesAppTests
//
//  Created by Lior Tal on 21/08/2021.
//  Copyright © 2021 Lior Tal. All rights reserved.
//

import XCTest
import Combine
@testable import MoviesApp

final class CoreDataStackTests: XCTestCase {
    private var subscriptions = Set<AnyCancellable>()
    private static let expectationsTimeOut: TimeInterval = 5.0
    
    private var testableObject: CoreDataStack?
    
    override func setUp() {
        super.setUp()
        testableObject = CoreDataStack()
    }
    
    func test_fetch() throws {
        let testableObject = try XCTUnwrap(testableObject)
        let expectation = expectation(description: "fetch")
        
        // Given
        let fetchRequest = Movie.requestAllItems(favorites: false)
        
        // When
        testableObject
            .fetch(fetchRequest)
            .sink { completion in
                if let error = completion.checkError() {
                    XCTFail("Unexpected error: \(error.localizedDescription)")
                }
            } receiveValue: { _ in
                // Then
                expectation.fulfill()
            }
            .store(in: &subscriptions)
        
        wait(for: [expectation], timeout: Self.expectationsTimeOut)
    }
    
    func test_createNewOrUpdate() throws {
        let testableObject = try XCTUnwrap(testableObject)
        let expectation = expectation(description: "createNewOrUpdate")
        
        // Given
        let favorite = false
        let moviesListWebModel: MoviesListWebModel = try XCTUnwrap(MockedMovie.load(fromResource: MockedMovie.mockedMoviesFileName))
        let movieWebModel = try XCTUnwrap(moviesListWebModel.movies?.first)
        
        let testItemId = Int32.random(in: 1..<Int32.max)
        let fetchRequest = Movie.requestItem(using: Int(testItemId))
        
        // When
        testableObject
            .update(fetchRequest: fetchRequest) { item in
                item.type = MovieType.upcoming.rawValue
                item.title = movieWebModel.title
                item.overview = movieWebModel.overview
                item.releaseDate = movieWebModel.releaseDate
                item.rating = movieWebModel.rating ?? Constants.defaultMovieRating
                item.posterPath = movieWebModel.posterPath
                item.favorite = favorite
            } createNew: { context in
                movieWebModel.store(in: context, movieType: .upcoming, favorite: favorite)
            }
            .sink { completion in
                if let error = completion.checkError() {
                    XCTFail("Unexpected error: \(error.localizedDescription)")
                }
            } receiveValue: { movie in
                // Then
                XCTAssertNotNil(movie.id)
                XCTAssertEqual(movie.title, movieWebModel.title)
                XCTAssertEqual(movie.overview, movieWebModel.overview)
                XCTAssertEqual(movie.releaseDate, movieWebModel.releaseDate)
                XCTAssertEqual(movie.rating, movieWebModel.rating)
                XCTAssertEqual(movie.posterPath, movieWebModel.posterPath)
                expectation.fulfill()
            }
            .store(in: &subscriptions)
        
        wait(for: [expectation], timeout: Self.expectationsTimeOut)
    }
    
    func test_delete() throws {
        let testableObject = try XCTUnwrap(testableObject)
        let expectation = expectation(description: "delete")
        
        // Given
        let testItemId = Int32.random(in: 1..<Int32.max)
        let fetchRequest = Movie.requestItem(using: Int(testItemId))
        
        // When
        testableObject
            .delete(fetchRequest)
            .sink { completion in
                if let error = completion.checkError() {
                    XCTFail("Unexpected error: \(error.localizedDescription)")
                }
            } receiveValue: { _ in
                // Then
                expectation.fulfill()
            }
            .store(in: &subscriptions)
        
        wait(for: [expectation], timeout: Self.expectationsTimeOut)
    }
    
    override func tearDown() {
        testableObject = nil
        subscriptions.removeAll()
        super.tearDown()
    }
}
