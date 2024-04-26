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
To manage the array of bills, providers, and plans, as well as the selected item to be displayed in the parent view, we'll introduce a new model called NoneSelectedItem. This model will be used initially before any item is selected. Here's how we can modify the PaymentViewModel class
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
