//
//  LoginViewModel.swift
//  QuantTradingSystem
//
//  Created by LJ J on 8/16/24.
//
// 登录视图模型
import Foundation
import Combine

class LoginViewModel: ObservableObject {
    @Published var username: String = ""
    @Published var password: String = ""
    @Published var errorMessage: String?
    @Published var token: String?
    @Published var isLoading: Bool = false
    @Published var isLoggedIn: Bool = false
    
    private let networkService: NetworkService
       
       init(networkService: NetworkService = .shared) {
           self.networkService = networkService
       }
    
    private var cancellables = Set<AnyCancellable>()
    
    func login() {
        guard let url = URL(string: "https://yourapi.com/api/v1/users/login") else {
            self.errorMessage = "Invalid URL"
            return
        }
        
        let body: [String: Any] = [
            "username": username,
            "password": password
        ]
        
        isLoading = true
        NetworkService.shared.sendRequest(url: url, method: "POST", body: body, responseType: [String: String].self)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                self.isLoading = false
                switch completion {
                case .failure(let error):
                    self.handleLoginError(error)
                case .finished:
                    break
                }
            }, receiveValue: { response in
                self.token = response["token"]
                self.isLoggedIn = true
                UserDefaults.standard.set(self.token, forKey: "userToken")
            })
            .store(in: &cancellables)
    }
    
    private func handleLoginError(_ error: Error) {
        if (error as? URLError)?.code == .timedOut {
            self.errorMessage = "Request timed out. Please try again."
        } else if let urlError = error as? URLError {
            self.errorMessage = "Failed to login: \(urlError.localizedDescription)"
        } else {
            self.errorMessage = "Failed to login: \(error.localizedDescription)"
        }
    }
}
