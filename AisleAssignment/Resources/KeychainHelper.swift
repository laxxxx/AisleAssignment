//
//  KeychainHelper.swift
//  AisleAssignment
//
//  Created by Sree Lakshman on 06/11/24.
//

import Foundation
import Security

class KeychainHelper {
    
    static let shared = KeychainHelper()
    
    private init() {}
    
    func saveToken(_ token: String, key: String = "auth_token") {
        // Convert the token to Data
        guard let data = token.data(using: .utf8) else { return }
        
        // Create a query to store the data
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecValueData as String: data
        ]
        
        // Delete any existing item if present
        SecItemDelete(query as CFDictionary)
        
        // Add the new item to the Keychain
        let status = SecItemAdd(query as CFDictionary, nil)
        
        if status != errSecSuccess {
            print("Failed to save token: \(status)")
        } else {
            print("Token saved successfully")
        }
    }
    
    func getToken(key: String = "auth_token") -> String? {
        // Create a query to retrieve the data
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        
        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        
        if status == errSecSuccess, let data = result as? Data {
            let token = String(data: data, encoding: .utf8)
            print("Token retrieved from Keychain: \(token ?? "nil")")
            return token
        } else {
            print("Failed to retrieve token with status: \(status)")
            return nil
        }
    }
    
    func deleteToken(key: String = "auth_token") {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key
        ]
        
        let status = SecItemDelete(query as CFDictionary)
        if status == errSecSuccess {
            print("Token deleted successfully")
        } else {
            print("Failed to delete token with status: \(status)")  // Log the deletion status code
        }
    }
}
