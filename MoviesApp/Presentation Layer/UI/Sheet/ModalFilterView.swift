//
//  ModalFilterView.swift
//  MoviesApp
//
//  Created by Lior Tal on 21/08/2021.
//  Copyright © 2021 Lior Tal. All rights reserved.
//

import SwiftUI

struct ModalFilterView: View {
    @Binding var selectedFilters: [Bool]
    @Binding var showModalFilterView: Bool
    private let filterTypes = FilterType.allCases
    
    var body: some View {
        NavigationView {
            List(filterTypes.indices) { index in
                CheckView(isChecked: $selectedFilters[index],
                          selectedFilters: $selectedFilters,
                          title: filterTypes[index].rawValue,
                          index: index)
            }
            .navigationBarItems(trailing: doneButtonView())
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle(navigationFilterViewTitle)
        }
    }
    
    private func doneButtonView() -> some View {
        Button(action: {
            showModalFilterView = false
        }) {
            Text(doneButtontitle)
        }
    }
    
    // MARK: Constants
    private let navigationFilterViewTitle = "Filter"
    private let titleFont: Font = .system(size: 16, weight: .regular)
    // Done Button
    private let doneButtontitle = "Done"
}

// MARK: - Previews
struct ModalFilterView_Previews: PreviewProvider {
    private static let showModalFilterView = Binding.constant(true)
    private static let selectedFilters = Binding.constant([true, false, false, false])
    
    static var previews: some View {
        Group {
            // preview light mode
            ModalFilterView(selectedFilters: selectedFilters, showModalFilterView: showModalFilterView)
                .preferredColorScheme(.light)
            
            // preview dark mode
            ModalFilterView(selectedFilters: selectedFilters, showModalFilterView: showModalFilterView)
                .preferredColorScheme(.dark)
            
            // preview right to left
            ModalFilterView(selectedFilters: selectedFilters, showModalFilterView: showModalFilterView)
                .environment(\.layoutDirection, .rightToLeft)
                .previewDisplayName(#"\.layoutDirection, .rightToLeft"#)
            
            // preview accessibility medium
            ModalFilterView(selectedFilters: selectedFilters, showModalFilterView: showModalFilterView)
                .environment(\.sizeCategory, .accessibilityMedium)
        }
    }
}
