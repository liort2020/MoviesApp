//
//  RatingCell.swift
//  MoviesApp
//
//  Created by Lior Tal on 21/08/2021.
//  Copyright © 2021 Lior Tal. All rights reserved.
//

import SwiftUI

struct RatingCell: View {
    var movieRating: Double
    
    var body: some View {
        Label {
            Text(rating)
                .lineLimit(numberOfLines)
                .font(textFont)
                .foregroundColor(textColor)
        } icon: {
            Image(systemName: favoriteSystemImage)
                .resizable()
                .foregroundColor(favoriteImageColor)
                .frame(width: defaultFavoriteImageSize, height: defaultFavoriteImageSize)
        }
    }
    
    // MARK: Computed Properties
    private var rating: String {
        String(format:"%.1f", movieRating)
    }
    
    // MARK: Constants
    // Favorite Image
    private let favoriteSystemImage = "star.fill"
    private let favoriteImageColor: Color = .yellow
    private let defaultFavoriteImageSize: CGFloat = 18
    // Text
    private let textColor: Color = .primary
    private let textFont: Font = .system(size: 17, weight: .medium)
    private let numberOfLines = 1
}

// MARK: - Previews
struct RatingCell_Previews: PreviewProvider {
    private static let movieRating = 8.4
    
    static var previews: some View {
        Group {
            // preview light mode
            RatingCell(movieRating: movieRating)
                .preferredColorScheme(.light)
                .previewLayout(.sizeThatFits)
            
            // preview dark mode
            RatingCell(movieRating: movieRating)
                .preferredColorScheme(.dark)
                .previewLayout(.sizeThatFits)
        }
    }
}
