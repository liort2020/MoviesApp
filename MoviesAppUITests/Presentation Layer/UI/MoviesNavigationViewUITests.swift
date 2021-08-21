//
//  MoviesNavigationViewUITests.swift
//  MoviesAppUITests
//
//  Created by Lior Tal on 21/08/2021.
//  Copyright © 2021 Lior Tal. All rights reserved.
//

import XCTest
@testable import MoviesApp

final class MoviesNavigationViewUITests: XCTestCase {
    private var application: XCUIApplication?
    private let navigationBarTitle = "Movies"
    
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        application = XCUIApplication()
        application?.launch()
    }
    
    func test_navigation_bar_exist() throws {
        let navigationBar = try XCTUnwrap(application).navigationBars[navigationBarTitle]
        XCTAssert(navigationBar.exists, "The navigation bar does not exist")
    }
    
    override func tearDown() {
        application = nil
        super.tearDown()
    }
}
