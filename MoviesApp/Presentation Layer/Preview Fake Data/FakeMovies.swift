//
//  FakeMovies.swift
//  MoviesApp
//
//  Created by Lior Tal on 21/08/2021.
//  Copyright © 2021 Lior Tal. All rights reserved.
//

import Foundation

#if DEBUG
struct FakeMovies {
    private static func createFakeMovie(id: Int, movieType: MovieType, title: String, overview: String, releaseDate: String, rating: Double, posterPath: String, favorite: Bool) -> Movie {
        let movie = Movie(context: InMemoryContainer.container.viewContext)
        movie.id = Int32(id)
        movie.type = movieType.rawValue
        movie.title = title
        movie.overview = overview
        movie.releaseDate = releaseDate
        movie.rating = rating
        movie.posterPath = posterPath
        movie.favorite = favorite
        return movie
    }
    
    static var all: [Movie] {
        [
            createFakeMovie(id: 436969,
                            movieType: .upcoming,
                            title: "The Suicide Squad",
                            overview: "Supervillains Harley Quinn, Bloodsport, Peacemaker and a collection of nutty cons at Belle Reve prison join the super-secret, super-shady Task Force X as they are dropped off at the remote, enemy-infused island of Corto Maltese.",
                            releaseDate: "2021-07-28",
                            rating: 8.1,
                            posterPath: "/iCi4c4FvVdbaU1t8poH1gvzT6xM.jpg",
                            favorite: false),
            createFakeMovie(id: 451048,
                            movieType: .upcoming,
                            title: "Jungle Cruise",
                            overview: "Dr. Lily Houghton enlists the aid of wisecracking skipper Frank Wolff to take her down the Amazon in his dilapidated boat. Together, they search for an ancient tree that holds the power to heal – a discovery that will change the future of medicine.",
                            releaseDate: "2021-07-28",
                            rating: 7.9,
                            posterPath: "/9dKCd55IuTT5QRs989m9Qlb7d2B.jpg",
                            favorite: true),
            createFakeMovie(id: 497698,
                            movieType: .upcoming,
                            title: "Black Widow",
                            overview: "Natasha Romanoff, also known as Black Widow, confronts the darker parts of her ledger when a dangerous conspiracy with ties to her past arises. Pursued by a force that will stop at nothing to bring her down, Natasha must deal with her history as a spy and the broken relationships left in her wake long before she became an Avenger.",
                            releaseDate: "2021-07-07",
                            rating: 7.8,
                            posterPath: "/qAZ0pzat24kLdO3o8ejmbLxyOac.jpg",
                            favorite: true),
            createFakeMovie(id: 550988,
                            movieType: .upcoming,
                            title: "Free Guy",
                            overview: "A bank teller called Guy realizes he is a background character in an open world video game called Free City that will soon go offline.",
                            releaseDate: "2021-08-11",
                            rating: 8,
                            posterPath: "/acCS12FVUQ7blkC8qEbuXbsWEs2.jpg",
                            favorite: true)
        ]
    }
}
#endif
