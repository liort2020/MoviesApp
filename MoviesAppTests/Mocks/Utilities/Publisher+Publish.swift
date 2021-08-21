//
//  Publisher+Publish.swift
//  MoviesAppTests
//
//  Created by Lior Tal on 21/08/2021.
//  Copyright © 2021 Lior Tal. All rights reserved.
//

import XCTest
import Combine
@testable import MoviesApp

extension Result {
    func publish() -> AnyPublisher<Success, Failure> {
        return publisher.publish()
    }
}

extension Publisher {
    func publish() -> AnyPublisher<Output, Failure> {
        delay(for: .seconds(1.0), scheduler: RunLoop.main)
            .eraseToAnyPublisher()
    }
}
