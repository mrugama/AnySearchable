//
//  SearchableDropdownNavigatorVieww.swift
//  Demo
//
//  Created by MacBook on 4/25/24.
//

import SwiftUI

struct DropdownRowView<Item: AnySearchableItem & Identifiable>: View {
    
    var screenTitle: String
    var items: [Item]
    
    @Binding var selectedItem: any AnySearchableItem
    
    var body: some View {
        NavigationLink {
            SearchContentView<Item>(
                screenTitle: selectedItem.itemName,
                items: items,
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
            .clipShape(
                RoundedRectangle(cornerRadius: 10)
            )
            .overlay {
                RoundedRectangle(cornerRadius: 10).stroke(lineWidth: 2.0)
            }
        }
    }
}

#Preview {
    DropdownRowView(
        screenTitle: "Option",
        items: [
            ElectricityBill(
                name: "Electricity",
                number: "123",
                planType: .prepaid)],
        selectedItem: .constant(
            noneSelectedItem(name: "Select a electricity bill")
        )
    )
}
