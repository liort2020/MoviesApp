//
//  MoviesNavigationView.swift
//  MoviesApp
//
//  Created by Lior Tal on 21/08/2021.
//  Copyright © 2021 Lior Tal. All rights reserved.
//

import SwiftUI

struct MoviesNavigationView<ViewModel>: View where ViewModel: MoviesListViewModel {
    @EnvironmentObject var moviesListViewModel: ViewModel
    @State private var selectedFilters: [Bool] = [true, false, false, false]
    @State  private var isFirstLoad = true
    @State private var showModalFilterView: Bool = false
    var tabType: TabType
    var navigationBarTitle: String
    
    var body: some View {
        NavigationView {
            MoviesListView<RealMoviesListViewModel>(selectedFilters: $selectedFilters, tabType: tabType)
                .environmentObject(moviesListViewModel)
                .navigationBarTitleDisplayMode(.inline)
                .navigationTitle(navigationBarTitle)
                .navigationBarItems(trailing: filterButtonView())
                .onAppear {
                    if tabType == .favorites {
                        loadFavoriteMovies()
                    }
                }
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .sheet(isPresented: $showModalFilterView) {
            ModalFilterView(selectedFilters: $selectedFilters, showModalFilterView: $showModalFilterView)
        }
        .onAppear {
            if isFirstLoad && tabType == .movies {
                fetchMovies()
            }
            isFirstLoad = false
        }
    }
    
    // MARK: Computed Properties
    private var movies: [Movie] {
        moviesListViewModel.movies
    }
    
    private func filterButtonView() -> some View {
        FilterButtonView(showModalFilterView: $showModalFilterView)
    }
}

// MARK: - Actions
extension MoviesNavigationView {
    private func fetchMovies() {
        moviesListViewModel.load(favorites: true)
        
        moviesListViewModel.fetchMovies(enableIsLoading: true)
    }
    
    private func loadFavoriteMovies() {
        moviesListViewModel.load(favorites: true)
    }
}

// MARK: - Previews
struct MoviesNavigationView_Previews: PreviewProvider {
    private static let fakeMoviesListViewModel = RealMoviesListViewModel(diContainer: DIContainer(), movies: FakeMovies.all, isLoading: false)
    private static let fakeEmptyListViewModel = RealMoviesListViewModel(diContainer: DIContainer(), isLoading: false)
    private static let navigationBarTitle = "Movies"
    
    static var previews: some View {
        Group {
            // MARK: With movies
            // preview light mode
            MoviesNavigationView<RealMoviesListViewModel>(tabType: .movies, navigationBarTitle: Self.navigationBarTitle)
                .environmentObject(fakeMoviesListViewModel)
                .preferredColorScheme(.light)
            
            // preview dark mode
            MoviesNavigationView<RealMoviesListViewModel>(tabType: .movies, navigationBarTitle: Self.navigationBarTitle)
                .environmentObject(fakeMoviesListViewModel)
                .preferredColorScheme(.dark)
            
            // preview right to left
            MoviesNavigationView<RealMoviesListViewModel>(tabType: .movies, navigationBarTitle: Self.navigationBarTitle)
                .environmentObject(fakeMoviesListViewModel)
                .environment(\.layoutDirection, .rightToLeft)
                .previewDisplayName(#"\.layoutDirection, .rightToLeft"#)
            
            // preview accessibility medium
            MoviesNavigationView<RealMoviesListViewModel>(tabType: .movies, navigationBarTitle: Self.navigationBarTitle)
                .environmentObject(fakeMoviesListViewModel)
                .environment(\.sizeCategory, .accessibilityMedium)
            
            // MARK: Without movies
            // preview light mode
            MoviesNavigationView<RealMoviesListViewModel>(tabType: .movies, navigationBarTitle: Self.navigationBarTitle)
                .environmentObject(fakeEmptyListViewModel)
                .preferredColorScheme(.light)
            
            // preview dark mode
            MoviesNavigationView<RealMoviesListViewModel>(tabType: .movies, navigationBarTitle: Self.navigationBarTitle)
                .environmentObject(fakeEmptyListViewModel)
                .preferredColorScheme(.dark)
            
            // preview right to left
            MoviesNavigationView<RealMoviesListViewModel>(tabType: .movies, navigationBarTitle: Self.navigationBarTitle)
                .environmentObject(fakeEmptyListViewModel)
                .environment(\.layoutDirection, .rightToLeft)
                .previewDisplayName(#"\.layoutDirection, .rightToLeft"#)
            
            // preview accessibility medium
            MoviesNavigationView<RealMoviesListViewModel>(tabType: .movies, navigationBarTitle: Self.navigationBarTitle)
                .environmentObject(fakeEmptyListViewModel)
                .environment(\.sizeCategory, .accessibilityMedium)
        }
    }
}
