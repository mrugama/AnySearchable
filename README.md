# Search view with any searchable item
## Introduction
You have a view featuring three dropdown rows. Each row should lead to a search view presenting items, allowing users to search and filter them. Users can tap on any item and dismiss the search view.

While it's feasible to create a separate search view for each row, it's advisable to implement a reusable search view for better code organization and maintenance.

## Design 
<img width="439" alt="Screenshot 2024-04-25 at 4 54 29 PM" src="https://github.com/emmanuelkolawole4/Demo/assets/50505707/367b473d-09c3-4f34-9611-6446b0be1c4b">
## Solution
When a user taps on a row, it triggers a network request to fetch data. Each row corresponds to a different data point, resulting in distinct data types for each row. Below are sample data types for the three different rows:

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

Electricity provider:
```
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

The search view needs to be agnostic to data types. Our approach involves creating a protocol where we define the requirements for items to be displayed in the search view for any item.
