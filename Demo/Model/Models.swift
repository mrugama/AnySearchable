//
//  Models.swift
//  Demo
//
//  Created by MacBook on 4/25/24.
//

import Foundation
import SwiftUI

enum Action: CaseIterable {
   case withdraw
   case swap
   case recharge
   case electricity
   case cableTV
   
   var title: String {
      switch self {
      case .withdraw:
         return "Withdraw"
      case .swap:
         return "Swap"
      case .recharge:
         return "Recharge"
      case .electricity:
         return "Electricity"
      case .cableTV:
         return "Cable TV"
      }
   }
   
   var image: Image {
      switch self {
      case .withdraw:
         return Image(systemName: "dollarsign")
      case .swap:
         return Image(systemName: "rectangle.2.swap")
      case .recharge:
         return Image(systemName: "gobackward")
      case .electricity:
         return Image(systemName: "bolt")
      case .cableTV:
         return Image(systemName: "tv")
      }
   }
   
   var backgroundcolor: Color {
      switch self {
      case .withdraw:
         return Color.gray
      default:
         return Color.white
      }
   }
   
   var tint: Color {
      switch self {
      case .withdraw:
         return Color.red
      default:
         return Color.purple
      }
   }
   
   var stroke: Color {
      switch self {
      case .withdraw:
         return Color.red
      default:
         return Color.secondary
      }
   }
}

struct ElectricityBill {
   var name: String
   var number: String
   var planType: PlanType
   
   enum PlanType: String {
      case prepaid, postpaid
   }
}

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

struct ElectricityProvider {
   var name: String
}

extension ElectricityProvider: AnySearchableItem, Identifiable, Equatable {
   var id: String { UUID().uuidString }
   var itemName: String { name }
}

struct ElectricityPlan {
   var name: String
}

extension ElectricityPlan: AnySearchableItem, Identifiable, Equatable {
   var id: String { UUID().uuidString }
   var itemName: String { name }
}

struct noneSelectedItem {
    var name: String
}

extension noneSelectedItem: AnySearchableItem, Identifiable, Equatable {
    var id: String { UUID().uuidString }
    private(set) var itemName: String {
       get { name }
       set {}
    }
}
