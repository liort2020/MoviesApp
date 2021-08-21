//
//  MoviesDBRepository.swift
//  MoviesApp
//
//  Created by Lior Tal on 21/08/2021.
//  Copyright © 2021 Lior Tal. All rights reserved.
//

import Foundation
import Combine

protocol MoviesDBRepository {
    func fetchMovies(favorites: Bool) -> AnyPublisher<[Movie], Error>
    func fetchMovie(id: Int) -> AnyPublisher<[Movie], Error>
    func store(moviesListWebModel: MoviesListWebModel, movieType: MovieType, favorite: Bool) -> AnyPublisher<[Movie], Error>
    func storeImage(data: Data?, movieId: Int) -> AnyPublisher<[Movie], Error>
    func updateMovie(id: Int, favorite: Bool) -> AnyPublisher<Movie?, Error>
    func delete(movieId: Int) -> AnyPublisher<Void, Error>
}

struct RealMoviesDBRepository: MoviesDBRepository {
    private let persistentStore: PersistentStore
    
    init(persistentStore: PersistentStore) {
        self.persistentStore = persistentStore
    }
    
    func fetchMovies(favorites: Bool) -> AnyPublisher<[Movie], Error> {
        let fetchRequest = Movie.requestAllItems(favorites: favorites)
        return persistentStore
            .fetch(fetchRequest)
    }
    
    func fetchMovie(id: Int) -> AnyPublisher<[Movie], Error> {
        let fetchRequest = Movie.requestItem(using: id)
        return persistentStore
            .fetch(fetchRequest)
    }
    
    func store(moviesListWebModel: MoviesListWebModel, movieType: MovieType, favorite: Bool) -> AnyPublisher<[Movie], Error> {
        var publishers = [AnyPublisher<Movie, Error>]()
        
        moviesListWebModel.movies?.forEach { model in
            let fetchRequest = Movie.requestItem(using: model.id)
            let update = persistentStore
                .update(fetchRequest: fetchRequest) { item in
                    item.type = movieType.rawValue
                    item.title = model.title
                    item.overview = model.overview
                    item.releaseDate = model.releaseDate
                    item.rating = model.rating ?? Constants.defaultMovieRating
                    item.posterPath = model.posterPath
                    item.favorite = favorite
                } createNew: { context in
                    model.store(in: context, movieType: movieType, favorite: favorite)
                }
            publishers.append(update)
        }
        
        return Publishers.MergeMany(publishers)
            .collect()
            .eraseToAnyPublisher()
    }
    
    func storeImage(data: Data?, movieId: Int) -> AnyPublisher<[Movie], Error> {
        guard let data = data, !data.isEmpty else {
            return Empty()
                .eraseToAnyPublisher()
        }
        
        let fetchRequest = Movie.requestItem(using: movieId)
        return persistentStore
            .addImage(fetchRequest: fetchRequest) {
                $0.forEach { $0.imageData = data }
            }
    }
    
    func updateMovie(id movieId: Int, favorite: Bool) -> AnyPublisher<Movie?, Error> {
        let fetchRequest = Movie.requestItem(using: movieId)
        return persistentStore
            .update(fetchRequest: fetchRequest) { item in
                item.favorite = favorite
            }
    }
    
    func delete(movieId: Int) -> AnyPublisher<Void, Error> {
        let fetchRequest = Movie.requestItem(using: movieId)
        return persistentStore
            .delete(fetchRequest)
    }
}
