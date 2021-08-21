//
//  Mock.swift
//  MoviesAppTests
//
//  Created by Lior Tal on 21/08/2021.
//  Copyright © 2021 Lior Tal. All rights reserved.
//

import XCTest
@testable import MoviesApp

protocol Mock {
    associatedtype Action: Equatable
    var actions: MockedList<Action> { get }
    
    func add(_ action: Action)
    func verify()
}

extension Mock {
    func add(_ action: Action) {
        actions.add(action)
    }
    
    func verify() {
        actions.verify()
    }
}

final class MockedList<Action> where Action: Equatable {
    private let expectedActions: [Action]
    private var actualActions: [Action]
    
    init(expectedActions: [Action]) {
        self.expectedActions = expectedActions
        actualActions = []
    }
    
    func add(_ action: Action) {
        actualActions.append(action)
    }
    
    func verify() {
        XCTAssertEqual(actualActions, expectedActions, "Expected actions: \(expectedActions), Actual actions: \(actualActions)")
    }
}
