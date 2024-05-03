//
//  PaymentView.swift
//  Demo
//
//  Created by Marlon Rugama on 5/1/24.
//

import SwiftUI

enum KeyAction: Equatable {
    case numeric(Int), decimal, delete
}

struct KeyModel: Identifiable {
    let id = UUID().uuidString
    let action: KeyAction
    var value: String {
        switch action {
        case .numeric(let num): String(num)
        case .decimal: "."
        case .delete: "delete.left"
        }
    }
    
    func callAsFunction() -> KeyAction { return action }
}

final class PaymentViewModel: ObservableObject {
    @Published var displayedAmount: String = ""
    private var amount: Double {
        Double(displayedAmount) ?? 0.00
    }
    private var isPunctuationActived: Bool = false
    
    var keys: [KeyModel] = [
        KeyModel(action: .numeric(1)), KeyModel(action: .numeric(2)),
        KeyModel(action: .numeric(3)), KeyModel(action: .numeric(4)),
        KeyModel(action: .numeric(5)), KeyModel(action: .numeric(6)),
        KeyModel(action: .numeric(7)), KeyModel(action: .numeric(8)),
        KeyModel(action: .numeric(9)), KeyModel(action: .decimal),
        KeyModel(action: .numeric(0)), KeyModel(action: .delete)
    ]
    
    let columnSpec = Array(repeating: GridItem(.flexible()), count: 3)
    
    func performAction(_ action: KeyAction) {
        switch action {
        case .numeric(let num):
            if let previousInput = displayedAmount.last,
                previousInput == "0" &&
                num == 0 &&
                !isPunctuationActived { return } // Early exit to prevent more than one zero
            displayedAmount.append(String(num))
        case .decimal:
            guard !isPunctuationActived else { return } // Early exit when punctuation is already activated
            
            if displayedAmount.isEmpty { displayedAmount.append("0.") }
            else { displayedAmount.append(".") }
            
            isPunctuationActived.toggle()
        case .delete:
            guard !displayedAmount.isEmpty else { return } // Early exit to prevent crash when remove empty
            let lastDigit = displayedAmount.removeLast()
            if lastDigit == "." { isPunctuationActived = false }
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
    let keys: [KeyModel]
    var action: (KeyAction) -> ()
    var body: some View {
        LazyVGrid(columns: columnSpec, spacing: 12) {
            ForEach(keys) { key in
                Button(action: {
                    action(key())
                }, label: {
                    if key.action == KeyAction.delete {
                        decorateKeyView(Image(systemName: key.value))
                    } else {
                        decorateKeyView(Text(key.value))
                    }
                })
            }
        }
    }
    
    private func decorateKeyView(_ view: some View) -> some View {
        view
            .frame(maxWidth: .infinity)
            .padding([.top, .bottom], 20)
            .background(.secondary.opacity(0.3))
            .fontWeight(.bold)
            .clipShape(RoundedRectangle(cornerSize: .init(width: 15.0, height: 5.0)))
    }
}

#Preview {
    PaymentView()
}
