//
//  ContentView.swift
//  QuantTradingSystem
//
//  Created by LJ J on 8/16/24.
//

// ContentView.swift
import SwiftUI

struct ContentView: View {
    @ObservedObject var appStartViewModel = AppStartViewModel()
    @State private var showLogoutAlert = false
    
    var body: some View {
        if appStartViewModel.isLoggedIn {
            VStack {
                TabView {
                    UserProfileView(viewModel: UserProfileViewModel(), userID: 1)
                        .tabItem {
                            Image(systemName: "person.crop.circle")
                            Text("Profile")
                        }
                    
                    MFAView(viewModel: MFAViewModel(), userID: 1)
                        .tabItem {
                            Image(systemName: "shield.fill")
                            Text("MFA")
                        }
                }
                
                Button(action: {
                    showLogoutAlert = true
                }) {
                    Text("Logout")
                        .padding()
                        .background(Color.red)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding()
                .alert(isPresented: $showLogoutAlert) {
                    Alert(
                        title: Text("Logout"),
                        message: Text("Are you sure you want to log out?"),
                        primaryButton: .destructive(Text("Logout")) {
                            appStartViewModel.logout()
                        },
                        secondaryButton: .cancel()
                    )
                }
            }
        } else {
            LoginView(viewModel: LoginViewModel())
        }
    }
}
