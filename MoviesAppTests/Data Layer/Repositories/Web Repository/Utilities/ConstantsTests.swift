//
//  ConstantsTests.swift
//  MoviesAppTests
//
//  Created by Lior Tal on 21/08/2021.
//  Copyright © 2021 Lior Tal. All rights reserved.
//

import XCTest
@testable import MoviesApp

final class ConstantsTests: XCTestCase {
    private let baseMoviesUrl = "https://api.themoviedb.org/3"
    private let baseImagesUrl = "https://image.tmdb.org/t/p/original"
    
    func test_baseMoviesUrl() {
        XCTAssertEqual(Constants.baseMoviesUrl, baseMoviesUrl)
        XCTAssertNotEqual(Constants.baseMoviesUrl.last, "/", "Added a backslash in the Endpoint enum")
    }
    
    func test_baseImagesUrl() {
        XCTAssertEqual(Constants.baseImagesUrl, baseImagesUrl)
        XCTAssertNotEqual(Constants.baseImagesUrl.last, "/", "Added a backslash in the Endpoint enum")
    }
}
