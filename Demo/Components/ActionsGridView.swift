//
//  SwiftUIView.swift
//  Demo
//
//  Created by MacBook on 4/25/24.
//

import SwiftUI

struct ActionsGridView: View {
    
    @ObservedObject var viewModel: PaymentViewModelImpl
    
    private let actions = Action.allCases
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                ForEach(actions, id: \.self) { action in
                    NavigationLink(value: action) {
                        ActionButtonView(action: action)
                    }
                }
            }
        }
    }
}

#Preview {
    ActionsGridView(viewModel: .init())
}
