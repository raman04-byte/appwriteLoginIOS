//
//  Appwrite.swift
//  AppwriteLoginDemo
//
//  Created by Raman Tank on 09/10/24.
//

import Foundation
import Appwrite
import JSONCodable
import NIOCore

class Appwrite {
    var client: Client
    var account: Account
    var storage: Storage
    
    public init() {
        self.client = Client()
            .setEndpoint("https://cloud.appwrite.io/v1")
            .setProject("671a8dff001c5c9b137b")
        
        self.account = Account(client)
        self.storage = Storage(client)
    }
    
    public func onRegister(
        _ email: String,
        _ password: String
    ) async -> Bool {
        do {
            
            print("This is your \(email)")
            
            _ = try await account.create(
                userId: ID.unique(),
                email: email,
                password: password
            )
            let checkForLogin = await onLogin(email, password)
            if(checkForLogin)
            {
                return true
            }
            print("Check for login failed")
            return false // Return true if registration is successful
        } catch let error as AppwriteError {
            print("Registration failed with Appwrite error: \(error.message)")
            return false
        }
        catch {
            print("Registration failed with error: \(error)")
            return false // Return false if registration fails
        }
    }
    
    public func onLogin(
        _ email: String,
        _ password: String
    ) async -> Bool {
        do {
            
            try await account.deleteSessions()
            
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
    
    
    
    public func loadUser() async -> String{
        do {
            let user = try await account.get()
            return user.email
        } catch {
            print("Error: \(error)")
            return "Error"
        }
    }
    
    public func createFile(
        _ filePath: String,
        _ fileID: String
    ) async -> Bool {
        do {
            let _ = try await storage.createFile(bucketId: "DEMO", fileId: fileID, file: InputFile.fromPath(filePath))
            return true
        } catch {
            print("Creating file failed with error: \(error)")
            return false
        }
    }
    
    public func deleteFile(
        _ fileID: String
    ) async -> Bool {
        do{
            _ = try await storage.deleteFile(bucketId: "DEMO", fileId: fileID)
            return true
        }
        catch {
            print("Update file failed with error: \(error)")
            return false
        }
    }
    
    public func checkFileExists(_ fileID: String) async -> Bool {
            do {
                let _ = try await storage.getFile(bucketId: "DEMO", fileId: fileID)
                return true // File exists
            } catch {
                return false // File does not exist
            }
        }
        
        public func updateFile(_ filePath: String, _ fileID: String) async -> Bool {
            // Check if file exists
            let fileExists = await checkFileExists(fileID)
            
            // Delete the file if it exists
            if fileExists {
                let deleted = await deleteFile(fileID)
                if !deleted {
                    print("Failed to delete the existing file.")
                    return false
                }
            }
            
            // Create the new file
            let created = await createFile(filePath, fileID)
            if created {
                print("File created successfully.")
                return true
            } else {
                print("Failed to create the file.")
                return false
            }
        }
    
    public func getFilePreview(
        _ fileID: String
    ) async -> Data? {
        do {
            let filePreview = try await storage.getFilePreview(bucketId: "DEMO", fileId: fileID)
        
            var byteBuffer = filePreview
            
            let data = byteBuffer.readData(length: byteBuffer.readableBytes)
                return data
            
        } catch {
            print("Error getting file preview: \(error)")
            return nil
        }
    }
    
    public func onLogout() async throws {
        _ = try await account.deleteSession(
            sessionId: "current"
        )
    }
}
