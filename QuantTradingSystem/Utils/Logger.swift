//
//  Logger.swift
//  QuantTradingSystem
//
//  Created by LJ J on 8/26/24.
//
import os.log

struct Logger {
    static func logInfo(_ message: String) {
        os_log("%@", log: OSLog.default, type: .info, message)
    }
    
    static func logError(_ message: String) {
        os_log("%@", log: OSLog.default, type: .error, message)
    }
    
    static func logDebug(_ message: String) {
        os_log("%@", log: OSLog.default, type: .debug, message)
    }
}
