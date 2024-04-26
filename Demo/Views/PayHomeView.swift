//
//  PayHomeView.swift
//  Demo
//
//  Created by MacBook on 4/25/24.
//

import SwiftUI

struct PayHomeView: View {
    
    @StateObject var viewModel = PaymentViewModelImpl()
    
    var body: some View {
        // MARK: - Transactions
        NavigationStack {
            VStack {
                
                ZStack(alignment: .top) {
                    Rectangle()
                        .fill(Gradient(colors: [Color.purple, Color.red]))
                        .ignoresSafeArea(edges: .top)
                        .frame(height: UIScreen.main.bounds.height * 0.3)
                    
                    VStack {
                        HStack {
                            Image(systemName: "paperplane.fill")
                            Spacer()
                            userInfoView
                        }
                        .padding([.top, .bottom, .trailing], 10)
                        
                        HStack {
                            Button {
                                
                            } label: {
                                ZStack {
                                    Capsule()
                                        .strokeBorder(lineWidth: 0.6)
                                        .background(Color.primary)
                                        .clipShape(Capsule())
                                    
                                    Label("Fund wallet", systemImage: "plus.circle")
                                        .bold()
                                        .font(.system(size: 14))
                                }
                            }
                            .frame(width: 140, height: 40)
                            .foregroundStyle(Color.yellow)
                            
                            Spacer()
                        }
                        .padding(.horizontal, 10)
                    }
                }
                
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: 20) {
                        
                        // MARK: - Actions
                        ActionsGridView(viewModel: self.viewModel)
                            .padding(.horizontal, 8)
                    }
                }
            }
            .navigationDestination(for: Action.self) { action in
                switch action {
                case .withdraw:
                    Text("Withdraw")
                case .swap:
                    Text("Swap")
                case .recharge:
                    Text("Recharge")
                case .electricity:
                    ElectricityBillView(viewModel: viewModel)
                case .cableTV:
                    Text("Cable TV")
                }
            }
        }
    }
    
    var userInfoView: some View {
        HStack {
            VStack(alignment: .trailing) {
                Text("Hi Babatunde")
                    .font(.system(size: 12))
                    .foregroundStyle(.white)
                
                Text("Good morning!")
                    .font(.system(size: 8))
                    .foregroundStyle(.white)
            }
            
            Image("person")
                .resizable()
                .scaledToFit()
                .frame(width: 40, height: 40)
        }
    }
}

#Preview {
    PayHomeView()
}
