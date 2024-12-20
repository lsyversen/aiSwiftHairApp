//
//  ImagePicker.swift
//  hairapp
//
//  Created by Liam Syversen on 9/4/24.
//

import SwiftUI
import UIKit

struct ImagePicker: UIViewControllerRepresentable {
    @Binding var images: [UIImage]
    var maxSelection: Int // Maximum number of images to be selected
    var completion: () -> Void

    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        var parent: ImagePicker

        init(parent: ImagePicker) {
            self.parent = parent
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let uiImage = info[.originalImage] as? UIImage {
                if self.parent.images.count < self.parent.maxSelection { // Explicitly use 'self' for clarity
                    self.parent.images.append(uiImage)
                }

                // If the user has selected the maximum number of images, dismiss the picker
                if self.parent.images.count == self.parent.maxSelection {
                    picker.dismiss(animated: true) {
                        self.parent.completion() // Call completion after dismissal
                    }
                } else {
                    // Keep the picker open if more images need to be selected
                    picker.dismiss(animated: false) {
                        // Re-present the picker so the user can select more images
                        DispatchQueue.main.async {
                            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                               let window = windowScene.windows.first {
                                window.rootViewController?.present(picker, animated: true)
                            }
                        }
                    }
                }
            }
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            picker.dismiss(animated: true)
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.allowsEditing = false
        picker.sourceType = .photoLibrary
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
}




