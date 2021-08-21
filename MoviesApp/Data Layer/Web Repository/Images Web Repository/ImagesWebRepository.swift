//
//  ImagesWebRepository.swift
//  MoviesApp
//
//  Created by Lior Tal on 21/08/2021.
//  Copyright © 2021 Lior Tal. All rights reserved.
//

import Foundation
import Combine

protocol ImagesWebRepository: WebRepository {
    func download(imagePath: String?) -> AnyPublisher<Data?, Error>
}

class RealImagesWebRepository: ImagesWebRepository {
    let bgQueue = DispatchQueue(label: "images_web_repository_queue")
    let session: URLSession
    var baseURL: String
    
    init(session: URLSession, baseURL: String = "") {
        self.session = session
        self.baseURL = baseURL
    }
    
    func download(imagePath: String?) -> AnyPublisher<Data?, Error> {
        guard let imagePath = imagePath, !imagePath.isEmpty else {
            return Fail(error: WebError.invalidImage)
                .eraseToAnyPublisher()
        }
        return requestImageURL(endpoint: ImagesEndpoint.getPosterImage(path: imagePath))
            .eraseToAnyPublisher()
    }
}
