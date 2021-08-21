//
//  MoviesListView.swift
//  MoviesApp
//
//  Created by Lior Tal on 21/08/2021.
//  Copyright © 2021 Lior Tal. All rights reserved.
//

import SwiftUI

struct MoviesListView<ViewModel>: View where ViewModel: MoviesListViewModel {
    @EnvironmentObject var moviesListViewModel: ViewModel
    @Binding var selectedFilters: [Bool]
    var tabType: TabType
    
    var body: some View {
        Group {
            if isMovieListLoaded && !isFilteredMoviesListEmpty {
                ScrollView {
                    LazyVStack(alignment: .leading, spacing: cellSpacing) {
                        ForEach(filteredMovies) { movie in
                            NavigationLink(
                                destination: movieDetailsView(movie: movie),
                                tag: movie,
                                selection: $moviesListViewModel.routing.movieDetails,
                                label: {
                                    MovieCellView(movie: movie)
                                        .background(cellBackgroundColor)
                                        .cornerRadius(cellCornerRadius)
                                        .padding(.horizontal, horizontalCellPadding)
                                        .shadow(radius: cellShadowRadius)
                                })
                        }
                        
                        // MARK: Pagination cell
                        if tabType == .movies {
                            ProgressCellView()
                                .onAppear {
                                    fetchMovies(enableIsLoading: false)
                                }
                        }
                    }.padding(.top, topLazyVStackPadding)
                }
            } else if isMovieListEmpty {
                VStack {
                    Spacer()
                    EmptyTextView(emptyTitle: emptyListTitle)
                        .padding(.bottom, bottomEmptyCellViewPadding)
                    Spacer()
                }
            } else if isFilteredMoviesListLoadedAndEmpty {
                VStack {
                    Spacer()
                    EmptyTextView(emptyTitle: emptyFilterTitle)
                        .padding(.bottom, bottomEmptyCellViewPadding)
                    Spacer()
                }
            } else {
                EmptyView()
            }
        }
    }
    
    // MARK: Navigation
    func movieDetailsView(movie: Movie) -> some View {
        MovieDetailsView(movieDetailsViewModel: RealMovieDetailsViewModel(diContainer: diContainer, movie: movie), likedButton: movie.favorite)
    }
    
    // MARK: Computed Properties
    private var movies: [Movie] {
        moviesListViewModel.movies
    }
    
    private var diContainer: DIContainer {
        moviesListViewModel.diContainer
    }
    
    private var isMovieListLoaded: Bool {
        !moviesListViewModel.isLoading && !movies.isEmpty
    }
    
    private var isMovieListEmpty: Bool {
        !moviesListViewModel.isLoading && movies.isEmpty
    }
    
    private var isFilteredMoviesListLoadedAndEmpty: Bool {
        !moviesListViewModel.isLoading && filteredMovies.isEmpty
    }
    
    private var isFilteredMoviesListEmpty: Bool {
        filteredMovies.isEmpty
    }
    
    // MARK: Constants
    private let topLazyVStackPadding: CGFloat = 10
    // Cell
    private let cellSpacing: CGFloat = 6
    private let horizontalCellPadding: CGFloat = 8
    private let cellShadowRadius: CGFloat = 2
    private let cellCornerRadius: CGFloat = 6
    private let cellBackgroundColor = Color(UIColor.systemBackground)
    // Empty Cell
    private let bottomEmptyCellViewPadding: CGFloat = 150
    private let emptyListTitle = "No Data Available"
    private let emptyFilterTitle = "No Data Found"
}

// MARK: - Actions
extension MoviesListView {
    private func fetchMovies(enableIsLoading: Bool) {
        moviesListViewModel.fetchMovies(enableIsLoading: enableIsLoading)
    }
}

// MARK: - Filter
extension MoviesListView {
    var filteredMovies: [Movie] {
        let selectedFilterIndex = selectedFilters.enumerated().first { $1 }.map { $0.0 }
        guard let selectedIndex = selectedFilterIndex else { return movies }
        let filter = FilterType.allCases[selectedIndex]
        
        switch filter {
        case .none:
            return movies
        case .upcoming:
            return movies.filter { $0.type == MovieType.upcoming.rawValue }
        case .topRated:
            return movies.filter { $0.type == MovieType.topRated.rawValue }
        case .nowPlaying:
            return movies.filter { $0.type == MovieType.nowPlaying.rawValue }
        }
    }
}

// MARK: - Previews
struct MoviesListView_Previews: PreviewProvider {
    private static let fakeMoviesListViewModel = RealMoviesListViewModel(diContainer: DIContainer(), movies: FakeMovies.all, isLoading: false)
    private static let fakeEmptyListViewModel = RealMoviesListViewModel(diContainer: DIContainer(), isLoading: false)
    private static let selectedFilters = Binding.constant([true, false, false, false])
    
    static var previews: some View {
        Group {
            // MARK: With movies
            // preview light mode
            MoviesListView<RealMoviesListViewModel>(selectedFilters: selectedFilters, tabType: .movies)
                .environmentObject(fakeMoviesListViewModel)
                .preferredColorScheme(.light)
            
            // preview dark mode
            MoviesListView<RealMoviesListViewModel>(selectedFilters: selectedFilters, tabType: .movies)
                .environmentObject(fakeMoviesListViewModel)
                .preferredColorScheme(.dark)
            
            // preview right to left
            MoviesListView<RealMoviesListViewModel>(selectedFilters: selectedFilters, tabType: .movies)
                .environmentObject(fakeMoviesListViewModel)
                .environment(\.layoutDirection, .rightToLeft)
                .previewDisplayName(#"\.layoutDirection, .rightToLeft"#)
            
            // preview accessibility medium
            MoviesListView<RealMoviesListViewModel>(selectedFilters: selectedFilters, tabType: .movies)
                .environmentObject(fakeMoviesListViewModel)
                .environment(\.sizeCategory, .accessibilityMedium)
            
            // MARK: Without movies
            // preview light mode
            MoviesListView<RealMoviesListViewModel>(selectedFilters: selectedFilters, tabType: .movies)
                .environmentObject(fakeEmptyListViewModel)
                .preferredColorScheme(.light)
            
            // preview dark mode
            MoviesListView<RealMoviesListViewModel>(selectedFilters: selectedFilters, tabType: .movies)
                .environmentObject(fakeEmptyListViewModel)
                .preferredColorScheme(.dark)
            
            // preview right to left
            MoviesListView<RealMoviesListViewModel>(selectedFilters: selectedFilters, tabType: .movies)
                .environmentObject(fakeEmptyListViewModel)
                .environment(\.layoutDirection, .rightToLeft)
                .previewDisplayName(#"\.layoutDirection, .rightToLeft"#)
            
            // preview accessibility medium
            MoviesListView<RealMoviesListViewModel>(selectedFilters: selectedFilters, tabType: .movies)
                .environmentObject(fakeEmptyListViewModel)
                .environment(\.sizeCategory, .accessibilityMedium)
        }
    }
}
