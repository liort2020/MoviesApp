//
//  DIContainer.swift
//  MoviesApp
//
//  Created by Lior Tal on 21/08/2021.
//  Copyright © 2021 Lior Tal. All rights reserved.
//

import SwiftUI
import Combine

typealias AppStateSubject = CurrentValueSubject<AppState, Never>

struct DIContainer {
    private(set) var appState: AppStateSubject?
    private(set) var interactors: Interactors?
    
    static func boot() -> DIContainer {
        let appState = CurrentValueSubject<AppState, Never>(AppState())
        
        let session = URLSession.shared
        let webRepositories = configureWebRepositories(using: session)
        let dbRepositories = configureDBRepositories()
        let interactors = configureInteractors(webRepositories: webRepositories, dbRepositories: dbRepositories, appState: appState)
        
        return DIContainer(appState: appState, interactors: interactors)
    }
    
    private static func configureWebRepositories(using session: URLSession) -> DIContainer.WebRepositories {
        let moviesWebRepository = RealMoviesWebRepository(session: session, baseURL: Constants.baseMoviesUrl)
        let imagesWebRepository = RealImagesWebRepository(session: session, baseURL: Constants.baseImagesUrl)
        return DIContainer.WebRepositories(moviesWebRepository: moviesWebRepository, imagesWebRepository: imagesWebRepository)
    }
    
    private static func configureDBRepositories() -> DIContainer.DBRepositories {
        let persistentStore = CoreDataStack()
        let moviesDBRepository = RealMoviesDBRepository(persistentStore: persistentStore)
        return DIContainer.DBRepositories(moviesDBRepository: moviesDBRepository)
    }
    
    private static func configureInteractors(webRepositories: DIContainer.WebRepositories, dbRepositories: DIContainer.DBRepositories, appState: AppStateSubject) -> DIContainer.Interactors {
        let moviesWebRepository: MoviesWebRepository = webRepositories.moviesWebRepository
        
        let moviesInteractor = RealMoviesInteractor(moviesWebRepository: moviesWebRepository,
                                                    imagesWebRepository: webRepositories.imagesWebRepository,
                                                    moviesDBRepository: dbRepositories.moviesDBRepository,
                                                    appState: appState)
        return DIContainer.Interactors(moviesInteractor: moviesInteractor)
    }
}
