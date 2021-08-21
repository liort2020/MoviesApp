//
//  MockedMovie+ImageData.swift
//  MoviesAppTests
//
//  Created by Lior Tal on 21/08/2021.
//  Copyright © 2021 Lior Tal. All rights reserved.
//

import SwiftUI

extension MockedMovie {
    static let testImageFileName = "test_image.jpg"
    
    static func testImageData() -> Data? {
        UIImage(named: Self.testImageFileName, in: Self.testBundle, compatibleWith: nil)?.pngData()
    }
}
