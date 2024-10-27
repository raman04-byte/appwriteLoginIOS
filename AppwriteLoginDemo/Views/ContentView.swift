//
//  ContentView.swift
//  AppwriteLoginDemo
//
//  Created by Raman Tank on 09/10/24.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var viewModel = ViewModel()
    let appwrite = Appwrite()
    let register = "Register"
    let login = "Login"
    @State private var commonText = "Hello"
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var isLoginSuccessful = false
    var body: some View {
        NavigationView{
            ZStack{
                Color(.black)
                VStack {
                    TextField(
                        "Email",
                        text: $viewModel.email,
                        prompt: Text("Enter Email")
                    )
                    .padding()
                    
                    SecureField(
                        "Enter Password",
                        text: $viewModel.password,
                        prompt: Text("Enter Password")
                    )
                    .padding()
                    
                    Button(
                        action: {
                            Task {
                                if viewModel.email.isEmpty || viewModel.password.isEmpty {
                                    alertMessage = "Please enter both email and password."
                                    showAlert = true
                                }
                                else {
                                    let value = await appwrite.onRegister(viewModel.email, viewModel.password)
                                    if value {
                                        commonText = register
                                        isLoginSuccessful = true
                                        
                                    }else {
                                        alertMessage = "Invalid credentials."
                                        showAlert = true
                                    }
                                }
                                
                            }
                        },
                        label: {
                            Text(register)
                        }
                    ).alert(isPresented: $showAlert) {
                        Alert(title: Text("Incomplete Information"),
                              message: Text(alertMessage),
                              dismissButton: .default(Text("OK")))
                    }
                    
                    Button(
                        action: {
                            Task {
                                if viewModel.email.isEmpty || viewModel.password.isEmpty {
                                    alertMessage = "Please enter both email and password."
                                    showAlert = true
                                } else {
                                    let value = await appwrite.onLogin(viewModel.email, viewModel.password)
                                    if value {
                                        commonText = login
                                        isLoginSuccessful = true
                                        
                                    }else {
                                        alertMessage = "Invalid credentials."
                                        showAlert = true
                                    }
                                    
                                }
                            }
                        },
                        label: {
                            Text("Login")
                        }
                    )
                    .alert(isPresented: $showAlert) {
                        Alert(title: Text("Incomplete Information"),
                              message: Text(alertMessage),
                              dismissButton: .default(Text("OK")))
                    }
                    NavigationLink(
                        destination: SecondDisplay(text: commonText),
                        isActive: $isLoginSuccessful,
                        label: {
                            EmptyView()
                        }
                    )
                    
                }
                .padding()
            }.ignoresSafeArea()
        }
        
    }
    
}

#Preview {
    ContentView()
}
