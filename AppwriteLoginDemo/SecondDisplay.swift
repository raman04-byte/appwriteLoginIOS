//
//  SecondDisplay.swift
//  AppwriteLoginDemo
//
//  Created by Raman Tank on 09/10/24.
//

import SwiftUI

struct SecondDisplay: View {
    let appwrite = Appwrite()
    @Environment(\.presentationMode) var presentationMode
    var text: String
    var body: some View {
        
        
        VStack{
            Text("\(text) successfully")
            Button(
                action: {
                    Task {
                        
                        do {
                            try await appwrite.onLogout()
                            presentationMode.wrappedValue.dismiss()  // Go back to previous view
                        } catch {
                            print("Failed to logout: \(error.localizedDescription)")
                        }
                    }
                },
                label: {
                    Text("Logout")
                }
            ).padding()
        }.navigationBarBackButtonHidden(true)
    }
}

#Preview {
    SecondDisplay(
        text: "Hello"
    )
}
