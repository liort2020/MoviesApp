//
//  MovieModel.swift
//  MoviesApp
//
//  Created by Lior Tal on 21/08/2021.
//  Copyright © 2021 Lior Tal. All rights reserved.
//

import Foundation

protocol MovieModel: Equatable {
    var id: Int { get }
    var title: String? { get }
    var overview: String? { get }
    var releaseDate: String? { get }
    var rating: Double? { get }
    var posterPath: String? { get }
}

enum MovieType: String {
    case upcoming
    case topRated
    case nowPlaying
}
