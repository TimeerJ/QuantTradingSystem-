//
//  MFAViewModel.swift
//  QuantTradingSystem
//
//  Created by LJ J on 8/24/24.
//

import Foundation
import Combine

class MFAViewModel: ObservableObject {
    @Published var mfaCode: String = ""
    @Published var errorMessage: String?
    @Published var isVerified: Bool = false
    
    private var cancellables = Set<AnyCancellable>()
    
    func verifyMFA(userID: Int) {
        guard let url = URL(string: "https://yourapi.com/api/v1/users/mfa/verify") else {
            self.errorMessage = "Invalid URL"
            return
        }
        
        let body: [String: Any] = [
            "user_id": userID,
            "mfa_code": mfaCode
        ]
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        
        URLSession.shared.dataTaskPublisher(for: request)
            .map { $0.data }
            .decode(type: Bool.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    self.errorMessage = "Failed to verify MFA: \(error.localizedDescription)"
                case .finished:
                    break
                }
            }, receiveValue: { isVerified in
                self.isVerified = isVerified
                self.errorMessage = isVerified ? nil : "Invalid MFA code."
            })
            .store(in: &cancellables)
    }
}
