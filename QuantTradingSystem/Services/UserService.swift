//
//  UserService.swift
//  QuantTradingSystem
//
//  Created by LJ J on 8/31/24.
//

import Foundation
import Combine

class UserService {
    static let shared = UserService()
    
    private init() {}

    // 登录功能
    func login(username: String, password: String) -> AnyPublisher<String, Error> {
        guard let url = URL(string: "https://yourapi.com/api/v1/users/login") else {
            return Fail(error: URLError(.badURL))
                .eraseToAnyPublisher()
        }
        
        let body: [String: Any] = [
            "username": username,
            "password": password
        ]
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        
        return URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { result -> String in
                guard let httpResponse = result.response as? HTTPURLResponse,
                      httpResponse.statusCode == 200 else {
                    throw URLError(.badServerResponse)
                }
                let responseDict = try JSONSerialization.jsonObject(with: result.data, options: []) as? [String: String]
                return responseDict?["token"] ?? ""
            }
            .eraseToAnyPublisher()
    }

    // 注册功能
    func register(username: String, email: String, password: String) -> AnyPublisher<Void, Error> {
        guard let url = URL(string: "https://yourapi.com/api/v1/users/register") else {
            return Fail(error: URLError(.badURL))
                .eraseToAnyPublisher()
        }
        
        let body: [String: Any] = [
            "username": username,
            "email": email,
            "password": password
        ]
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        
        return URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { result -> Void in
                guard let httpResponse = result.response as? HTTPURLResponse,
                      httpResponse.statusCode == 201 else {
                    throw URLError(.badServerResponse)
                }
                return
            }
            .eraseToAnyPublisher()
    }
}
