//
//  Appwrite.swift
//  AppwriteLoginDemo
//
//  Created by Raman Tank on 09/10/24.
//

import Foundation
import Appwrite
import JSONCodable

class Appwrite {
    var client: Client
    var account: Account
    
    public init() {
        self.client = Client()
            .setEndpoint("https://cloud.appwrite.io/v1")
            .setProject("6683c5940013e4df2251")
        
        self.account = Account(client)
    }
    
    // Modified onRegister method
    public func onRegister(
        _ email: String,
        _ password: String
    ) async -> Bool {
        do {
            let _ = try await account.create(
                userId: ID.unique(),
                email: email,
                password: password
            )
            return true // Return true if registration is successful
        } catch {
            print("Registration failed with error: \(error)")
            return false // Return false if registration fails
        }
    }
    
    // Modified onLogin method
    public func onLogin(
        _ email: String,
        _ password: String
    ) async -> Bool {
        do {
            let _ = try await account.createEmailPasswordSession(
                email: email,
                password: password
            )
            return true // Return true if login is successful
        } catch {
            print("Login failed with error: \(error)")
            return false // Return false if login fails
        }
    }
    
    public func onLogout() async throws {
        _ = try await account.deleteSession(
            sessionId: "current"
        )
    }
}
