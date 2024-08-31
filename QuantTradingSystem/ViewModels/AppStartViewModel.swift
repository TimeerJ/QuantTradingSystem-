//
//  AppStartViewModel.swift
//  QuantTradingSystem
//
//  Created by LJ J on 8/24/24.
//

import Foundation
import Combine

class AppStartViewModel: ObservableObject {
    @Published var isLoggedIn: Bool = false
    @Published var errorMessage: String?
    
    private var cancellables = Set<AnyCancellable>()
    
    func checkSession() {
        if let token = UserDefaults.standard.string(forKey: "userToken") {
            // 验证 JWT 令牌是否有效，可以通过解析 JWT 或向服务器发送验证请求
            // 这里假设验证是通过的
            isLoggedIn = true
        } else {
            isLoggedIn = false
        }
    }
    
    func logout() {
        UserDefaults.standard.removeObject(forKey: "userToken")
        isLoggedIn = false
    }
}
