//
//  MockedMovie.swift
//  MoviesAppTests
//
//  Created by Lior Tal on 21/08/2021.
//  Copyright © 2021 Lior Tal. All rights reserved.
//

import XCTest
@testable import MoviesApp

class MockedMovie {
    static var testBundle = Bundle(for: MockedMovie.self)
    static let mockedMoviesFileName = "mock_movies"
    
    static func load<Model>(fromResource fileName: String) -> Model? where Model: Codable {
        guard let url = testBundle.url(forResource: fileName, withExtension: "json") else { return nil }
        
        do {
            let data = try Data(contentsOf: url)
            return try JSONDecoder().decode(Model.self, from: data)
        } catch {
            print("An error occurred while loading a mock model: \(error.localizedDescription)")
            return nil
        }
    }
    
    static func getMoviesData(fromResource fileName: String) -> Data? {
        guard let url = testBundle.url(forResource: fileName, withExtension: "json") else { return nil }
        
        do {
            return try Data(contentsOf: url)
        } catch {
            print("An error occurred while loading a mock model: \(error.localizedDescription)")
            return nil
        }
    }
    
    static func movieData(fromResource fileName: String) -> Data? {
        guard let url = testBundle.url(forResource: fileName, withExtension: "json") else { return nil }
        
        do {
            return try Data(contentsOf: url)
        } catch {
            print("An error occurred while loading a mock model: \(error.localizedDescription)")
            return nil
        }
    }
}
