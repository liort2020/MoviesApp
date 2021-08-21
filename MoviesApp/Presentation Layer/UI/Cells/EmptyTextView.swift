//
//  EmptyTextView.swift
//  MoviesApp
//
//  Created by Lior Tal on 21/08/2021.
//  Copyright © 2021 Lior Tal. All rights reserved.
//

import SwiftUI

struct EmptyTextView: View {
    var emptyTitle: String
    
    var body: some View {
        Text(emptyTitle)
            .foregroundColor(emptyTitleColor)
            .font(emptyTitleFont)
    }
    
    // MARK: Constants
    private let emptyTitleColor: Color = .secondary
    private let emptyTitleFont: Font = .system(size: 20)
}

// MARK: - Previews
struct EmptyTextView_Previews: PreviewProvider {
    private static let emptyListTitle = "No Data Available"
    
    static var previews: some View {
        Group {
            // preview light mode
            EmptyTextView(emptyTitle: emptyListTitle)
                .preferredColorScheme(.light)
                .previewLayout(.sizeThatFits)
            
            // preview dark mode
            EmptyTextView(emptyTitle: emptyListTitle)
                .preferredColorScheme(.dark)
                .previewLayout(.sizeThatFits)
        }
    }
}
