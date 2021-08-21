//
//  MockedImagesWebRepository.swift
//  MoviesAppTests
//
//  Created by Lior Tal on 21/08/2021.
//  Copyright © 2021 Lior Tal. All rights reserved.
//

import XCTest
import Combine
@testable import MoviesApp

final class MockedImagesWebRepository: TestWebRepository, Mock, ImagesWebRepository {
    enum Action: Equatable {
        case download(imagePath: String?)
    }
    var actions = MockedList<Action>(expectedActions: [])
    
    var downloadResponse: Result<Data?, Error> = .failure(MockedError.valueNeedToBeSet)
    
    func download(imagePath: String?) -> AnyPublisher<Data?, Error> {
        add(.download(imagePath: imagePath))
        return downloadResponse.publish()
    }
}
