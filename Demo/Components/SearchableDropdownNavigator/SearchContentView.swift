//
//  SearchableDropdownContentVieww.swift
//  Demo
//
//  Created by MacBook on 4/25/24.
//

import SwiftUI

struct SearchContentView<Item: AnySearchableItem & Identifiable>: View {
   
   var screenTitle: String
   var lightImageResource: ImageResource = .defaultIcon
   var darkImageResource: ImageResource = .defaultIcon
   
    var items: [Item]
   @Binding var selectedItem: any AnySearchableItem
    
    private var filteredItems: [Item] {
        if searchText.isEmpty {
            items
        } else {
            items.filter { $0.itemName.contains(searchText) }
        }
    }
   
   @Environment(\.colorScheme) var colorScheme
   @Environment(\.dismiss) private var dismiss
   @Environment(\.presentationMode) var presentationMode
   
   @State private var searchText = ""
   
   var body: some View {
      VStack {
         ZStack(alignment: .top) {
            navBar
               .ignoresSafeArea(edges: .top)
               .frame(height: UIScreen.main.bounds.height * 0.15)
            
            VStack {
               navContent
                  .padding(EdgeInsets(top: 15, leading: 20, bottom: 15, trailing: 15))
               
               mainView
            }
         }
      }
      .background(Color.white)
      .navigationBarHidden(true)
   }
}

private extension SearchContentView {
   
   var navBar: some View {
      Rectangle()
         .fill(Color.blue)
   }
   
   var navContent: some View {
      HStack {
         Button {
            handleDismiss()
         } label: {
            Image("arrow.left")
               .resizable()
               .scaledToFit()
               .frame(width: 25, height: 25)
               .padding(8)
               .background(Color.orange)
               .clipShape(Circle())
               .frame(width: 25, height: 25)
         }
         
         Spacer()
         
         Text(screenTitle)
            .font(.system(size: 18))
            .foregroundStyle(.white)
         
         Spacer()
         
         Button {
            
         } label: {
            Image(
               image(
                  lightName: lightImageResource,
                  darkName: darkImageResource,
                  forColorScheme: colorScheme
               )
            )
            .resizable()
            .scaledToFit()
            .frame(width: 25, height: 25)
            .padding(8)
            .background(Color.orange)
            .clipShape(Circle())
            .foregroundStyle(.white)
         }
      }
   }
   
   var mainView: some View {
      VStack(alignment: .leading) {
         SearchBarTextField(text: $searchText)
            .padding(.vertical)
         
         ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 10) {
               ForEach(filteredItems) { item in
                  Button(action: {
                     selectedItem = item
                     handleDismiss()
                  }) {
                     SearchableDropdownContentItemView(
                        itemName: item.itemName
                     )
                  }
               }
            }
         }
      }
      .padding()
      .background(
         Color.white
            .ignoresSafeArea()
      )
      .clipShape(RoundedShape(corners: [.topLeft, .topRight]))
   }
   
   func handleDismiss() {
      if #available(iOS 15, *) {
         dismiss()
      } else {
         presentationMode.wrappedValue.dismiss()
      }
   }
   
   private func image(
      lightName: ImageResource,
      darkName: ImageResource,
      forColorScheme colorScheme: ColorScheme
   ) -> ImageResource {
      switch colorScheme {
      case .light:
         return lightName
      case .dark:
         return darkName
      @unknown default:
         return lightName
      }
   }
}

#Preview(traits: .sizeThatFitsLayout) {
   SearchContentView<ElectricityBill>(
      screenTitle: "Provider",
      items: [
        ElectricityBill(name: "AEDC", number: "7023658921", planType: .prepaid),
        ElectricityBill(name: "Jos Electricity", number: "7023658921", planType: .postpaid),
        ElectricityBill(name: "BEDC Electricity", number: "7023658921", planType: .prepaid),
        ElectricityBill(name: "IBEDC", number: "7023658921", planType: .prepaid),
        ElectricityBill(name: "KAEDCO", number: "7023658921", planType: .postpaid)
      ], 
      selectedItem: .constant(ElectricityBill(name: "123", number: "123", planType: .prepaid))
   )
}
