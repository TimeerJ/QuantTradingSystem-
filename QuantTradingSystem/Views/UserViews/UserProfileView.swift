//
//  UserProfileView.swift
//  QuantTradingSystem
//
//  Created by LJ J on 8/25/24.
//

import SwiftUI

struct UserProfileView: View {
    @ObservedObject var viewModel: UserProfileViewModel
    @State private var userID: Int
    
    init(viewModel: UserProfileViewModel, userID: Int) {
        self.viewModel = viewModel
        self._userID = State(initialValue: userID)
    }
    
    var body: some View {
        VStack {
            if viewModel.isLoading {
                ProgressView("Loading...")
                    .padding()
            } else {
                // 显示用户信息的表单
                TextField("Username", text: $viewModel.username)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                TextField("Email", text: $viewModel.email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                }
                
                Button(action: {
                    viewModel.updateProfile(userID: userID)
                }) {
                    Text("Update Profile")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding()
            }
        }
        .padding()
        .onAppear {
            viewModel.loadProfile(userID: userID)
        }
    }
}
