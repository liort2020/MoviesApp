//
//  MoviesListWebModel.swift
//  MoviesApp
//
//  Created by Lior Tal on 21/08/2021.
//  Copyright © 2021 Lior Tal. All rights reserved.
//

import Foundation

struct MoviesListWebModel: Codable, Equatable {
    let movies: [MovieWebModel]?
    
    enum CodingKeys: String, CodingKey {
        case movies = "results"
    }
}

struct MovieWebModel: Codable, MovieModel {
    let id: Int
    let title: String?
    let overview: String?
    let releaseDate: String?
    let rating: Double?
    let posterPath: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case overview
        case releaseDate = "release_date"
        case rating = "vote_average"
        case posterPath = "poster_path"
    }
}

/*
 {
     "page": 1,
     "results": [
         {
             "adult": false,
             "backdrop_path": "/jlGmlFOcfo8n5tURmhC7YVd4Iyy.jpg",
             "genre_ids": [
                 28,
                 12,
                 14,
                 35
             ],
             "id": 436969,
             "original_language": "en",
             "original_title": "The Suicide Squad",
             "overview": "Supervillains Harley Quinn, Bloodsport, Peacemaker and a collection of nutty cons at Belle Reve prison join the super-secret, super-shady Task Force X as they are dropped off at the remote, enemy-infused island of Corto Maltese.",
             "popularity": 7243.123,
             "poster_path": "/iCi4c4FvVdbaU1t8poH1gvzT6xM.jpg",
             "release_date": "2021-07-28",
             "title": "The Suicide Squad",
             "video": false,
             "vote_average": 8.1,
             "vote_count": 2357
         }
     ],
     "total_pages": 55,
     "total_results": 1089
 }
 */
