//
//  MoviesInteractor.swift
//  MoviesApp
//
//  Created by Lior Tal on 21/08/2021.
//  Copyright © 2021 Lior Tal. All rights reserved.
//

import SwiftUI
import Combine

protocol MoviesInteractor {
    func load(favorites: Bool) -> AnyPublisher<[Movie], Error>
    func fetchMovies(page: Int, completionHandler: @escaping (AnyPublisher<[Movie], Error>) -> Void)
    func fetchMovie(id: Int) -> AnyPublisher<[Movie], Error>
    func fetchImages(completionHandler: @escaping (AnyPublisher<[Movie], Error>) -> Void)
    func updateMovie(id: Int, favorite: Bool) -> AnyPublisher<Movie?, Error>
}

class RealMoviesInteractor: MoviesInteractor {
    private let moviesWebRepository: MoviesWebRepository
    private let imagesWebRepository: ImagesWebRepository
    private let moviesDBRepository: MoviesDBRepository
    private let appState: AppStateSubject
    private var subscriptions = Set<AnyCancellable>()
    
    init(moviesWebRepository: MoviesWebRepository,
         imagesWebRepository: ImagesWebRepository,
         moviesDBRepository: MoviesDBRepository,
         appState: AppStateSubject) {
        self.moviesWebRepository = moviesWebRepository
        self.imagesWebRepository = imagesWebRepository
        self.moviesDBRepository = moviesDBRepository
        self.appState = appState
    }
    
    func load(favorites: Bool = false) -> AnyPublisher<[Movie], Error> {
        moviesDBRepository
            .fetchMovies(favorites: favorites)
    }
    
    func fetchMovies(page: Int, completionHandler: @escaping (AnyPublisher<[Movie], Error>) -> Void) {
        moviesWebRepository
            // Fetch upcoming movies
            .getMovies(by: .upcoming, page: page)
            .flatMap { [moviesDBRepository] in
                // Save to database
                moviesDBRepository.store(moviesListWebModel: $0, movieType: .upcoming, favorite: false)
            }
            // Fetch top rated movies
            .flatMap { _ in
                self.moviesWebRepository.getMovies(by: .topRated, page: page)
            }
            .flatMap { [moviesDBRepository] in
                // Save to database
                moviesDBRepository.store(moviesListWebModel: $0, movieType: .topRated, favorite: false)
            }
            // Fetch now playing movies
            .flatMap { _ in
                self.moviesWebRepository.getMovies(by: .nowPlaying, page: page)
            }
            .flatMap { [moviesDBRepository] in
                // Save to database
                moviesDBRepository.store(moviesListWebModel: $0, movieType: .nowPlaying, favorite: false)
            }
            .eraseToAnyPublisher()
            .sink { completion in
                if let error = completion.checkError() {
                    print(error.localizedDescription)
                    completionHandler(self.load())
                }
            } receiveValue: { movies in
                completionHandler(self.load())
            }
            .store(in: &subscriptions)
    }
    
    func fetchMovie(id: Int) -> AnyPublisher<[Movie], Error> {
        moviesDBRepository
            .fetchMovie(id: id)
    }
    
    func fetchImages(completionHandler: @escaping (AnyPublisher<[Movie], Error>) -> Void) {
        moviesDBRepository
            .fetchMovies(favorites: false)
            .flatMap { (models) in
                Publishers.MergeMany(models.map { [self] model in
                    // Download image
                    self.imagesWebRepository
                        .download(imagePath: model.posterPath)
                        .replaceError(with: Data())
                        .flatMap { [moviesDBRepository] in
                            // Save image to database
                            moviesDBRepository.storeImage(data: $0, movieId: Int(model.id))
                        }
                })
                .collect()
            }
            .sink { completion in
                if let error = completion.checkError() {
                    print(error.localizedDescription)
                    completionHandler(self.load())
                }
            } receiveValue: { _ in
                completionHandler(self.load())
            }
            .store(in: &subscriptions)
    }
    
    func updateMovie(id movieId: Int, favorite: Bool) -> AnyPublisher<Movie?, Error> {
        moviesDBRepository
            .updateMovie(id: movieId, favorite: favorite)
    }
    
    deinit {
        subscriptions.removeAll()
    }
}
