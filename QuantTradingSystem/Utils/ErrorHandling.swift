//
//  ErrorHandling.swift
//  QuantTradingSystem
//
//  Created by LJ J on 8/26/24.
//

import Foundation

enum AppError: Error, LocalizedError {
    case invalidURL
    case requestFailed(String)
    case unknownError
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .requestFailed(let reason):
            return "Request failed: \(reason)"
        case .unknownError:
            return "An unknown error occurred"
        }
    }
}

struct ErrorHandler {
    static func handle(error: Error) -> AppError {
        if let urlError = error as? URLError {
            return .requestFailed(urlError.localizedDescription)
        } else {
            return .unknownError
        }
    }
}
