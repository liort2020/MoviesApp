//
//  MovieTypeCell.swift
//  MoviesApp
//
//  Created by Lior Tal on 21/08/2021.
//  Copyright © 2021 Lior Tal. All rights reserved.
//

import SwiftUI

struct MovieTypeCell: View {
    var movieType: String?
    
    var body: some View {
        Text(movieType ?? defaultEmptyTitle)
            .font(textFont)
            .padding(.all, textPadding)
            .foregroundColor(textColor)
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(borderColor, lineWidth: borderWidth)
            )
            .background(RoundedRectangle(cornerRadius: cornerRadius)
                            .fill(backgroundColor))
            .padding(.all, cellPadding)
    }
    
    // MARK: Constants
    private let cornerRadius: CGFloat = 6
    private let width: CGFloat = 2
    private let textFont: Font = .system(size: 16)
    private let borderColor: Color = .secondary
    private let textColor: Color = .secondary
    private let backgroundColor: Color = .white
    private let borderWidth: CGFloat = 1
    private let defaultEmptyTitle = ""
    private let textPadding: CGFloat = 1
    private let cellPadding: CGFloat = 5
}

// MARK: - Previews
struct MovieTypeCell_Previews: PreviewProvider {
    private static let movieType = "upcoming"
    
    static var previews: some View {
        Group {
            // preview light mode
            MovieTypeCell(movieType: movieType)
                .preferredColorScheme(.light)
            
            // preview dark mode
            MovieTypeCell(movieType: movieType)
                .preferredColorScheme(.dark)
            
            // preview right to left
            MovieTypeCell(movieType: movieType)
                .environment(\.layoutDirection, .rightToLeft)
                .previewDisplayName(#"\.layoutDirection, .rightToLeft"#)
            
            // preview accessibility medium
            MovieTypeCell(movieType: movieType)
                .environment(\.sizeCategory, .accessibilityMedium)
        }
    }
}
