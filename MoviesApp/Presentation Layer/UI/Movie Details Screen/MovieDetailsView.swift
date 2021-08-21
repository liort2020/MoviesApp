//
//  MovieDetailsView.swift
//  MoviesApp
//
//  Created by Lior Tal on 21/08/2021.
//  Copyright © 2021 Lior Tal. All rights reserved.
//

import SwiftUI

struct MovieDetailsView<ViewModel>: View where ViewModel: MovieDetailsViewModel {
    @ObservedObject var movieDetailsViewModel: ViewModel
    @State var likedButton: Bool
    
    var body: some View {
        ScrollView {
            VStack {
                ZStack {
                    // MARK: Image
                    if let imageURL = imageURL {
                        ImageView(url: imageURL,
                                  movieId: movieId,
                                  height: defaultBlurImageSize,
                                  contentMode: blurImageContentMode)
                            .edgesIgnoringSafeArea(.all)
                            .blur(radius: blurRadius)
                    } else {
                        emptyImageView(height: defaultBlurImageSize,
                                       contentMode: blurImageContentMode)
                    }
                    
                    HStack {
                        Spacer()
                        if let imageURL = imageURL {
                            ImageView(url: imageURL,
                                      movieId: movieId,
                                      width: defaultMovieImageWidth,
                                      height: defaultMovieImageHeight,
                                      contentMode: blurImageContentMode)
                        } else {
                            emptyImageView(width: defaultMovieImageWidth,
                                           height: defaultMovieImageHeight,
                                           contentMode: blurImageContentMode)
                        }
                        Spacer()
                    }
                    
                    // MARK: Movie type cell
                    VStack {
                        HStack {
                            Spacer()
                            MovieTypeCell(movieType: movieDetailsViewModel.movie.type)
                        }
                        Spacer()
                    }
                }
                
                // MARK: Movie details
                VStack(alignment: .leading) {
                    Text(movieDetailsViewModel.movie.title ?? defaultEmptyTitle)
                        .font(titleFont)
                        .foregroundColor(titleColor)
                        .padding(.top, topTitlePadding)
                    
                    HStack(spacing: spacingRatingCellAndMovieYear) {
                        RatingCell(movieRating: movieDetailsViewModel.movie.rating)

                        HStack {
                            Text(movieYear)
                                .font(yearTitleFont)
                                .foregroundColor(yearTitleColor)
                        }
                        
                        Spacer()
                    }
                    
                    Text(movieDetailsViewModel.movie.overview ?? defaultEmptyTitle)
                        .font(storylineFont)
                        .foregroundColor(storylineColor)
                        .padding(.top, topStorylinePadding)
                }
                .padding(.bottom, movieDetailsBottomPadding)
                
                // MARK: Favorite Button
                Button(action: {
                    likedButton.toggle()
                    updateMovie(favorite: likedButton)
                }) {
                    Text(likedButton ? likedButtonLabel : unlikedButtonLabel)
                        .frame(minWidth: likedButtonMinimumFrame, maxWidth: .infinity)
                        .font(likedButtonFont)
                        .padding()
                        .foregroundColor(likedButton ? likedButtonLabelColor : unlikedButtonLabelColor)
                        .overlay(
                            RoundedRectangle(cornerRadius: likedButtonCornerRadius)
                                .stroke(likedButton ? likedButtonBorderColor : unlikedButtonBorderColor, lineWidth: likedButtonBorderWidth)
                        )
                        .background(RoundedRectangle(cornerRadius: likedButtonCornerRadius)
                                        .fill(likedButton ? likedButtonBackground : unlikedButtonBackground))
                        .padding()
                }
            }
            .padding()
        }
    }
    
    // MARK: Computed Properties
    private var movieId: Int {
        Int(movieDetailsViewModel.movie.id)
    }
    
    private var movieFavorite: Bool {
        movieDetailsViewModel.movie.favorite
    }
    
    private var imageURL: URL? {
        let baseImageURL = Constants.baseImagesUrl
        guard let posterPath = movieDetailsViewModel.movie.posterPath else { return nil }
        return URL(string: baseImageURL + posterPath)
    }
    
    private func emptyImageView(width: CGFloat? = nil, height: CGFloat? = nil, contentMode: ContentMode = .fit) -> some View {
        EmptyImageView(width: width, height: height, contentMode: contentMode)
    }
    
    private var movieYear: String {
        movieDetailsViewModel.movie.releaseDate?.getMovieYear() ?? defaultEmptyTitle
    }
    
    // MARK: Constants
    private let spacingRatingCellAndMovieYear: CGFloat = 10
    // Blur
    private let blurRadius: CGFloat = 50.0
    private let blurImageContentMode: ContentMode = .fill
    private let defaultBlurImageSize: CGFloat = 250
    // Movie image
    private let defaultMovieImageWidth: CGFloat = 150
    private let defaultMovieImageHeight: CGFloat = 250
    // Title
    private let titleColor: Color = .primary
    private let titleFont: Font = .system(size: 26, weight: .bold)
    private let topTitlePadding: CGFloat = 4
    // Storyline
    private let storylineColor: Color = .primary
    private let storylineFont: Font = .system(size: 16, weight: .regular)
    private let topStorylinePadding: CGFloat = 12
    private let defaultEmptyTitle = ""
    // Liked Button
    private let likedButtonLabel = "Added"
    private let likedButtonBackground: Color = .accentColor
    private let likedButtonLabelColor: Color = .white
    private let likedButtonBorderColor: Color = .accentColor
    // Unliked Button
    private let unlikedButtonLabel = "Add to Favorite"
    private let unlikedButtonBackground: Color = .clear
    private let unlikedButtonLabelColor: Color = .accentColor
    private let unlikedButtonBorderColor: Color = .accentColor
    // Liked and Unliked Buttons
    private let likedButtonCornerRadius: CGFloat = 25
    private let likedButtonBorderWidth: CGFloat = 2
    private let likedButtonMinimumFrame: CGFloat = 0
    private let likedButtonFont: Font = .system(size: 18)
    // Movie details
    private let movieDetailsBottomPadding: CGFloat = 8
    // Movie Year Title
    private let yearTitleColor: Color = .primary
    private let yearTitleFont: Font = .system(size: 17, weight: .medium)
}

// MARK: - Actions
extension MovieDetailsView {
    private func updateMovie(favorite: Bool) {
        movieDetailsViewModel.updateMovie(id: movieId, favorite: favorite)
    }
}

// MARK: - Previews
struct MovieDetailsView_Previews: PreviewProvider {
    private static let movieDetailsViewModel = RealMovieDetailsViewModel(diContainer: DIContainer(), movie: FakeMovies.all[0])
    
    static var previews: some View {
        Group {
            // MARK: - Liked Button
            // preview light mode
            MovieDetailsView(movieDetailsViewModel: movieDetailsViewModel, likedButton: true)
                .preferredColorScheme(.light)
            
            // preview dark mode
            MovieDetailsView(movieDetailsViewModel: movieDetailsViewModel, likedButton: true)
                .preferredColorScheme(.dark)
            
            // preview right to left
            MovieDetailsView(movieDetailsViewModel: movieDetailsViewModel, likedButton: true)
                .environment(\.layoutDirection, .rightToLeft)
                .previewDisplayName(#"\.layoutDirection, .rightToLeft"#)
            
            // preview accessibility medium
            MovieDetailsView(movieDetailsViewModel: movieDetailsViewModel, likedButton: true)
                .environment(\.sizeCategory, .accessibilityMedium)
            
            // MARK: - Unliked Button
            // preview light mode
            MovieDetailsView(movieDetailsViewModel: movieDetailsViewModel, likedButton: false)
                .preferredColorScheme(.light)
            
            // preview dark mode
            MovieDetailsView(movieDetailsViewModel: movieDetailsViewModel, likedButton: false)
                .preferredColorScheme(.dark)
            
            // preview right to left
            MovieDetailsView(movieDetailsViewModel: movieDetailsViewModel, likedButton: false)
                .environment(\.layoutDirection, .rightToLeft)
                .previewDisplayName(#"\.layoutDirection, .rightToLeft"#)
            
            // preview accessibility medium
            MovieDetailsView(movieDetailsViewModel: movieDetailsViewModel, likedButton: false)
                .environment(\.sizeCategory, .accessibilityMedium)
        }
    }
}
