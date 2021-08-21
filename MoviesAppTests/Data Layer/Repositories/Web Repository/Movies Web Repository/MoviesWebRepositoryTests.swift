//
//  MoviesWebRepositoryTests.swift
//  MoviesAppTests
//
//  Created by Lior Tal on 21/08/2021.
//  Copyright © 2021 Lior Tal. All rights reserved.
//

import XCTest
import Combine
import CoreData
@testable import MoviesApp

final class MoviesWebRepositoryTests: XCTestCase {
    private let baseUrl = TestWebRepository.testMoviesURL
    private static let expectationsTimeOut: TimeInterval = 5.0
    private var subscriptions = Set<AnyCancellable>()
    
    private var testableObject: RealMoviesWebRepository?
    
    override func setUp() {
        super.setUp()
        testableObject = RealMoviesWebRepository(session: .mockedSession, baseURL: baseUrl)
    }
    
    func test_getMovies() throws {
        let testableObject = try XCTUnwrap(testableObject)
        let expectation = expectation(description: "getMovies")
        
        // Given
        let expectedNumberOfItems = 20
        let page = 1
        let data = try XCTUnwrap(MockedMovie.getMoviesData(fromResource: MockedMovie.mockedMoviesFileName))
        
        MockURLProtocol.requestHandler = { request in
            guard let url = request.url else { throw MockWebError.request }
            guard let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil) else { throw MockWebError.response }
            return (response, data)
        }
        
        // When
        let publisher: AnyPublisher<MoviesListWebModel, Error> = testableObject.getMovies(by: .upcoming, page: page)
        
        publisher
            .sink { completion in
                if let error = completion.checkError() {
                    XCTFail("Unexpected error: \(error.localizedDescription)")
                }
            } receiveValue: { movies in
                // Then
                XCTAssertNotNil(movies.movies)
                let numberOfMovies = movies.movies?.count ?? 0
                XCTAssertEqual(numberOfMovies, expectedNumberOfItems, "Receive \(numberOfMovies) items instead of \(expectedNumberOfItems) items")
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
