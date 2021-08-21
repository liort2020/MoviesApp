//
//  MovieDetailsViewModel.swift
//  MoviesApp
//
//  Created by Lior Tal on 21/08/2021.
//  Copyright © 2021 Lior Tal. All rights reserved.
//

import SwiftUI
import Combine

protocol MovieDetailsViewModel: ObservableObject {
    var routing: MovieDetailsViewRouting { get set }
    var diContainer: DIContainer { get }
    var movie: Movie { get set }
    
    func updateMovie(id: Int, favorite: Bool)
}

class RealMovieDetailsViewModel: MovieDetailsViewModel {
    @Published var routing: MovieDetailsViewRouting
    @Published var movie: Movie
    private(set) var diContainer: DIContainer
    private var subscriptions = Set<AnyCancellable>()
    
    init(diContainer: DIContainer, movie: Movie) {
        self.diContainer = diContainer
        self.movie = movie
        
        // Configure Routing
        _routing = Published(initialValue: diContainer.appState?.value.routing.movieDetails ?? MovieDetailsViewRouting())
        
        $routing
            .sink { movieDetailsViewRouting in
                diContainer.appState?.value.routing.movieDetails = movieDetailsViewRouting
            }
            .store(in: &subscriptions)
    }
    
    func updateMovie(id movieId: Int, favorite: Bool) {
        guard let moviesInteractor = diContainer.interactors?.moviesInteractor else { return }
        
        moviesInteractor
            .updateMovie(id: movieId, favorite: favorite)
            .sink { completion in
                if let error = completion.checkError() {
                    print(error.localizedDescription)
                }
            } receiveValue: { [weak self] newMovies in
                if let newMovie = newMovies {
                    self?.movie.favorite = newMovie.favorite
                }
            }
            .store(in: &subscriptions)
    }
    
    deinit {
        subscriptions.removeAll()
    }
}
