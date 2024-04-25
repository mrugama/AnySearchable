//
//  PaymentViewModelImpl.swift
//  Demo
//
//  Created by MacBook on 4/25/24.
//

import Foundation
import SwiftUI

enum SelectedItem {
    case none(title: String), bill(item: any AnyItemSearchable), provider(item: any AnyItemSearchable), plan(item: any AnyItemSearchable)
}

final class PaymentViewModelImpl: IPaymentViewModel, ObservableObject {
    
    private let paymentRemote: IPaymentRemoteDatasource
    
    init(paymentRemote: IPaymentRemoteDatasource = PaymentRemoteDatasourceImpl()) {
        self.paymentRemote = paymentRemote
    }
    
    @Published var action: Action?
    @Published var selectedSavedElectricityBill: any AnyItemSearchable = noneSelectedItem(name: "Saved Bills")
    @Published var selectedElectricityProvider: any AnyItemSearchable = noneSelectedItem(name: "Select a provider")
    @Published var selectedElectricityPlan: any AnyItemSearchable = noneSelectedItem(name: "Select plan")
    @Published var savedElectricityBills: [ElectricityBill] = []
    @Published var electricityProviders: [ElectricityProvider] = []
    @Published var electricityPlans: [ElectricityPlan] = []
    
    func getSavedElectricityBills() {
        savedElectricityBills = [
            ElectricityBill(name: "AEDC", number: "7023658921", planType: .prepaid),
            ElectricityBill(name: "Jos Electricity", number: "7023658921", planType: .postpaid),
            ElectricityBill(name: "BEDC Electricity", number: "7023658921", planType: .prepaid),
            ElectricityBill(name: "IBEDC", number: "7023658921", planType: .prepaid),
            ElectricityBill(name: "KAEDCO", number: "7023658921", planType: .postpaid)
        ]
    }
    
    func getElectricityProviders() {
        electricityProviders = [
            ElectricityProvider(name: "AEDC Prepaid"),
            ElectricityProvider(name: "BEDC Prepaid"),
            ElectricityProvider(name: "ENUGU Prepaid"),
            ElectricityProvider(name: "Eko Electricity (Prepaid)"),
            ElectricityProvider(name: "IBEDC Prepaid"),
            ElectricityProvider(name: "IKEJA Electricity (Prepaid)"),
            ElectricityProvider(name: "Jos Electricity"),
            ElectricityProvider(name: "KAEDCO Prepaid"),
        ]
    }
    
    func getElectricityPlans() {
        electricityPlans = [
            ElectricityPlan(name: "Plan One"),
            ElectricityPlan(name: "Plan Two"),
            ElectricityPlan(name: "Plan Three"),
            ElectricityPlan(name: "Plan Four"),
            ElectricityPlan(name: "Plan Five"),
            ElectricityPlan(name: "Plan Six"),
            ElectricityPlan(name: "Plan Seven"),
            ElectricityPlan(name: "Plan Eight"),
        ]
    }
    
    func paymentActionNavLinks(selection: Binding<Action?>) -> some View {
        Group {
            NavigationLink(
                destination: Text("Withdraw"),
                tag: Action.withdraw,
                selection: selection,
                label: { EmptyView() }
            )
            
            NavigationLink(
                destination: Text("Swap"),
                tag: Action.swap,
                selection: selection,
                label: { EmptyView() }
            )
            
            NavigationLink(
                destination: Text("Recharge"),
                tag: Action.recharge,
                selection: selection,
                label: { EmptyView() }
            )
            
            NavigationLink(
                destination: ElectricityBillView(viewModel: self),
                tag: Action.electricity,
                selection: selection,
                label: { EmptyView() }
            )
            
            NavigationLink(
                destination: Text("Cable TV"),
                tag: Action.cableTV,
                selection: selection,
                label: { EmptyView() }
            )
        }
    }
}
