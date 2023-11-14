//
//  TokenManger.swift
//  TODORI
//
//  Created by Dasol on 2023/05/17.
//

import KeychainAccess

class TokenManager {
    static let shared = TokenManager()
    
    private let keychain: Keychain
    
    private init() {
        keychain = Keychain(service: "lotus")
    }
    
    func saveToken(_ token: String) {
        do {
            try keychain.set(token, key: "authToken")
            print("토큰 저장 완료 : \(token)")
        } catch {
            print("Failed to save token to Keychain: \(error)")
        }
    }
    
    func getToken() -> String? {
        do {
            return try keychain.get("authToken")
        } catch {
            print("Failed to retrieve token from Keychain: \(error)")
            return nil
        }
    }
    
    func deleteToken() {
        do {
            try keychain.remove("authToken")
        } catch {
            print("Failed to delete token from Keychain: \(error)")
        }
    }
}
