//
//  MoviesDBRepositoryTests.swift
//  MoviesAppTests
//
//  Created by Lior Tal on 21/08/2021.
//  Copyright © 2021 Lior Tal. All rights reserved.
//

import XCTest
import Combine
import CoreData
@testable import MoviesApp

final class MoviesDBRepositoryTests: XCTestCase {
    private var mockedPersistentStore = MockedPersistentStore()
    private var subscriptions = Set<AnyCancellable>()
    private static let expectationsTimeOut: TimeInterval = 5.0
    
    private var testableObject: RealMoviesDBRepository?
    
    // MARK: - setUp
    override func setUp() {
        super.setUp()
        mockedPersistentStore.inMemoryContainer.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("Failed to load store: \(error)")
            }
        }
        
        testableObject = RealMoviesDBRepository(persistentStore: mockedPersistentStore)
        mockedPersistentStore.verify()
    }
    
    func test_fetch_movies() throws {
        let context = mockedPersistentStore.inMemoryContainer.viewContext
        let moviesListWebModel: MoviesListWebModel = try XCTUnwrap(MockedMovie.load(fromResource: MockedMovie.mockedMoviesFileName))
        let movieWebModel = try XCTUnwrap(moviesListWebModel.movies)
        
        // Given
        let favorite = false
        let fetchItemSnapshot = MockedPersistentStore.Snapshot(insertedObjects: 0, updatedObjects: 0, deletedObjects: 0)
        mockedPersistentStore.actions = MockedList(expectedActions: [
            .fetch(fetchItemSnapshot)
        ])
        
        let expectation = expectation(description: "fetch_movies")
        
        // Save items
        save(items: movieWebModel, in: context, movieType: .upcoming, favorite: favorite)
        
        // When
        // Fetch items
        try XCTUnwrap(testableObject)
            .fetchMovies(favorites: false)
            .sink { completion in
                if let error = completion.checkError() {
                    XCTFail("Unexpected error: \(error.localizedDescription)")
                }
            } receiveValue: { movies in
                // Then
                XCTAssertEqual(movieWebModel.count, movies.count, "Fetch \(movies.count) items instead of \(movieWebModel.count) items")
                self.mockedPersistentStore.verify()
                expectation.fulfill()
            }
            .store(in: &subscriptions)
        
        waitForExpectations(timeout: Self.expectationsTimeOut)
    }
    
    func test_store_moviesListWebModel() throws {
        let moviesListWebModel: MoviesListWebModel = try XCTUnwrap(MockedMovie.load(fromResource: MockedMovie.mockedMoviesFileName))
        
        // Given
        let numberOfItems = 20
        let favorite = false
        let updateOneItemSnapshot = MockedPersistentStore.Snapshot(insertedObjects: 1, updatedObjects: 0, deletedObjects: 0)
        let updateItemsSnapshot = Array(repeating: updateOneItemSnapshot, count: numberOfItems)
        let expectedActions = updateItemsSnapshot.map { MockedPersistentStore.Action.update($0) }
        mockedPersistentStore.actions = MockedList(expectedActions: expectedActions)
        
        let expectation = expectation(description: "store_movieWebModel")
        
        // When
        try XCTUnwrap(testableObject)
            .store(moviesListWebModel: moviesListWebModel, movieType: .upcoming, favorite: favorite)
            .sink { completion in
                if let error = completion.checkError() {
                    XCTFail("Unexpected error: \(error.localizedDescription)")
                }
            } receiveValue: { _ in
                // Then
                self.mockedPersistentStore.verify()
                expectation.fulfill()
            }
            .store(in: &subscriptions)
        
        waitForExpectations(timeout: Self.expectationsTimeOut)
    }
    
    func test_delete_movie() throws {
        let context = mockedPersistentStore.inMemoryContainer.viewContext
        let moviesListWebModel: MoviesListWebModel = try XCTUnwrap(MockedMovie.load(fromResource: MockedMovie.mockedMoviesFileName))
        let movieWebModel = try XCTUnwrap(moviesListWebModel.movies)
        
        // Given
        let favorite = false
        let deleteItemSnapshot = MockedPersistentStore.Snapshot(insertedObjects: 0, updatedObjects: 0, deletedObjects: 1)
        let fetchItemSnapshot = MockedPersistentStore.Snapshot(insertedObjects: 0, updatedObjects: 0, deletedObjects: 0)
        mockedPersistentStore.actions = MockedList(expectedActions: [
            .fetch(fetchItemSnapshot),
            .delete(deleteItemSnapshot),
            .fetch(fetchItemSnapshot)
        ])
        
        let expectation = expectation(description: "delete_movie")
        
        // Save items
        save(items: movieWebModel, in: context, movieType: .upcoming, favorite: favorite)
        
        let testableObject = try XCTUnwrap(testableObject)
        
        var movieItemsBeforeDelete = [Movie]()
        
        // When
        testableObject
            // Fetch items before delete
            .fetchMovies(favorites: false)
            // Delete item
            .flatMap { movies -> AnyPublisher<Void, Error> in
                movieItemsBeforeDelete.append(contentsOf: movies)
                let movieItem = movieItemsBeforeDelete[0]
                return testableObject
                    .delete(movieId: Int(movieItem.id))
            }
            // Fetch items after delete
            .flatMap { () -> AnyPublisher<[Movie], Error> in
                testableObject
                    .fetchMovies(favorites: false)
            }
            .sink { completion in
                if let error = completion.checkError() {
                    XCTFail("Unexpected error: \(error.localizedDescription)")
                }
            } receiveValue: { movieItemsAfterDelete in
                // Then
                XCTAssertEqual(movieItemsBeforeDelete.count - 1, movieItemsAfterDelete.count, "Fetch \(movieItemsAfterDelete.count) items instead of \(movieItemsBeforeDelete.count - 1) items")
                self.mockedPersistentStore.verify()
                expectation.fulfill()
            }
            .store(in: &subscriptions)
        
        waitForExpectations(timeout: Self.expectationsTimeOut)
    }
    
    // MARK: - Store image test
    func test_storeImage() throws {
        let testableObject = try XCTUnwrap(testableObject)
        let moviesListWebModel: MoviesListWebModel = try XCTUnwrap(MockedMovie.load(fromResource: MockedMovie.mockedMoviesFileName))
        
        // Given
        let numberOfItems = 20
        let favorite = false
        let updateOneItemSnapshot = MockedPersistentStore.Snapshot(insertedObjects: 1, updatedObjects: 0, deletedObjects: 0)
        let updateItemsSnapshot = Array(repeating: updateOneItemSnapshot, count: numberOfItems)
        var expectedActions = updateItemsSnapshot.map { MockedPersistentStore.Action.update($0) }
        
        let updateImageSnapshot = MockedPersistentStore.Snapshot(insertedObjects: 0, updatedObjects: 0, deletedObjects: 0)
        expectedActions.append(MockedPersistentStore.Action.update(updateImageSnapshot))
        mockedPersistentStore.actions = MockedList(expectedActions: expectedActions)
        
        let imageData = try XCTUnwrap(MockedMovie.testImageData())
        
        let expectation = expectation(description: "storeImage")
        
        // When
        testableObject
            .store(moviesListWebModel: moviesListWebModel, movieType: .upcoming, favorite: favorite)
            // Save image
            .flatMap { movies -> AnyPublisher<[Movie], Error> in
                let movie = movies[0]
                return testableObject.storeImage(data: imageData, movieId: Int(movie.id))
            }
            .sink { completion in
                if let error = completion.checkError() {
                    XCTFail("Unexpected error: \(error.localizedDescription)")
                }
            } receiveValue: { movies in
                // Then
                self.mockedPersistentStore.verify()
                expectation.fulfill()
            }
            .store(in: &subscriptions)
        
        waitForExpectations(timeout: Self.expectationsTimeOut)
    }
    
    // MARK: - tearDown
    override func tearDown() {
        testableObject = nil
        subscriptions.removeAll()
        super.tearDown()
    }
}

// MARK: - save items for tests
fileprivate extension MoviesDBRepositoryTests {
    func save<Model>(items models: [Model], in context: NSManagedObjectContext, movieType: MovieType, favorite: Bool) where Model: MovieModel {
        context.performAndWait {
            do {
                models.forEach {
                    $0.store(in: context, movieType: movieType, favorite: favorite)
                }
                
                guard context.hasChanges else {
                    XCTFail("Items not saved")
                    context.reset()
                    return
                }
                try context.save()
            } catch {
                XCTFail("Items not saved")
                context.reset()
            }
        }
    }
}
