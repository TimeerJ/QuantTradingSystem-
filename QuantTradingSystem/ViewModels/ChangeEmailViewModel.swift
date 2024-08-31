//
//  ChangeEmailViewModel.swift
//  QuantTradingSystem
//
//  Created by LJ J on 8/26/24.
//

import Foundation

import Combine

class ChangeEmailViewModel: ObservableObject {
    @Published var newEmail: String = ""
    @Published var errorMessage: String?
    @Published var successMessage: String?
    @Published var isUpdating: Bool = false
    
    private var cancellables = Set<AnyCancellable>()
    
    func changeEmail() {
        guard let url = URL(string: "https://yourapi.com/api/v1/users/change-email") else {
            self.errorMessage = "Invalid URL"
            return
        }
        
        let body: [String: Any] = [
            "new_email": newEmail
        ]
        
        isUpdating = true
        NetworkService.shared.sendRequest(url: url, method: "PUT", body: body, responseType: Bool.self)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                self.isUpdating = false
                switch completion {
                case .failure(let error):
                    self.errorMessage = "Failed to change email: \(error.localizedDescription)"
                case .finished:
                    break
                }
            }, receiveValue: { success in
                if success {
                    self.successMessage = "Email changed successfully."
                    self.errorMessage = nil
                } else {
                    self.errorMessage = "Failed to change email."
                }
            })
            .store(in: &cancellables)
    }
}

