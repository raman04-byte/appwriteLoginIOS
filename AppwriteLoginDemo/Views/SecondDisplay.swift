//
//  SecondDisplay.swift
//  AppwriteLoginDemo
//
//  Created by Raman Tank on 09/10/24.
//

import SwiftUI

struct SecondDisplay: View {
    var appwrite = Appwrite()
    @State private var userEmail: String = "Loading..."
    @Environment(\.presentationMode) var presentationMode
    @State private var userID: String = ""
    
    func loadUserID() async throws {
        let findUserID = try await appwrite.account.get().id
        DispatchQueue.main.async {
            userID = findUserID
        }
    }
    
    var text: String
    var body: some View {
        NavigationView{
            VStack{
                Text("\(text) successfully")
                
                Text("User ID \(userID)").onAppear{
                    Task{
                      try await loadUserID()
                    }
                }
                
                Text("User email \(userEmail)").onAppear{
                    Task{
                        let email = await appwrite.loadUser()
                        DispatchQueue.main.async {
                            userEmail = email
                        }
                    }
                }
                NavigationLink(destination: ImagePick(
                    userID: userID
                )){
                    Text("Pick Image")
                }
                Button(
                    action: {
                        Task {
                            do {
                                try await appwrite.onLogout()
                                presentationMode.wrappedValue.dismiss()
                            } catch {
                                print("Failed to logout: \(error.localizedDescription)")
                            }
                        }
                    },
                    label: {
                        Text("Logout")
                    }
                ).padding()
            }
        }.navigationBarBackButtonHidden(true)
    }
}

#Preview {
    SecondDisplay(
        text: "Hello"
    )
}
