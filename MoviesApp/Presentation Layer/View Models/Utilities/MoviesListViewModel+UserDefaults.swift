//
//  MoviesListViewModel+UserDefaults.swift
//  MoviesApp
//
//  Created by Lior Tal on 21/08/2021.
//  Copyright © 2021 Lior Tal. All rights reserved.
//

import Foundation

extension RealMoviesListViewModel {
    enum UserDefaultsKeys: String {
        case currentPage
    }
    
    private static var defaultCurrentPage = 1
    
    var currentPage: Int {
        set {
            UserDefaults.standard.set(newValue, forKey: UserDefaultsKeys.currentPage.rawValue)
        }
        get {
            // check if value exists
            guard UserDefaults.standard.object(forKey: UserDefaultsKeys.currentPage.rawValue) != nil else {
                // Set default value
                UserDefaults.standard.set(Self.defaultCurrentPage, forKey: UserDefaultsKeys.currentPage.rawValue)
                return UserDefaults.standard.integer(forKey: UserDefaultsKeys.currentPage.rawValue)
            }
            return UserDefaults.standard.integer(forKey: UserDefaultsKeys.currentPage.rawValue)
        }
    }
}
