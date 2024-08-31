//
//  QuantTradingSystemApp.swift
//  QuantTradingSystem
//
//  Created by LJ J on 8/16/24.
//

import SwiftUI
import SwiftData

@main
struct QuantTradingSystemApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .modelContainer(for: User.self)
                .environmentObject(UserProfileViewModel())
        }
    }
}
