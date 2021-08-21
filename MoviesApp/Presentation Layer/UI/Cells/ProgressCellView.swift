//
//  ProgressCellView.swift
//  MoviesApp
//
//  Created by Lior Tal on 21/08/2021.
//  Copyright © 2021 Lior Tal. All rights reserved.
//

import SwiftUI
import Combine

struct ProgressCellView: View {
    @State var showProgressCell = true
    let timer = Timer.publish(every: Self.timeInSeconds, on: .main, in: .common).autoconnect()
    
    var body: some View {
        HStack {
            if showProgressCell {
                Spacer()
                ProgressView()
                Spacer()
            }
        }
        .onReceive(timer) { _ in
            showProgressCell = false
            timer.upstream.connect().cancel()
        }
        .onDisappear {
            timer.upstream.connect().cancel()
        }
    }
    
    // MARK: Constants
    private static let timeInSeconds: TimeInterval = 5
}

// MARK: - Previews
struct ProgressCellView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            // preview light mode
            ProgressCellView()
                .preferredColorScheme(.light)
                .previewLayout(.sizeThatFits)
            
            // preview dark mode
            ProgressCellView()
                .preferredColorScheme(.dark)
                .previewLayout(.sizeThatFits)
        }
    }
}
