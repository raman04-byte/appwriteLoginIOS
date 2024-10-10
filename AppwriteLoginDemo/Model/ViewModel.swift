//
//  ViewModel.swift
//  AppwriteLoginDemo
//
//  Created by Raman Tank on 09/10/24.
//

import Foundation

class ViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
}
