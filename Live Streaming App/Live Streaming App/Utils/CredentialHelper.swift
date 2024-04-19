//
//  CredentialHelper.swift
//  Live Streaming App
//
//  Created by Sudayn on 18/4/2024.
//

import Foundation

class CredentialHelper {
    class func saveAccessToken(token: String) {
        let tokenData = token.data(using: .utf8)!
        
        // Define access control settings for the Keychain item
        let accessControl = SecAccessControlCreateWithFlags(nil, // Use default allocator
                                                            kSecAttrAccessibleWhenUnlocked,
                                                            .userPresence,
                                                            nil) // Ignore any error
        
        // Define query parameters for Keychain
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: "accessToken", // Unique identifier for the token
            kSecValueData as String: tokenData,
            kSecAttrAccessControl as String: accessControl as Any,
            kSecUseAuthenticationUI as String: kSecUseAuthenticationUIFail
        ]
        
        // Attempt to add or update the token in Keychain
        let status = SecItemAdd(query as CFDictionary, nil)
        if status != errSecSuccess {
            print("Error saving access token to Keychain: \(status)")
        }
    }
    
    // Function to retrieve an access token from Keychain
    class func retrieveAccessToken() -> String? {
        // Define query parameters for Keychain
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: "accessToken", // Unique identifier for the token
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        
        var tokenData: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &tokenData)
        
        if status == errSecSuccess {
            if let tokenData = tokenData as? Data, let token = String(data: tokenData, encoding: .utf8) {
                return token
            }
        } else {
            print("Error retrieving access token from Keychain")
        }
        
        return nil
    }
    
    class func clearAccessToken() {
        // Define query parameters to identify the token in Keychain
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: "accessToken" // Unique identifier for the token
        ]
        
        // Attempt to delete the token from Keychain
        let status = SecItemDelete(query as CFDictionary)
        if status != errSecSuccess {
            print("Error clearing access token from Keychain: \(status)")
        }
    }
}
