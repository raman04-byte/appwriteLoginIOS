//
//  ImagePickerLogin.swift
//  AppwriteLoginDemo
//
//  Created by Raman Tank on 25/10/24.
//

import Foundation
import UIKit
import SwiftUI

class ImagePickerLogic {

    struct ImagePicker: UIViewControllerRepresentable {
        var sourceType: UIImagePickerController.SourceType
        @Binding var selectedImage: UIImage?
        
        func makeUIViewController(context: Context) -> UIImagePickerController {
            let imagePicker = UIImagePickerController()
            imagePicker.sourceType = sourceType
            imagePicker.allowsEditing = true
            imagePicker.delegate = context.coordinator
            return imagePicker
        }
        
        func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) { }
        
        func makeCoordinator() -> Coordinator {
            Coordinator(self)
        }
        
        class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
            let parent: ImagePicker
            
            init(_ parent: ImagePicker) {
                self.parent = parent
            }
            
            func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
                if let editedImage = info[.editedImage] as? UIImage {
                    parent.selectedImage = editedImage
                } else if let originalImage = info[.originalImage] as? UIImage {
                    parent.selectedImage = originalImage
                }
                
                picker.dismiss(animated: true, completion: nil)
            }
            
            func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
                picker.dismiss(animated: true, completion: nil)
            }
        }
    }
}
