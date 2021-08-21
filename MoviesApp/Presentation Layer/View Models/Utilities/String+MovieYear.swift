//
//  String+MovieYear.swift
//  MoviesApp
//
//  Created by Lior Tal on 21/08/2021.
//  Copyright © 2021 Lior Tal. All rights reserved.
//

import Foundation

extension String {
    func getMovieYear() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        guard let date = dateFormatter.date(from: self) else { return self }
        
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year], from: date)
        
        guard let year = components.year else { return self }
        return String(year)
    }
}
