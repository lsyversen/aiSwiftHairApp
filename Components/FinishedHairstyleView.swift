//
//  FinishedHairstyleView.swift
//  hairapp
//
//  Created by Liam Syversen on 10/16/24.
// 

import SwiftUI

struct FinishedHairstyleView: View {
    let tryOnHairstyle: TryOnHairstyle
    @State private var showMenu = false // State to trigger the menu display
    @State private var showSaveNotification = false // State to show save confirmation

    var body: some View {
        ZStack {
            // Display the generated hairstyle image
            if let imageData = tryOnHairstyle.image, let image = UIImage(data: imageData) {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 300, height: 300)
                    .cornerRadius(10)
                    .overlay(
                        LinearGradient(gradient: Gradient(colors: [Color.clear, Color.black.opacity(0.7)]),
                                       startPoint: .center, endPoint: .bottom)
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 30))
                    .onTapGesture {
                        showMenu = true // Show the menu when the image is tapped
                    }
            }
            // Display the hairstyle name at the bottom
            VStack {
                Text(tryOnHairstyle.hairstyle?.capitalized ?? "Unknown Hairstyle")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .background(StyleConstants.backgroundColor.opacity(0.6))
                    .cornerRadius(30)
                    .padding(.top, 200)
                }
                .frame(width: 250)
        
        }
        .actionSheet(isPresented: $showMenu) {
            ActionSheet(
                title: Text("Save or share this hairstyle"),
                buttons: [
                    .default(Text("Save to Camera Roll")) {
                        saveToCameraRoll()
                    },
                    .default(Text("Share")) {
                        if let imageData = tryOnHairstyle.image, let image = UIImage(data: imageData) {
                            let activityController = UIActivityViewController(activityItems: [image], applicationActivities: nil)
                            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                               let rootViewController = windowScene.windows.first?.rootViewController {
                                rootViewController.present(activityController, animated: true, completion: nil)
                            }
                        }
                    },
                    .cancel()
                ]
            )
        }
        .shadow(radius: 5)
        .padding()
        .overlay(
            VStack {
                if showSaveNotification {
                    Text("Image saved to Camera Roll")
                        .padding()
                        .background(Color.green.opacity(0.8))
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .transition(.slide)
                        .padding(.top, 40)
                }
                Spacer()
            }
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    withAnimation {
                        showSaveNotification = false
                    }
                }
            }
        )
    }
    
    // Save image to camera roll
    private func saveToCameraRoll() {
        if let imageData = tryOnHairstyle.image, let image = UIImage(data: imageData) {
            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
            withAnimation {
                showSaveNotification = true
            }
        }
    }
}

#Preview {
    let context = PersistenceController.shared.container.viewContext
    
    // Creating a mock TryOnHairstyle object
    let mockTryOnHairstyle = TryOnHairstyle(context: context)
    mockTryOnHairstyle.hairstyle = "Curly Afro"
    mockTryOnHairstyle.image = UIImage(named: "hairstylesample")?.pngData() // Load the image from assets

    return FinishedHairstyleView(tryOnHairstyle: mockTryOnHairstyle)
        .environment(\.managedObjectContext, context)
}
