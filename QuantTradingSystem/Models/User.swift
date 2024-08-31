
//
//  User.swift
//  QuantTradingSystem
//
//  Created by LJ J on 8/16/24.
//

// 用户数据模型
//

import SwiftData

@Model
class User {
    @Attribute(.unique) var username: String
    var email: String
    
    init(username: String, email: String) {
        self.username = username
        self.email = email
    }
}
