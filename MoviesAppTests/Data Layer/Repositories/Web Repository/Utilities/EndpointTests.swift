//
//  EndpointTests.swift
//  MoviesAppTests
//
//  Created by Lior Tal on 21/08/2021.
//  Copyright © 2021 Lior Tal. All rights reserved.
//

import XCTest
@testable import MoviesApp

final class EndpointTests: XCTestCase {
    private var testURL = TestWebRepository.testMoviesURL
    
    func test_getMovies() throws {
        // Given
        let testableObject = try XCTUnwrap(RealMoviesWebRepository.MoviesEndpoint.getUpcomingMovies)
        
        do {
            // When
            let urlRequest = try testableObject.request(url: testURL)
            
            // Then
            XCTAssertNotNil(urlRequest)
            // path
            let request = try XCTUnwrap(urlRequest)
            XCTAssertNotNil(request.url)
            // query parameters
            let query = try XCTUnwrap(request.url?.query)
            XCTAssertEqual(query, "api_key=\(Constants.apiKey)")
            // method
            XCTAssertEqual(request.httpMethod, HTTPMethod.get.rawValue)
            // headers
            XCTAssertEqual(request.allHTTPHeaderFields, ["Content-Type": "application/json"])
            // body
            XCTAssertNil(request.httpBody)
        } catch {
            XCTFail("Unexpected error: \(error.localizedDescription)")
        }
    }
}
