//
//  MFAView.swift
//  QuantTradingSystem
//
//  Created by LJ J on 8/25/24.
//

import SwiftUI

struct MFAView: View {
    @ObservedObject var viewModel: MFAViewModel
    @Binding var userID: Int
    
    var body: some View {
        VStack {
            TextField("Enter MFA Code", text: $viewModel.mfaCode)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            if let errorMessage = viewModel.errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
            }
            
            Button(action: {
                viewModel.verifyMFA(userID: userID)
            }) {
                Text("Verify")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding()
        }
        .padding()
    }
}
