//
//  EncryptionHelper.swift
//  QuantTradingSystem
//
//  Created by LJ J on 8/31/24.
//

import CommonCrypto
import Foundation

class EncryptionHelper {
    static func encryptPassword(_ password: String) -> String? {
        guard let data = password.data(using: .utf8) else { return nil }
        var key = Data(count: kCCKeySizeAES128)
        let keyGenerationStatus = key.withUnsafeMutableBytes {
            SecRandomCopyBytes(kSecRandomDefault, kCCKeySizeAES128, $0.baseAddress!)
        }
        guard keyGenerationStatus == errSecSuccess else { return nil }
        
        var buffer = Data(count: data.count + kCCBlockSizeAES128)
        var numberOfBytesEncrypted = 0
        
        let cryptStatus = data.withUnsafeBytes { dataBytes in
            buffer.withUnsafeMutableBytes { bufferBytes in
                key.withUnsafeBytes { keyBytes in
                    CCCrypt(
                        CCOperation(kCCEncrypt),
                        CCAlgorithm(kCCAlgorithmAES128),
                        CCOptions(kCCOptionPKCS7Padding),
                        keyBytes.baseAddress,
                        key.count,
                        nil,
                        dataBytes.baseAddress,
                        data.count,
                        bufferBytes.baseAddress,
                        buffer.count,
                        &numberOfBytesEncrypted
                    )
                }
            }
        }
        
        guard cryptStatus == kCCSuccess else { return nil }
        
        buffer.removeSubrange(numberOfBytesEncrypted..<buffer.count)
        return buffer.base64EncodedString()
    }
}
