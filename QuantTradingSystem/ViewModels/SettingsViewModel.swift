//
//  SettingsViewModel.swift
//  QuantTradingSystem
//
//  Created by LJ J on 8/31/24.
//

import Foundation

class SettingsViewModel: ObservableObject {
    @Published var isDarkMode: Bool = false
    
    private let userDefaultsHelper = UserDefaultsHelper()
    
    func saveThemePreference() {
        userDefaultsHelper.saveThemePreference(isDarkMode: isDarkMode)
    }
    
    func loadThemePreference() {
        isDarkMode = userDefaultsHelper.loadThemePreference()
    }
}
