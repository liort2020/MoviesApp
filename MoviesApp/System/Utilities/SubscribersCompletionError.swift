//
//  SubscribersCompletionError.swift
//  MoviesApp
//
//  Created by Lior Tal on 21/08/2021.
//  Copyright © 2021 Lior Tal. All rights reserved.
//

import Combine

extension Subscribers.Completion {
    func checkError() -> Failure? {
        switch self {
        case .failure(let error):
            return error
        case .finished:
            return nil
        }
    }
}
