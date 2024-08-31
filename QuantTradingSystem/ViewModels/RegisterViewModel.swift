//
//  RegisterViewModel.swift
//  QuantTradingSystem
//
//  Created by LJ J on 8/16/24.
//

// 注册试图模型
import Foundation
import Combine

class RegisterViewModel: ObservableObject {
    @Published var username: String = ""
    @Published var password: String = ""
    @Published var email: String = ""
    @Published var errorMessage: String?
    @Published var isRegistering: Bool = false
    @Published var isRegistered: Bool = false
    
    private var cancellables = Set<AnyCancellable>()
    
    func register() {
        guard let url = URL(string: "https://yourapi.com/api/v1/users/register") else {
            self.errorMessage = "Invalid URL"
            return
        }

        let body: [String: Any] = [
            "username": username,
            "password": password,
            "email": email
        ]

        isRegistering = true
        NetworkService.shared.sendRequest(url: url, method: "POST", body: body, responseType: User.self)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                self.isRegistering = false
                switch completion {
                case .failure(let error):
                    self.errorMessage = "Failed to register: \(error.localizedDescription)"
                case .finished:
                    break
                }
            }, receiveValue: { user in
                self.isRegistered = true
                self.errorMessage = nil
                // 处理注册成功后的逻辑
            })
            .store(in: &cancellables)
    }
}
