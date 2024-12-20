//
//  DailyUploadView.swift
//  hairapp
//
//  Created by Liam Syversen on 9/6/24.
//

import SwiftUI
import CoreData

struct DailyUploadView: View {
    @State private var selectedImages: [UIImage] = [] // Change to array
    @State private var showingImagePicker = false
    @State private var navigateToSelfieView = false
    @State private var isShowingActionSheet = false
    @Environment(\.presentationMode) var presentationMode // Used to dismiss and navigate back
    @EnvironmentObject var scanViewModel: ScanViewModel

    var body: some View {
        VStack {
            // Custom Header
            HStack {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                    HapticManager.instance.impact(style: .heavy)
                }) {
                    Image(systemName: "xmark")
                        .resizable()
                        .frame(width: 24, height: 24)
                        .foregroundColor(.white)
                }
                Spacer()
                Text("Upload Progress Pic")
                    .font(.title2)
                    .bold()
                    .foregroundColor(.white)
                Spacer()
            }
            .padding()
            .background(StyleConstants.backgroundColor)

            Spacer()

            // Display the selected image or a placeholder
            if let selectedImage = selectedImages.first {
                Image(uiImage: selectedImage)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 300, height: 400)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .padding()
            } else {
                Image("sample")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 300, height: 400)
                    .clipShape(RoundedRectangle(cornerRadius: 30))
                    .padding()
            }

            Spacer()

            // Upload or Take Selfie Button
            Button(action: {
                isShowingActionSheet = true
                HapticManager.instance.impact(style: .heavy)
            }) {
                Text("Upload or take selfie")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(StyleConstants.buttonBackgroundColor)
                    .cornerRadius(30)
            }
            .padding(.horizontal)
            .padding(.bottom, 20)
            .actionSheet(isPresented: $isShowingActionSheet) {
                ActionSheet(title: Text("Choose an option"), buttons: [
                    .default(Text("Take a Selfie")) {
                        navigateToSelfieView = true
                        HapticManager.instance.impact(style: .heavy)
                    },
                    .default(Text("Upload from Camera Roll")) {
                        showingImagePicker = true
                        HapticManager.instance.impact(style: .heavy)
                    },
                    .cancel()
                ])
            }
            .sheet(isPresented: $showingImagePicker) {
                ImagePicker(images: $selectedImages, maxSelection: 1) {
                    if selectedImages.count == 1 {
                        saveAndDismiss() // Save the image and navigate back
                    }
                }
            }
            .fullScreenCover(isPresented: $navigateToSelfieView) {
                SelfieView(capturedImages: $selectedImages, onComplete: {
                    if selectedImages.count == 1 {
                        saveAndDismiss() // Save the image and navigate back
                    }
                })
            }

            Spacer()
        }
        .background(StyleConstants.backgroundColor.edgesIgnoringSafeArea(.all))
        .navigationBarHidden(true)
    }

    // Function to save the uploaded image and navigate back to DailyUpdateView
    private func saveAndDismiss() {
        if let selectedImage = selectedImages.first {
            scanViewModel.saveProgressPic(image: selectedImage)
            presentationMode.wrappedValue.dismiss() // Dismiss the view and navigate back
        }
    }
}

#Preview {
    DailyUploadView()
        .environmentObject(ScanViewModel())
}

