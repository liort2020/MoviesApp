//
//  MoviesListViewModel.swift
//  MoviesApp
//
//  Created by Lior Tal on 21/08/2021.
//  Copyright © 2021 Lior Tal. All rights reserved.
//

import SwiftUI
import Combine

protocol MoviesListViewModel: ObservableObject {
    var routing: MoviesListViewRouting { get set }
    var movies: [Movie] { get set }
    var isLoading: Bool { get set }
    var diContainer: DIContainer { get }
    
    func load(favorites: Bool)
    func fetchMovies(enableIsLoading: Bool)
    func fetchImages(enableIsLoading: Bool)
}

enum FilterType: String, CaseIterable {
    case none
    case upcoming
    case topRated
    case nowPlaying
}

class RealMoviesListViewModel: MoviesListViewModel {
    @Published var routing: MoviesListViewRouting
    @Published var movies: [Movie]
    @Published var isLoading: Bool
    private(set) var diContainer: DIContainer
    private var subscriptions = Set<AnyCancellable>()
    
    init(diContainer: DIContainer, movies: [Movie] = [], isLoading: Bool = true) {
        self.diContainer = diContainer
        self.movies = movies
        self.isLoading = isLoading
        
        // Configure Routing
        _routing = Published(initialValue: diContainer.appState?.value.routing.moviesList ?? MoviesListViewRouting())
        
        $routing
            .sink { moviesListViewRouting in
                diContainer.appState?.value.routing.moviesList = moviesListViewRouting
            }
            .store(in: &subscriptions)
    }
    
    func load(favorites: Bool = false) {
        isLoading(true)
        
        diContainer.interactors?.moviesInteractor
            .load(favorites: favorites)
            .sink { completion in
                if let error = completion.checkError() {
                    print(error.localizedDescription)
                }
            } receiveValue: { [weak self] allMovies in
                self?.update(allMovies: allMovies)
            }
            .store(in: &subscriptions)
    }
    
    func fetchMovies(enableIsLoading: Bool) {
        if enableIsLoading {
            isLoading(true)
        }
        
        diContainer.interactors?.moviesInteractor.fetchMovies(page: currentPage) { publisher in
            publisher
                .sink { completion in
                    if let error = completion.checkError() {
                        print(error.localizedDescription)
                    }
                } receiveValue: { [weak self] movies in
                    self?.currentPage += 1
                    self?.update(movies: movies, enableIsLoading: enableIsLoading)
                }
                .store(in: &self.subscriptions)
        }
    }
    
    func fetchImages(enableIsLoading: Bool) {
        if enableIsLoading {
            isLoading(true)
        }
        
        diContainer.interactors?.moviesInteractor.fetchImages { publisher in
            publisher
                .sink { completion in
                    if let error = completion.checkError() {
                        print(error.localizedDescription)
                    }
                } receiveValue: { [weak self] _ in
                    if enableIsLoading {
                        self?.isLoading(false)
                    }
                }
                .store(in: &self.subscriptions)
        }
    }
    
    // MARK: - Update UI
    private func isLoading(_ isLoading: Bool) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.isLoading = isLoading
        }
    }
    
    private func update(movies: [Movie], enableIsLoading: Bool) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            let newMovies = movies.filter {
                !self.movies.map { $0.id }.contains($0.id)
            }
            self.movies.append(contentsOf: newMovies)
            
            if enableIsLoading {
                self.isLoading = false
            }
        }
    }
    
    private func update(allMovies: [Movie]) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.movies = allMovies
            self.isLoading = false
        }
    }
    
    deinit {
        subscriptions.removeAll()
    }
}
