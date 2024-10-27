//
//  AppwriteImageShow.swift
//  AppwriteLoginDemo
//
//  Created by Raman Tank on 27/10/24.
//

import SwiftUI

struct AppwriteImageShow: View {
    let fileID: String
    @StateObject private var viewModel = AppwriteImageShowViewModel()

    var body: some View {
        VStack {
            if let imageData = viewModel.imageData, let uiImage = UIImage(data: imageData) {
                Image(uiImage: uiImage).resizable().scaledToFit()
            } else if viewModel.isLoading {
                ProgressView("Loading...")
            } else {
                Text("Failed to load image").foregroundColor(.red)
            }
        }
        .navigationBarBackButtonHidden(true)
        .onAppear {
            Task {
                await viewModel.fetchImage(fileID: fileID)
            }
        }
    }
}

@MainActor
class AppwriteImageShowViewModel: ObservableObject {
    @Published var imageData: Data? = nil
    @Published var isLoading: Bool = false
    private let appwrite = Appwrite()
    
    func fetchImage(fileID: String) async {
        isLoading = true
        if let data = await appwrite.getFilePreview(fileID) {
            imageData = data
        }
        isLoading = false
    }
}

#Preview {
    AppwriteImageShow(fileID: "")
}
