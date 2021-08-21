//
//  MockedBindingWithPublisher.swift
//  MoviesAppTests
//
//  Created by Lior Tal on 21/08/2021.
//  Copyright © 2021 Lior Tal. All rights reserved.
//

import XCTest
import SwiftUI
import Combine
@testable import MoviesApp

struct MockedBindingWithPublisher<Value> {
    let binding: Binding<Value>
    let publisher: AnyPublisher<Value, Error>
    
    init(value: Value) {
        var value = value
        binding = Binding<Value>(get: { value },
                                 set: { value = $0 })
        
        publisher = Future<Value, Error> { promise in
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                promise(.success(value))
            }
        }
        .eraseToAnyPublisher()
    }
}
