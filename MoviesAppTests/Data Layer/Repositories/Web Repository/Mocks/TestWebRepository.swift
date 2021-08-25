//
//  TestWebRepository.swift
//  MoviesAppTests
//
//  Created by Lior Tal on 21/08/2021.
//  Copyright © 2021 Lior Tal. All rights reserved.
//

import XCTest
@testable import MoviesApp

class TestWebRepository: WebRepository {
    static let testMoviesURL = "https://test.com"
    
    let bgQueue = DispatchQueue(label: "test_web_repository_queue")
    let session: URLSession = .mockedSession
    let baseURL = testMoviesURL
}
