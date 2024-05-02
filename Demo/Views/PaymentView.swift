//
//  PaymentView.swift
//  Demo
//
//  Created by Marlon Rugama on 5/1/24.
//

import SwiftUI

enum ActionKey {
    case numeric(Int), decimal, delete
}

struct ActionKeyModel: Identifiable {
    let id = UUID().uuidString
    let action: ActionKey
    var value: String {
        switch action {
        case .numeric(let num):
            String(num)
        case .decimal:
            "."
        case .delete:
            "􀆛"
        }
    }
    
    func callAsFunction() -> ActionKey {
        return action
    }
}

final class PaymentViewModel: Observable {
    var keys: [ActionKeyModel] = [
        ActionKeyModel(action: .numeric(1)),
        ActionKeyModel(action: .numeric(2)),
        ActionKeyModel(action: .numeric(3)),
        ActionKeyModel(action: .numeric(4)),
        ActionKeyModel(action: .numeric(5)),
        ActionKeyModel(action: .numeric(6)),
        ActionKeyModel(action: .numeric(7)),
        ActionKeyModel(action: .numeric(8)),
        ActionKeyModel(action: .numeric(9)),
        ActionKeyModel(action: .decimal),
        ActionKeyModel(action: .numeric(0)),
        ActionKeyModel(action: .delete)
    ]
    
    let columnSpec = [GridItem(.adaptive(minimum: 100))]
    let rowSpec = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
}

struct PaymentView: View {
    let viewModel = PaymentViewModel()
    @State var amount: String = ""
    var body: some View {
        ZStack(alignment: .bottom) {
            VStack {
                displayAmountView
                KeyPadView(
                    columnSpec: viewModel.columnSpec,
                    rowSpec: viewModel.rowSpec,
                    keys: viewModel.keys
                ) { key in
                    switch key.action {
                    case .numeric(let num):
                        let input = String(num)
                        amount.append(input)
                    case .decimal:
                        amount.append(".")
                    case .delete:
                        amount.removeLast()
                    }
                }
            }
            .padding()
        }
    }
    
    var displayAmountView: some View {
        VStack {
            Text("Enter Amount")
                .font(.body)
            HStack(spacing: 12) {
                Text("US$")
                    .fontWeight(.bold)
                Text(amount.isEmpty ? "0.00":amount)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding()
            }
            Text("Deposit will be made from your naira account")
                .font(.caption)
        }
        .padding([.top, .bottom], 40)
    }
}

struct KeyPadView: View {
    let columnSpec: [GridItem]
    let rowSpec: [GridItem]
    let keys: [ActionKeyModel]
    var action: (ActionKeyModel) -> ()
    var body: some View {
        LazyVGrid(columns: columnSpec, spacing: 12) {
            ForEach(keys) { key in
                Button(action: {
                    action(key)
                }, label: {
                    Text(key.value)
                        .frame(maxWidth: .infinity)
                        .padding([.top, .bottom], 20)
                        .background(.secondary.opacity(0.3))
                        .foregroundColor(.blue)
                        .fontWeight(.bold)
                        .clipShape(RoundedRectangle(cornerSize: .init(width: 15.0, height: 5.0)))
                })
            }
        }
    }
}

#Preview {
    PaymentView()
}
