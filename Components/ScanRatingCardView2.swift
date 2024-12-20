//
//  ScanRatingsCard2View.swift
//  hairapp
//
//  Created by Liam Syversen on 9/5/24.
//

import SwiftUI
import UIKit
import UniformTypeIdentifiers

// MARK: - UIImage Transferable Extension
extension UIImage: @retroactive Transferable {
    public static var transferRepresentation: some TransferRepresentation {
        DataRepresentation(exportedContentType: .png) { image in
            guard let data = image.pngData() else {
                throw NSError(domain: "ImageConversionError", code: -1, userInfo: nil)
            }
            return data
        }
    }
}

// MARK: - ScanRatingsCard2View
struct ScanRatingsCard2View: View {
    let metrics: [(name: String, emoji: String, result: String)]
    let image: UIImage
    @Binding var selectedTab: Int
    @Binding var shouldNavigateToMain: Bool
    @State private var shareImage: UIImage?
    @State private var showSaveNotification = false

    var body: some View {
        ZStack {
            VStack(spacing: 20) {
                HStack {
                    Button(action: {
                        selectedTab = 1
                        shouldNavigateToMain = true
                        HapticManager.instance.impact(style: .heavy)
                    }) {
                        Image(systemName: "xmark")
                            .resizable()
                            .frame(width: 24, height: 24)
                            .foregroundColor(.white)
                            .padding()
                            .clipShape(Circle())
                            .zIndex(1)
                    }
                    .padding(.top, 6)
                    Spacer()
                }
                .padding(.bottom, 66)
                
                ZStack {
                    VStack {
                        Spacer().frame(height: 80)
                        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 25) {
                            ForEach(metrics, id: \.name) { metric in
                                VStack(alignment: .center) {
                                    Text(metric.emoji)
                                        .font(.subheadline)
                                        .padding(.bottom, 5)
                                    Text(metric.name)
                                        .font(.callout)
                                        .bold()
                                        .foregroundColor(.white)
                                        .padding(.bottom, 2)
                                    Text(metric.result)
                                        .font(.body)
                                        .foregroundColor(.white)
                                        .padding(.horizontal)
                                        .padding(.bottom, 2)
                                }
                                .padding(.horizontal, 2)
                            }
                        }
                        .padding(.horizontal, 10)

                        Image("app-name")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 50)
                            .padding(.top, 10)

                        Spacer()
                    }
                    .background(StyleConstants.backgroundColor)
                    .cornerRadius(30)
                    .frame(minHeight: 320)
                    .shadow(radius: 5)
                    .padding(.top, 60)
                    .padding(.bottom, 60)

                    Image(uiImage: image)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 120, height: 120)
                        .clipShape(Circle())
                        .offset(y: -185)
                }

                HStack(spacing: 20) {
                    if let shareImage {
                        // Display ShareLink directly if shareImage is available
                        ShareLink(item: shareImage, preview: SharePreview("Check out my hair analysis results!", image: Image(uiImage: shareImage))) {
                            HStack {
                                Image(systemName: "square.and.arrow.up")
                                Text("Share")
                            }
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .frame(minWidth: 155)
                            .background(StyleConstants.buttonGradient)
                            .cornerRadius(30)
                        }
                    } else {
                        // Button that captures the screenshot and sets shareImage
                        Button(action: {
                            captureScreenshot()
                            HapticManager.instance.impact(style: .heavy)
                        }) {
                            HStack {
                                Image(systemName: "square.and.arrow.up")
                                Text("Share")
                            }
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .frame(minWidth: 155)
                            .background(StyleConstants.buttonGradient)
                            .cornerRadius(30)
                        }
                    }
                    
                    Button(action: {
                        saveToCameraRoll()
                        HapticManager.instance.impact(style: .heavy)
                    }) {
                        HStack {
                            Image(systemName: "square.and.arrow.down")
                            Text("Save")
                        }
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(minWidth: 155)
                        .background(StyleConstants.buttonGradient)
                        .cornerRadius(30)
                    }
                    
                }
                .padding(.horizontal)
                .padding(.top, 20)
                .padding(.bottom, 20)
            }
            .frame(maxWidth: 325, maxHeight: 1200)
            
            if showSaveNotification {
                VStack {
                    SaveNotificationPopUpView(message: "Image saved to Camera Roll")
                        .transition(.move(edge: .top))
                    Spacer()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.clear)
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        withAnimation {
                            showSaveNotification = false
                        }
                    }
                }
            }
        }
    }

    private func captureScreenshot() {
        // Delay by 1 second before capturing the screenshot
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            let renderer = UIGraphicsImageRenderer(size: UIScreen.main.bounds.size)
            
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let window = windowScene.windows.first {
                let screenshot = renderer.image { ctx in
                    window.rootViewController?.view.drawHierarchy(in: UIScreen.main.bounds, afterScreenUpdates: true)
                }
                shareImage = screenshot
            }
        }
    }


    private func saveToCameraRoll() {
        // Delay by 1 second before capturing the screenshot
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            let renderer = UIGraphicsImageRenderer(size: UIScreen.main.bounds.size)
            
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let window = windowScene.windows.first {
                let screenshot = renderer.image { ctx in
                    window.rootViewController?.view.drawHierarchy(in: UIScreen.main.bounds, afterScreenUpdates: true)
                }
                UIImageWriteToSavedPhotosAlbum(screenshot, nil, nil, nil)
                withAnimation {
                    showSaveNotification = true
                }
                print("Image saved to camera roll")
            }
        }
    }
}

#Preview {
    // Sample metrics for display
    @Previewable @State var selectedTab = 1
    @Previewable @State var shouldNavigateToMain = false
    // Sample metrics for display
    let sampleMetrics = [
        ("Hair Style", "✂️", "Short textured"),
        ("Hair Color", "🧵", "Dark brown"),
        ("Hair Type", "🔄", "Type 2A"),
        ("Texture", "✨", "Coarse and thick")
    ]
    // Sample image (you can use a system image or load an image from assets)
    let sampleImage = UIImage(systemName: "person.circle.fill") ?? UIImage()
    
    return ScanRatingsCard2View(
        metrics: sampleMetrics,
        image: sampleImage,
        selectedTab: $selectedTab,
        shouldNavigateToMain: $shouldNavigateToMain
    )
    .padding()
    .background(Color.white) // Use a background color for better visibility
}


