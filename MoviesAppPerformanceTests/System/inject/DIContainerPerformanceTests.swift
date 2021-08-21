//
//  DIContainerPerformanceTests.swift
//  MoviesAppPerformanceTests
//
//  Created by Lior Tal on 21/08/2021.
//  Copyright © 2021 Lior Tal. All rights reserved.
//

import XCTest
@testable import MoviesApp

final class DIContainerPerformanceTests: XCTestCase {
    func test_boot_performance() {
        measure {
            let _ = DIContainer.boot()
        }
    }
}
