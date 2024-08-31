//
//  UserDefaultsHelper.swift
//  QuantTradingSystem
//
//  Created by LJ J on 8/31/24.
//

import Foundation

class UserDefaultsHelper {
    
    private let themeKey = "userThemePreference"
    
    func saveThemePreference(isDarkMode: Bool) {
        UserDefaults.standard.set(isDarkMode, forKey: themeKey)
    }
    
    func loadThemePreference() -> Bool {
        return UserDefaults.standard.bool(forKey: themeKey)
    }
}
