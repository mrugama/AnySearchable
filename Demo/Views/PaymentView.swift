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

struct KeyModel: Identifiable {
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

final class PaymentViewModel: ObservableObject {
    
    @Published var displayedAmount: String = ""
    private var isPunctuationActived: Bool = false
    
    var keys: [KeyModel] = [
        KeyModel(action: .numeric(1)),
        KeyModel(action: .numeric(2)),
        KeyModel(action: .numeric(3)),
        KeyModel(action: .numeric(4)),
        KeyModel(action: .numeric(5)),
        KeyModel(action: .numeric(6)),
        KeyModel(action: .numeric(7)),
        KeyModel(action: .numeric(8)),
        KeyModel(action: .numeric(9)),
        KeyModel(action: .decimal),
        KeyModel(action: .numeric(0)),
        KeyModel(action: .delete)
    ]
    
    let columnSpec = [GridItem(.adaptive(minimum: 100))]
    let rowSpec = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    func performAction(_ action: ActionKey) {
        switch action {
        case .numeric(let num):
            displayedAmount.append(String(num))
        case .decimal:
            if isPunctuationActived { return }
            if displayedAmount.isEmpty {
                displayedAmount.append("0.")
            } else {
                displayedAmount.append(".")
            }
            isPunctuationActived.toggle()
        case .delete:
            let lastDigit = displayedAmount.removeLast()
            if lastDigit == "." {
                isPunctuationActived = false
            }
        }
    }
}

struct PaymentView: View {
    @ObservedObject var viewModel = PaymentViewModel()
    var body: some View {
        ZStack(alignment: .bottom) {
            VStack {
                displayAmountView
                KeyPadView(
                    columnSpec: viewModel.columnSpec,
                    rowSpec: viewModel.rowSpec,
                    keys: viewModel.keys
                ) { action in
                    viewModel.performAction(action)
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
                Text(viewModel.displayedAmount.isEmpty ? "0.00" : viewModel.displayedAmount)
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
    let keys: [KeyModel]
    var action: (ActionKey) -> ()
    var body: some View {
        LazyVGrid(columns: columnSpec, spacing: 12) {
            ForEach(keys) { key in
                Button(action: {
                    action(key())
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
