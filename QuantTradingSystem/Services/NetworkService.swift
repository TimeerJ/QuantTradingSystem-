//
//  NetworkService.swift
//  QuantTradingSystem
//
//  Created by LJ J on 8/25/24.
//

import Foundation
import Combine

class NetworkService {
    static let shared = NetworkService()
    
    private init() {}
    
    func sendRequest<T: Decodable>(url: URL, method: String, body: [String: Any]?, responseType: T.Type, retries: Int = 3, timeout: TimeInterval = 10.0) -> AnyPublisher<T, Error> {
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.timeoutInterval = timeout
        
        if let body = body {
            request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        }
        
        return URLSession.shared.dataTaskPublisher(for: request)
            .retry(retries)
            .tryMap { output in
                guard let response = output.response as? HTTPURLResponse else {
                    throw URLError(.badServerResponse)
                }
                if !(200...299).contains(response.statusCode) {
                    throw URLError(.badServerResponse)
                }
                return output.data
            }
            .decode(type: responseType, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
}
