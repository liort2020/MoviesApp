//
//  MoviesTabView.swift
//  MoviesApp
//
//  Created by Lior Tal on 21/08/2021.
//  Copyright © 2021 Lior Tal. All rights reserved.
//

import SwiftUI

enum TabType {
    case movies
    case favorites
}

struct MoviesTabView: View {
    @Environment(\.inject) var diContainer: DIContainer
    var moviesListViewModel: RealMoviesListViewModel
    var favoritesMoviesListViewModel: RealMoviesListViewModel
    
    var body: some View {
        TabView {
            // MARK: Movies Tab
            MoviesNavigationView<RealMoviesListViewModel>(tabType: .movies, navigationBarTitle: moviesLabel)
                .environmentObject(moviesListViewModel)
                .tabItem {
                    Label(moviesLabel, systemImage: moviesTabSystemImage)
                }
            
            // MARK: Favorites Tab
            MoviesNavigationView<RealMoviesListViewModel>(tabType: .favorites, navigationBarTitle: favoritesLabel)
                .environmentObject(favoritesMoviesListViewModel)
                .tabItem {
                    Label(favoritesLabel, systemImage: favoritesTabSystemImage)
                }
        }
    }
    
    // MARK: Constants
    // Movies Tab
    var moviesTabSystemImage = "list.dash"
    var moviesLabel = "Movies"
    // Favorites Tab
    var favoritesTabSystemImage = "list.star"
    var favoritesLabel = "Favorites"
}

// MARK: - Previews
struct MoviesTabView_Previews: PreviewProvider {
    private static let diContainer = DIContainer.boot()
    private static let moviesListViewModel = RealMoviesListViewModel(diContainer: Self.diContainer)
    private static let favoritesMoviesListViewModel = RealMoviesListViewModel(diContainer: Self.diContainer)
    
    static var previews: some View {
        Group {
            // preview light mode
            MoviesTabView(moviesListViewModel: moviesListViewModel,
                          favoritesMoviesListViewModel: favoritesMoviesListViewModel)
                .inject(diContainer)
                .preferredColorScheme(.light)

            // preview dark mode
            MoviesTabView(moviesListViewModel: moviesListViewModel,
                          favoritesMoviesListViewModel: favoritesMoviesListViewModel)
                .inject(diContainer)
                .preferredColorScheme(.dark)

            // preview right to left
            MoviesTabView(moviesListViewModel: moviesListViewModel,
                          favoritesMoviesListViewModel: favoritesMoviesListViewModel)
                .inject(diContainer)
                .environment(\.layoutDirection, .rightToLeft)
                .previewDisplayName(#"\.layoutDirection, .rightToLeft"#)

            // preview accessibility medium
            MoviesTabView(moviesListViewModel: moviesListViewModel,
                          favoritesMoviesListViewModel: favoritesMoviesListViewModel)
                .inject(diContainer)
                .environment(\.sizeCategory, .accessibilityMedium)
        }
    }
}
