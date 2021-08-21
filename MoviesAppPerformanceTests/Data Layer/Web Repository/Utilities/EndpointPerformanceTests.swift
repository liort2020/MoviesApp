//
//  EndpointPerformanceTests.swift
//  MoviesAppPerformanceTests
//
//  Created by Lior Tal on 21/08/2021.
//  Copyright © 2021 Lior Tal. All rights reserved.
//

import XCTest
@testable import MoviesApp

final class EndpointPerformanceTests: XCTestCase {
    private let testURL = "https://test.com"
    private var fakeMovie: Movie?
    
    override func setUp() {
        super.setUp()
        fakeMovie = FakeMovies.all.first
    }
    
    func test_getUpcomingMovies_performance() throws {
        let testableObject = RealMoviesWebRepository.MoviesEndpoint.getUpcomingMovies
        
        measure {
            let _ = try? testableObject.request(url: testURL)
        }
    }
    
    override func tearDown() {
        fakeMovie = nil
        super.tearDown()
    }
}
