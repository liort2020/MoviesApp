//
//  MoviesApp.swift
//  MoviesApp
//
//  Created by Lior Tal on 21/08/2021.
//  Copyright © 2021 Lior Tal. All rights reserved.
//

import SwiftUI

@main
struct MoviesApp: App {
    private let diContainer = DIContainer.boot()
    
    var body: some Scene {
        WindowGroup {
            MoviesTabView(moviesListViewModel: RealMoviesListViewModel(diContainer: diContainer),
                          favoritesMoviesListViewModel: RealMoviesListViewModel(diContainer: diContainer))
                .inject(diContainer)
        }
    }
}
