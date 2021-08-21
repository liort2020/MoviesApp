//
//  Movie+FetchRequest.swift
//  MoviesApp
//
//  Created by Lior Tal on 21/08/2021.
//  Copyright © 2021 Lior Tal. All rights reserved.
//

import CoreData

extension Movie {
    static let entityName = "Movie"
    
    static func requestAllItems(favorites: Bool) -> NSFetchRequest<Movie> {
        let request = NSFetchRequest<Movie>(entityName: entityName)
        if favorites {
            request.predicate = NSPredicate(format: "favorite == %@", NSNumber(value: true))
        }
        return request
    }
    
    static func requestAllItemsForDelete() -> NSFetchRequest<Movie> {
        NSFetchRequest<Movie>(entityName: entityName)
    }
    
    static func requestItem(using id: Int) -> NSFetchRequest<Movie> {
        let request = NSFetchRequest<Movie>(entityName: entityName)
        request.predicate = NSPredicate(format: "id == %i", Int32(id))
        return request
    }
}

// MARK: - Store
extension MovieModel {
    @discardableResult
    func store(in context: NSManagedObjectContext, movieType: MovieType, favorite: Bool) -> Movie {
        let baseModel = Movie(context: context)
        baseModel.id = Int32(id)
        baseModel.type = movieType.rawValue
        baseModel.title = title
        baseModel.overview = overview
        baseModel.releaseDate = releaseDate
        baseModel.rating = rating ?? Constants.defaultMovieRating
        baseModel.posterPath = posterPath
        baseModel.favorite = favorite
        return baseModel
    }
}
