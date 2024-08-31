//
//  ChangeEmailView.swift
//  QuantTradingSystem
//
//  Created by LJ J on 8/26/24.
//

import SwiftUI

struct ChangeEmailView: View {
    @ObservedObject var viewModel: ChangeEmailViewModel
    
    var body: some View {
        VStack {
            TextField("New Email", text: $viewModel.newEmail)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            if let errorMessage = viewModel.errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
            }
            
            if let successMessage = viewModel.successMessage {
                Text(successMessage)
                    .foregroundColor(.green)
            }
            
            Button(action: {
                viewModel.changeEmail()
            }) {
                Text("Change Email")
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
