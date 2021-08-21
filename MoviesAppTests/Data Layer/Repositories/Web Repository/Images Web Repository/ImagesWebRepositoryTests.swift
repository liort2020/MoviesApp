//
//  ImagesWebRepositoryTests.swift
//  MoviesAppTests
//
//  Created by Lior Tal on 21/08/2021.
//  Copyright © 2021 Lior Tal. All rights reserved.
//

import XCTest
import Combine
import CoreData
@testable import MoviesApp

final class ImagesWebRepositoryTests: XCTestCase {
    private let baseUrl = TestWebRepository.testImagePathURL
    private static let expectationsTimeOut: TimeInterval = 5.0
    private var subscriptions = Set<AnyCancellable>()
    
    private var testableObject: RealImagesWebRepository?
    
    override func setUp() {
        super.setUp()
        testableObject = RealImagesWebRepository(session: .mockedSession, baseURL: baseUrl)
    }
    
    func test_download_image_url() throws {
        let testableObject = try XCTUnwrap(testableObject)
        let expectation = expectation(description: "download_image_url")
        
        // Given
        let data = try XCTUnwrap(MockedMovie.getMoviesData(fromResource: MockedMovie.mockedMoviesFileName))
        
        MockURLProtocol.requestHandler = { request in
            guard let url = request.url else { throw MockWebError.request }
            guard let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil) else { throw MockWebError.response }
            return (response, data)
        }
        
        // When
        let publisher: AnyPublisher<Data?, Error> = testableObject
            .download(imagePath: baseUrl)
        
        publisher
            .sink { completion in
                if let error = completion.checkError() {
                    XCTFail("Unexpected error: \(error.localizedDescription)")
                }
            } receiveValue: { data in
                // Then
                XCTAssertNotNil(data)
                expectation.fulfill()
            }
            .store(in: &subscriptions)
        
        wait(for: [expectation], timeout: Self.expectationsTimeOut)
    }
    
    func test_download_empty_image_url() throws {
        let testableObject = try XCTUnwrap(testableObject)
        let expectation = expectation(description: "download_image_url")
        
        // Given
        let emptyBaseURL = ""
        let data = try XCTUnwrap(MockedMovie.getMoviesData(fromResource: MockedMovie.mockedMoviesFileName))
        
        MockURLProtocol.requestHandler = { request in
            guard let url = request.url else { throw MockWebError.request }
            guard let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil) else { throw MockWebError.response }
            return (response, data)
        }
        
        // When
        let publisher: AnyPublisher<Data?, Error> = testableObject
            .download(imagePath: emptyBaseURL)
        
        publisher
            .sink { completion in
                // Then
                if let error = completion.checkError() {
                    XCTAssertEqual(error.localizedDescription, WebError.invalidImage.localizedDescription, "Expected an invalidImage error, and got: \(error.localizedDescription)")
                    expectation.fulfill()
                }
            } receiveValue: { _ in
                XCTFail("Expected a WebError.invalidImage error to be thrown")
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
