//
//  FilterButtonView.swift
//  MoviesApp
//
//  Created by Lior Tal on 21/08/2021.
//  Copyright © 2021 Lior Tal. All rights reserved.
//

import SwiftUI

struct FilterButtonView: View {
    @Binding var showModalFilterView: Bool
    
    var body: some View {
        Button(action: {
            showModalFilterView = true
        }) {
            Image(systemName: filterButtonSystemImage)
                .resizable()
                .foregroundColor(filterButtonColor)
        }
    }
    
    // MARK: Constants
    private let filterButtonSystemImage = "line.horizontal.3.decrease.circle"
    private let filterButtonColor: Color = .primary
}

// MARK: - Previews
struct FilterButtonView_Previews: PreviewProvider {
    private static let showModalFilterView = Binding.constant(false)
    static var previews: some View {
        Group {
            // preview light mode
            FilterButtonView(showModalFilterView: showModalFilterView)
                .preferredColorScheme(.light)
                .previewLayout(.sizeThatFits)

            // preview dark mode
            FilterButtonView(showModalFilterView: showModalFilterView)
                .preferredColorScheme(.dark)
                .previewLayout(.sizeThatFits)
        }
    }
}
