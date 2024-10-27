//
//  Imagepick.swift
//  AppwriteLoginDemo
//
//  Created by Raman Tank on 25/10/24.
//

import SwiftUI
import UIKit

struct ImagePick: View {
    
    let userID: String
    
    @State private var selectedImage: UIImage? = nil
    @State private var isImagePickerPresented: Bool = false
    @State private var sourceType: UIImagePickerController.SourceType = .photoLibrary
    var appwrite = Appwrite()
    @State private var showPopup = false
    @State private var navigateToShowImage = false
    
    var body: some View {
        
        NavigationView {
            VStack {
                
                if let selectedImage = selectedImage {
                    Image (uiImage: selectedImage).resizable()
                        .scaledToFit()
                        .cornerRadius(20)
                        .padding()
                }
                else{
                    AsyncImage(url: URL(string: "https://images.pexels.com/photos/7218497/pexels-photo-7218497.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2")) { image in
                        image.resizable()
                    } placeholder: {
                        ProgressView().foregroundColor(.blue)
                    }.cornerRadius(20)
                }
                HStack {
                    Button(action: {
                        showImagePickerOptions()
                        
                    }){
                        Text("Pick").padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    
                    Button(action: {
                        
                        Task {
                            if let imagePath = await saveImageToTemporaryDirectory(image: selectedImage) {
                                print("Image saved at: \(imagePath)")
                                let success = await appwrite.updateFile(imagePath, userID)
                                if success {
                                    print("File updated successfully.")
                                    showPopup=true
                                } else {
                                    print("Failed to update file.")
                                }
                            }
                        }
                    }){
                        Text("Send Image").padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }.alert(isPresented: $showPopup){
                        Alert(title: Text("Success"), message: Text("Image uploaded successfully."),dismissButton: .default(Text("OK"),action: {
                            navigateToShowImage = true
                        }))
                    }
                    
                    
                    NavigationLink(destination: AppwriteImageShow(fileID: userID), isActive: $navigateToShowImage) {
                        EmptyView()
                    }
                    
                }
                
                
            }.sheet(isPresented: $isImagePickerPresented) {
                ImagePickerLogic.ImagePicker(sourceType: sourceType, selectedImage: $selectedImage)
            }
            .padding()
            
        }
        
    }
    
    func saveImageToTemporaryDirectory(image: UIImage?) async -> String? {
        guard let image = image else { return nil }
        
        // Create file path
        let fileName = "\(UUID().uuidString).jpg"
        let tempDir = FileManager.default.temporaryDirectory
        let fileURL = tempDir.appendingPathComponent(fileName)
        
        // Save image to file path
        if let imageData = image.jpegData(compressionQuality: 0.8) {
            do {
                try imageData.write(to: fileURL)
                return fileURL.path
            } catch {
                print("Error saving image: \(error)")
                return nil
            }
        }
        
        return nil
    }
    
    func showImagePickerOptions() {
        let alertVC = UIAlertController(title: "Pick a Photo", message: "Choose a photo from a camera or gallery", preferredStyle: .actionSheet)
        
        // From Camera
        let cameraAction = UIAlertAction(title: "Camera", style: .default) { _ in
            sourceType = .camera
            isImagePickerPresented = true
        }
        
        // For Library
        let libraryAction = UIAlertAction(title: "Library", style: .default) { _ in
            sourceType = .photoLibrary
            isImagePickerPresented = true
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertVC.addAction(cameraAction)
        alertVC.addAction(libraryAction)
        alertVC.addAction(cancelAction)
        
        if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = scene.windows.first,
           let rootViewController = window.rootViewController {
            rootViewController.present(alertVC, animated: true, completion: nil)
        }
    }
    
}

#Preview {
    ImagePick(
        userID: ""
    )
}
