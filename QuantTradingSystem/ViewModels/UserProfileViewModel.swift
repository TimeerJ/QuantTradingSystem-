//
//  UserProfileViewModel.swift
//  QuantTradingSystem
//
//  Created by LJ J on 8/25/24.
//  用户信息管理视图模型
import SwiftUI
import Combine
import SwiftData


class UserProfileViewModel: ObservableObject {
    @Published var username: String = ""
    @Published var email: String = ""
    @Published var errorMessage: String?
    
    @Environment(\.modelContext) private var modelContext
    
    // 加载用户配置文件
    func loadProfile() {
        let fetchDescriptor = FetchDescriptor<User>() // 正确传递 FetchDescriptor<User>
        let users = try? modelContext.fetch(fetchDescriptor)
        if let user = users?.first {
            self.username = user.username
            self.email = user.email
        } else {
            self.errorMessage = "User not found"
        }
    }
    
    // 更新用户配置文件
    func updateUserProfile(username: String, email: String) {
        let fetchDescriptor = FetchDescriptor<User>()
        let users = try? modelContext.fetch(fetchDescriptor)
        if let user = users?.first {
            user.username = username
            user.email = email
            try? modelContext.save()
        } else {
            let newUser = User(username: username, email: email)
            modelContext.insert(newUser)
            try? modelContext.save()
        }
    }
    
    // 删除用户配置文件
    func deleteUserProfile() {
        let fetchDescriptor = FetchDescriptor<User>()
        let users = try? modelContext.fetch(fetchDescriptor)
        if let user = users?.first {
            modelContext.delete(user)
            try? modelContext.save()
            self.username = ""
            self.email = ""
        } else {
            self.errorMessage = "User not found"
        }
    }
}
