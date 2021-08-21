//
//  WebRepository.swift
//  MoviesApp
//
//  Created by Lior Tal on 21/08/2021.
//  Copyright © 2021 Lior Tal. All rights reserved.
//

import Foundation
import Combine

protocol WebRepository {
    var bgQueue: DispatchQueue { get }
    var session: URLSession { get }
    var baseURL: String { get }
}

extension WebRepository {
    func requestURL<T>(endpoint: Endpoint, page: Int) -> AnyPublisher<T, Error> where T: Codable {
        guard let urlRequest = try? endpoint.request(url: baseURL, page: page) else {
            return Fail(error: WebError.invalidURL)
                .eraseToAnyPublisher()
        }
        
        return session
            .dataTaskPublisher(for: urlRequest)
            .tryMap { (data, response) in
                guard let response = response as? HTTPURLResponse else {
                    throw WebError.noResponse
                }
                
                guard response.isValidStatusCode() else {
                    throw WebError.httpCode(HTTPError(code: response.statusCode))
                }
                return data
            }
            .decode(type: T.self, decoder: JSONDecoder())
            .subscribe(on: bgQueue)
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    func requestImageURL(endpoint: Endpoint) -> AnyPublisher<Data?, Error> {
        guard let urlRequest = try? endpoint.request(url: baseURL) else {
            return Fail(error: WebError.invalidURL)
                .eraseToAnyPublisher()
        }
        
        return session
            .dataTaskPublisher(for: urlRequest)
            .tryMap { (data, response) in
                return data
            }
            .subscribe(on: bgQueue)
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
