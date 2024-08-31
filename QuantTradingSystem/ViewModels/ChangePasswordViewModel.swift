//
//  ChangePasswordViewModel.swift
//  QuantTradingSystem
//
//  Created by LJ J on 8/26/24.
//

import Foundation
import Combine

class ChangePasswordViewModel: ObservableObject {
    @Published var currentPassword: String = ""
    @Published var newPassword: String = ""
    @Published var confirmPassword: String = ""
    @Published var errorMessage: String?
    @Published var successMessage: String?
    @Published var isChanging: Bool = false
    
    private var cancellables = Set<AnyCancellable>()
    
    func changePassword() {
        guard newPassword == confirmPassword else {
            errorMessage = "New passwords do not match."
            return
        }
        
        guard let url = URL(string: "https://yourapi.com/api/v1/users/change-password") else {
            self.errorMessage = "Invalid URL"
            return
        }
        
        let body: [String: Any] = [
            "current_password": currentPassword,
            "new_password": newPassword
        ]
        
        isChanging = true
        NetworkService.shared.sendRequest(url: url, method: "PUT", body: body, responseType: Bool.self)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                self.isChanging = false
                switch completion {
                case .failure(let error):
                    self.errorMessage = "Failed to change password: \(error.localizedDescription)"
                case .finished:
                    break
                }
            }, receiveValue: { success in
                if success {
                    self.successMessage = "Password changed successfully."
                    self.errorMessage = nil
                } else {
                    self.errorMessage = "Failed to change password."
                }
            })
            .store(in: &cancellables)
    }
}
