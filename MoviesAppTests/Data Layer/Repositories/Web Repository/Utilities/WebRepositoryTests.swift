//
//  WebRepositoryTests.swift
//  MoviesAppTests
//
//  Created by Lior Tal on 21/08/2021.
//  Copyright © 2021 Lior Tal. All rights reserved.
//

import XCTest
import Combine
@testable import MoviesApp

final class WebRepositoryTests: XCTestCase {
    private var moviesEndpoint: RealMoviesWebRepository.MoviesEndpoint?
    private var imagesEndpoint: RealImagesWebRepository.ImagesEndpoint?
    private let testImagePathURL = TestWebRepository.testImagePathURL
    private static let expectationsTimeOut: TimeInterval = 5.0
    private var subscriptions = Set<AnyCancellable>()
    
    private var testableObject: TestWebRepository?
    
    override func setUp() {
        super.setUp()
        moviesEndpoint = RealMoviesWebRepository.MoviesEndpoint.getUpcomingMovies
        imagesEndpoint = RealImagesWebRepository.ImagesEndpoint.getPosterImage(path: testImagePathURL)
        testableObject = TestWebRepository()
    }
    
    func test_requestURL() throws {
        let expectation = expectation(description: "requestURL")
        let testableObject = try XCTUnwrap(testableObject)
        
        // Given
        let expectedNumberOfItems = 20
        let page = 1
        let moviesEndpoint = try XCTUnwrap(moviesEndpoint)
        let data = try XCTUnwrap(MockedMovie.getMoviesData(fromResource: MockedMovie.mockedMoviesFileName))
        
        MockURLProtocol.requestHandler = { request in
            guard let url = request.url else { throw MockWebError.request }
            guard let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil) else { throw MockWebError.response }
            return (response, data)
        }
        
        // When
        let publisher: AnyPublisher<MoviesListWebModel, Error> = testableObject
            .requestURL(endpoint: moviesEndpoint, page: page)
        
        publisher
            .sink { completion in
                if let error = completion.checkError() {
                    XCTFail("Unexpected error: \(error.localizedDescription)")
                }
            } receiveValue: { movies in
                // Then
                XCTAssertNotNil(movies.movies)
                let numberOfItems = movies.movies?.count ?? 0
                XCTAssertEqual(numberOfItems, expectedNumberOfItems, "Receive \(numberOfItems) items instead of \(expectedNumberOfItems) items")
                expectation.fulfill()
            }
            .store(in: &subscriptions)
        
        wait(for: [expectation], timeout: Self.expectationsTimeOut)
    }
    
    func test_requestURL_webError_invalidStatusCode() throws {
        let expectation = expectation(description: "requestURL_invalidStatusCode")
        let testableObject = try XCTUnwrap(testableObject)
        
        // Given
        let page = 1
        let invalidStatusCode = 199
        let moviesEndpoint = try XCTUnwrap(moviesEndpoint)
        let data = try XCTUnwrap(MockedMovie.getMoviesData(fromResource: MockedMovie.mockedMoviesFileName))
        
        MockURLProtocol.requestHandler = { request in
            guard let url = request.url else { throw MockWebError.request }
            guard let response = HTTPURLResponse(url: url, statusCode: invalidStatusCode, httpVersion: nil, headerFields: nil) else { throw MockWebError.response }
            return (response, data)
        }
        
        // When
        let publisher: AnyPublisher<MoviesListWebModel, Error> = testableObject
            .requestURL(endpoint: moviesEndpoint, page: page)
        
        publisher
            .sink { completion in
                if let error = completion.checkError() {
                    // Then
                    XCTAssertEqual(error.localizedDescription, WebError.httpCode(HTTPError(code: invalidStatusCode)).localizedDescription, "Expected to get invalid status code, and got: \(error.localizedDescription)")
                    expectation.fulfill()
                }
            } receiveValue: { _ in
                XCTFail("Expected to get a WebError")
            }
            .store(in: &subscriptions)
        
        wait(for: [expectation], timeout: Self.expectationsTimeOut)
    }
    
    func test_requestImageURL() throws {
        let expectation = expectation(description: "requestURL_withoutReturningData")
        let testableObject = try XCTUnwrap(testableObject)
        
        // Given
        let data = try XCTUnwrap(MockedMovie.testImageData())
        let imagesEndpoint = try XCTUnwrap(imagesEndpoint)
        
        MockURLProtocol.requestHandler = { request in
            guard let url = request.url else { throw MockWebError.request }
            guard let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil) else { throw MockWebError.response }
            return (response, data)
        }
        
        // When
        testableObject
            .requestImageURL(endpoint: imagesEndpoint)
            .sink { completion in
                // Then
                if let error = completion.checkError() {
                    XCTFail("Unexpected error: \(error.localizedDescription)")
                }
            } receiveValue: { data in
                XCTAssertNotNil(data)
                expectation.fulfill()
            }
            .store(in: &subscriptions)
        
        wait(for: [expectation], timeout: Self.expectationsTimeOut)
    }
    
    override func tearDown() {
        moviesEndpoint = nil
        imagesEndpoint = nil
        testableObject = nil
        subscriptions.removeAll()
        super.tearDown()
    }
}
