//
//  ImageView.swift
//  MoviesApp
//
//  Created by Lior Tal on 21/08/2021.
//  Copyright © 2021 Lior Tal. All rights reserved.
//

import SwiftUI
import URLImage

struct ImageView: View {
    var url: URL
    var movieId: Int
    var width: CGFloat?
    var height: CGFloat?
    var contentMode: ContentMode = .fit
    
    var body: some View {
        HStack {
            URLImage(url: url,
                     options: URLImageOptions(identifier: id,
                                              expireAfter: expireAfter,
                                              cachePolicy: .returnCacheElseLoad(cacheDelay: nil, downloadDelay: 0.25)),
                     empty: {
                        emptyImageView(width: width, height: height, contentMode: contentMode)
                     },
                     inProgress: { _ in
                        ZStack {
                            emptyImageView(width: width, height: height, contentMode: contentMode)
                            ActivityIndicator()
                        }
                     },
                     failure: { _, _ in
                        emptyImageView(width: width, height: height, contentMode: contentMode)
                     },
                     content: { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: contentMode)
                            .clipped()
                     })
        }
        .frame(width: width, height: height)
    }
    
    // MARK: Computed Properties
    private var id: String {
        "\(movieId)"
    }
    
    private func emptyImageView(width: CGFloat? = nil, height: CGFloat? = nil, contentMode: ContentMode = .fit) -> some View {
        EmptyImageView(width: width, height: height, contentMode: contentMode)
    }
    
    // MARK: Constants
    private let expireAfter: TimeInterval = 24 * 60 * 60 // 86,400 second = 24 hours
}
