//
//  UploadViewTwo.swift
//  hair-app
//
//  Created by Liam Syversen on 9/1/24.
//
 
import SwiftUI
import PhotosUI

struct UploadViewTwo: View {
    @State private var selectedImages: [UIImage] = []
    @State private var selectedPhotoItems: [PhotosPickerItem] = []
    @State private var personOneName: String = ""
    @State private var personTwoName: String = ""
    @State private var personOneChecked: Bool = false
    @State private var personTwoChecked: Bool = false
    @State private var showingImagePicker = false
    @State private var navigateToSelfieView = false
    @State private var isShowingActionSheet = false
    @State private var showLoadingView = false
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var scanViewModel: ScanViewModel
    @Binding var shouldNavigateToMain: Bool
    @Binding var selectedTab: Int
    @State private var keyboardOffset: CGFloat = 0 // State for keyboard offset
    @State private var selectedGender: String = UserDefaults.standard.string(forKey: "selectedGender") ?? "Unspecified"
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
                    // Header
                    HStack {
                        Button(action: {
                            presentationMode.wrappedValue.dismiss()
                            HapticManager.instance.impact(style: .heavy)
                        }) {
                            Image(systemName: "chevron.left")
                                .resizable()
                                .frame(width: 12, height: 24)
                                .foregroundColor(.white)
                        }
                        Spacer()
                        Text("Who Has Better Hair?")
                            .font(.title2)
                            .bold()
                            .foregroundColor(.white)
                        Spacer()
                        Image(systemName: "chevron.left")
                            .resizable()
                            .frame(width: 12, height: 24)
                            .foregroundColor(.clear)
                    }
                    .padding()
                    .background(StyleConstants.backgroundColor)

                    // Input fields with checkboxes
                    VStack(spacing: 20) {
                        InputItemView(name: $personOneName, isChecked: $personOneChecked, placeholder: "Enter first person's name")
                        InputItemView(name: $personTwoName, isChecked: $personTwoChecked, placeholder: "Enter second person's name")
                    }
                    .padding(.top, 10)

                    // Display the image selection 
                    if selectedImages.isEmpty {
                        Image("sample")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 325, height: 400)
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                            .padding()
                    } else {
                        HStack {
                            ForEach(selectedImages, id: \.self) { image in
                                Image(uiImage: image)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 150, height: 200)
                                    .clipShape(RoundedRectangle(cornerRadius: 30))
                            }
                        }
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
                                showingImagePicker = true // Show PhotosPicker
                                HapticManager.instance.impact(style: .heavy)
                            },
                            .cancel()
                        ])
                    }
                    .photosPicker(
                        isPresented: $showingImagePicker,
                        selection: $selectedPhotoItems,
                        maxSelectionCount: 2,
                        matching: .images
                    )
                    .onChange(of: selectedPhotoItems) {
                        loadSelectedPhotos(items: selectedPhotoItems)
                    }
                    .fullScreenCover(isPresented: $navigateToSelfieView) {
                        SelfieView(capturedImages: $selectedImages, onComplete: {
                            if selectedImages.count == 2 {
                                showLoadingView = true
                            }
                        })
                    }

                    Spacer()
                }
                .padding(.bottom, keyboardOffset) // Adjust for keyboard
            }
            .background(StyleConstants.backgroundColor.edgesIgnoringSafeArea(.all))
            .navigationBarHidden(true)
            .onAppear(perform: subscribeToKeyboardEvents) // Subscribe to keyboard events
            .onDisappear(perform: unsubscribeFromKeyboardEvents)
            .navigationDestination(isPresented: $showLoadingView) {
                ScanLoadingViewThree(uploadedImages: selectedImages, personOneName: personOneName, personTwoName: personTwoName, selectedTab: $selectedTab)
                    .environmentObject(scanViewModel)
            }
        }
    }

    // Load the selected photos from PhotosPicker
    private func loadSelectedPhotos(items: [PhotosPickerItem]) {
        Task {
            var images: [UIImage] = []
            for item in items {
                if let data = try? await item.loadTransferable(type: Data.self),
                   let uiImage = UIImage(data: data) {
                    images.append(uiImage)
                }
            }
            selectedImages = images
            if selectedImages.count == 2 {
                showLoadingView = true
            }
        }
    }

    // Subscribe to keyboard show/hide events
    private func subscribeToKeyboardEvents() {
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: .main) { notification in
            if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
                withAnimation {
                    self.keyboardOffset = keyboardFrame.height * 0.3
                }
            }
        }

        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: .main) { _ in
            withAnimation {
                self.keyboardOffset = 0
            }
        }
    }

    // Unsubscribe from keyboard events when view disappears
    private func unsubscribeFromKeyboardEvents() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
}



// Custom view for input fields with checkboxes
struct InputItemView: View {
    @Binding var name: String
    @Binding var isChecked: Bool
    var placeholder: String

    var body: some View {
        HStack {
            TextField(placeholder, text: $name)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .background(isChecked ? .green : .white)
                .cornerRadius(30)

            Button(action: {
                isChecked.toggle()
            }) {
                Image(systemName: isChecked ? "checkmark.circle.fill" : "circle")
                    .resizable()
                    .frame(width: 34, height: 34)
                    .foregroundColor(isChecked ? .black : .gray)
            }
        }
        .background(isChecked ? .green : .white)
        .cornerRadius(30)
        .padding(.horizontal)
    }
}

struct UploadViewTwo_Preview: PreviewProvider {
    static var previews: some View {
        // Mock environment object and bindings
        let scanViewModel = ScanViewModel()
        
        UploadViewTwo(
            shouldNavigateToMain: .constant(false),
            selectedTab: .constant(0)
        )
        .environmentObject(scanViewModel) // Mock environment object
        .previewLayout(.device)
        .previewDevice("iPhone 13")
    }
}





