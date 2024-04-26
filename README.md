# Search view with any searchable item
## Introduction
You have a view featuring three dropdown rows. Each row should lead to a search view presenting items, allowing users to search and filter them. Users can tap on any item and dismiss the search view.

While it's feasible to create a separate search view for each row, it's advisable to implement a reusable search view for better code organization and maintenance.

## Design 
<img width="439" alt="Screenshot 2024-04-25 at 4 54 29 PM" src="https://github.com/emmanuelkolawole4/Demo/assets/50505707/367b473d-09c3-4f34-9611-6446b0be1c4b">

## Solution
When a user taps on a row, it triggers a network request to fetch data. Each row corresponds to a different data point, resulting in distinct data types for each row. Below are sample data types for the three different rows.

### Modeling data

Electricity bill:
```Swift
struct ElectricityBill {
    var name: String
    var number: String
    var planType: PlanType
    
    enum PlanType: String {
        case prepaid, postpaid
    }
}

```

Electricity provider:
```Swift
struct ElectricityProvider {
    var name: String
}
```

Electricity plan:
```Swift
struct ElectricityPlan {
    var name: String
}
```

### Defining protocol
The search view needs to be agnostic to data types. Our approach involves creating a protocol where we define the requirements for items to be displayed in the search view for any item.

Protocol
```Swift
protocol AnyItemSearchable {
   var id: String { get }
   var itemName: String { get }
}
```

### Extending the models
We've defined a protocol called `AnySearchableItem`, specifying requirements for items to be displayed in the search view. Each item must provide an id and an itemName.

Let's extend our models and conform them to `AnySearchableItem`
```Swift
extension ElectricityBill: AnySearchableItem, Identifiable, Equatable {
    var id: String { UUID().uuidString }
    var itemName: String {
        if planType == .prepaid {
            return "\(name) (\(planType.rawValue.capitalized))"
        } else {
            return name
        }
    }
}

extension ElectricityProvider: AnySearchableItem, Identifiable, Equatable {
   var id: String { UUID().uuidString }
   var itemName: String { name }
}

extension ElectricityPlan: AnySearchableItem, Identifiable, Equatable {
   var id: String { UUID().uuidString }
   var itemName: String { name }
}
```

We conform the models to `AnySearchableItem`, `Identifiable`, and `Equatable`. We need to conform to `Identifiable` to display our data in a list view, and to `Equatable` to compare and filter our elements.

### ViewModel
To manage the array of bills, providers, and plans, as well as the selected item to be displayed in the parent view, we'll introduce a new model called `NoneSelectedItem`. This model will be used initially before any item is selected. Here's how we can modify the PaymentViewModel class
```Swift
final class PaymentViewModel {
    @Published var savedElectricityBills: [ElectricityBill] = []
    @Published var electricityProviders: [ElectricityProvider] = []
    @Published var electricityPlans: [ElectricityPlan] = []

    @Published var selectedSavedElectricityBill: any AnySearchableItem = noneSelectedItem(name: "Saved Bills")
    @Published var selectedElectricityProvider: any AnySearchableItem = noneSelectedItem(name: "Select a provider")
    @Published var selectedElectricityPlan: any AnySearchableItem = noneSelectedItem(name: "Select plan")
}

struct NoneSelectedItem: AnySearchableItem {
    var id: String { UUID().uuidString }
    var itemName: String
}
```
In this updated version:

- We define a selectedItem property in the PaymentViewModel class to hold the currently selected item. Initially, it's set to an instance of NoneSelectedItem.
- The NoneSelectedItem struct conforms to the AnySearchableItem protocol, providing an id and an itemName. It represents the case when no item is selected.
- When navigating to the search view, you can replace the selectedItem property with one of the concrete types of bills, providers, or plans based on user selection.

## User interface

### Parent view (Electricity bill)
In the ElectricityBillView, which houses the dropdown rows, we need to display all the rows and hold a reference to the PaymentViewModel. Here's how you can define the ElectricityBillView:
```Swift
struct ElectricityBillView: View {
    @ObservedObject var viewModel: PaymentViewModel

    var body: some View {
        // Display dropdown rows here
    }
}
```
In this code snippet:

- We define the ElectricityBillView struct with a property viewModel of type PaymentViewModel.
- The @ObservedObject property wrapper is used to observe changes to the viewModel object, ensuring that the view updates appropriately when the data in the view model changes.
- Inside the body property, you can add the code to display the dropdown rows.


### Dropdown row
Here's how you can implement the DropdownRowView struct to display the dropdown row and navigate to the SearchContentView
```Swift
import SwiftUI

struct DropdownRowView<Item: AnySearchableItem & Identifiable & Equatable>: View {
    var screenTitle: String
    var items: [Item]
    @Binding var selectedItem: AnySearchableItem?

    var body: some View {
        NavigationLink {
            SearchContentView<Item>(
                screenTitle: selectedItem.itemName,
                title: screenTitle,
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

```
In this code:

We use a NavigationLink to navigate to the SearchContentView when the user taps on the dropdown row.
The SearchContentView requires a binding to the selectedItem property so that it can update the selected item based on user interaction.
The selectedItem property is bound to the DropdownRowView, allowing it to display the currently selected item and update it when a new item is selected in the search view.

### Search view with generic item
```Swift
import SwiftUI

struct SearchContentView<Item: AnySearchableItem & Identifiable>: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.presentationMode) var presentationMode
    
    var screenTitle: String = "Title"
    var items: [Item]
    @Binding var selectedItem: AnySearchableItem?

    @State private var searchText: String = ""

    private var filteredDatasource: [Item] {
        if searchText.isEmpty {
            return items
        } else {
            return items.filter { $0.itemName.localizedCaseInsensitiveContains(searchText) }
        }
    }

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

    var mainView: some View {
        VStack(alignment: .leading) {
            SearchBarTextField(text: $searchText)
                .padding(.vertical)

            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 10) {
                    ForEach(filteredDatasource) { item in
                        Button(action: {
                            selectedItem = item
                            handleDismiss()
                        }) {
                            SearchableDropdownContentItemView(itemName: item.itemName)
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
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
    }

    private var navBar: some View {
        VStack {
            HStack {
                Button(action: {
                    handleDismiss()
                }) {
                    Image(systemName: "chevron.backward")
                        .foregroundColor(.black)
                        .padding()
                }

                Spacer()

                Text(screenTitle)
                    .font(.headline)
                    .foregroundColor(.black)

                Spacer()
            }
        }
        .frame(maxWidth: .infinity)
        .background(Color.white)
    }

    private var navContent: some View {
        // Additional navigation content can be added here
        EmptyView()
    }

    private func handleDismiss() {
        dismiss()
        presentationMode.wrappedValue.dismiss()
    }
}
```
In this implementation:

The SearchContentView displays a list of items that can be filtered by a search query.
Each item in the list is selectable, and upon selection, the selected item is sent back to the parent view and the search view is dismissed.
The view includes a navigation bar with a back button to dismiss the search view.
It also includes a search bar for filtering items by name.
Additional navigation content can be added to the navContent property if needed.
The handleDismiss() function is responsible for dismissing the search view when the user selects an item or taps the back button.

