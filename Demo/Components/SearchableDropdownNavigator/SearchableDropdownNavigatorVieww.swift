//
//  SearchableDropdownNavigatorVieww.swift
//  Demo
//
//  Created by MacBook on 4/25/24.
//

import SwiftUI

struct SearchableDropdownNavigatorVieww<T: AnyItemSearchable & Identifiable & Equatable>: View {

    var screenTitle = "Option"
    var datasource: [T]
    
    @Binding var selectedItem: any AnyItemSearchable
    
    var body: some View {
        NavigationLink {
            SearchableDropdownContentVieww<T>(
                screenTitle: selectedItem.itemName,
                title: screenTitle,
                datasource: datasource,
                selectedItem: $selectedItem
            )
        } label: {
            HStack {
                Text(selectedItem.itemName)
                    .foregroundStyle(Color.primary)
                
                Spacer()
                
                Image(systemName: "chevron.down")
                    .foregroundColor(.primary)
            }
            .padding()
            .background(Color.secondary.opacity(0.1))
        }
    }
}

//#Preview {
//   SearchableDropdownNavigatorVieww<T: AnyItemSearchable>()
//}
