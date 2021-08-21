//
//  EmptyImageView.swift
//  MoviesApp
//
//  Created by Lior Tal on 21/08/2021.
//  Copyright © 2021 Lior Tal. All rights reserved.
//

import SwiftUI

struct EmptyImageView: View {
    var width: CGFloat?
    var height: CGFloat?
    var contentMode: ContentMode = .fit
    
    var body: some View {
        HStack {
            if let emptyImage = UIImage(named: emptyImageName) {
                Image(uiImage: emptyImage)
                    .resizable()
                    .aspectRatio(contentMode: contentMode)
                    .clipped()
            }
        }
        .frame(width: width, height: height)
    }
    
    // MARK: Constants
    private let emptyImageName = "empty_image.jpg"
}

// MARK: - Previews
struct EmptyImageView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            // preview light mode
            EmptyImageView(width: defaultImageSize, height: defaultImageSize)
                .preferredColorScheme(.light)
                .previewLayout(.sizeThatFits)
            
            // preview dark mode
            EmptyImageView(width: defaultImageSize, height: defaultImageSize)
                .preferredColorScheme(.dark)
                .previewLayout(.sizeThatFits)
        }
    }
    
    // MARK: Constants
    private static let defaultImageSize: CGFloat = 130
}
