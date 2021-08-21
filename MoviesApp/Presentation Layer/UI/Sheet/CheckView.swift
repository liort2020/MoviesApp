//
//  CheckView.swift
//  MoviesApp
//
//  Created by Lior Tal on 21/08/2021.
//  Copyright © 2021 Lior Tal. All rights reserved.
//

import SwiftUI

struct CheckView: View {
    @Binding var isChecked: Bool
    @Binding var selectedFilters: [Bool]
    var title: String
    var index: Int
    
    var body: some View {
        Button(action: toggle) {
            HStack {
                Image(systemName: isChecked ? checkedSystemImage : uncheckedSystemImage)
                Text(title)
            }
        }
    }
    
    // MARK: Helper Functions
    private func toggle() {
        isChecked = !isChecked
        updateSelectedFilter(index: index)
    }
    
    private func updateSelectedFilter(index selectedIndex: Int) {
        var newSelectedFiltersArray: [Bool] = []
        selectedFilters.indices.forEach { index in
            guard index == selectedIndex else {
                newSelectedFiltersArray.append(false)
                return
            }
            newSelectedFiltersArray.append(true)
        }
        $selectedFilters.wrappedValue = newSelectedFiltersArray
    }
    
    // MARK: Constants
    private let checkedSystemImage = "checkmark.square"
    private let uncheckedSystemImage = "square"
}

// MARK: - Previews
struct CheckView_Previews: PreviewProvider {
    private static let checked = Binding.constant(true)
    private static let unchecked = Binding.constant(false)
    private static let selectedFilters = Binding.constant([true, false, false, false])
    private static let title = "none"
    private static let index = 0
    
    static var previews: some View {
        Group {
            // MARK: - Checked
            // preview light mode
            CheckView(isChecked: checked,
                      selectedFilters: selectedFilters,
                      title: title,
                      index: index)
                .preferredColorScheme(.light)
                .previewLayout(.sizeThatFits)
            
            // preview dark mode
            CheckView(isChecked: checked,
                      selectedFilters: selectedFilters,
                      title: title,
                      index: index)
                .preferredColorScheme(.dark)
                .previewLayout(.sizeThatFits)
            
            // MARK: - Unchecked
            // preview light mode
            CheckView(isChecked: unchecked,
                      selectedFilters: selectedFilters,
                      title: title,
                      index: index)
                .preferredColorScheme(.light)
                .previewLayout(.sizeThatFits)
            
            // preview dark mode
            CheckView(isChecked: unchecked,
                      selectedFilters: selectedFilters,
                      title: title,
                      index: index)
                .preferredColorScheme(.dark)
                .previewLayout(.sizeThatFits)
        }
    }
}
