//
//  ScanRatingsCardView.swift
//  hairapp
//
//  Created by Liam Syversen on 9/4/24.
//
 
import SwiftUI
import UIKit
import UniformTypeIdentifiers

struct ScanRatingsCardView: View {
    let metrics: [(name: String, value: Double)]
    let image: UIImage
    @Binding var selectedTab: Int // Binding to control the selected tab
    @Binding var shouldNavigateToMain: Bool // State to control navigation
    @State private var shareImage: UIImage? // State for the image to be shared
    @State private var showSaveNotification = false // State for showing the save notification

    var body: some View {
        ZStack {
            VStack {
                HStack {
                    Button(action: {
                        // Set the selectedTab to 1 (Results tab) and trigger navigation
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
                            .zIndex(1) // Ensure the button stays on top
                    }
                    .padding(.top, 6)

                    Spacer()
                }
                .padding(.bottom, 66)

                // Metrics Card
                ZStack {
                    // Main Content Frame
                    VStack {
                        Spacer().frame(height: 80) // Adjust height for spacing from top
                        
                        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 25) {
                            ForEach(metrics, id: \.name) { metric in
                                VStack(alignment: .leading) {
                                    Text(metric.name)
                                        .font(.subheadline)
                                        .foregroundColor(.white)
                                        .lineLimit(2)
                                        .minimumScaleFactor(0.8)
                                        .padding(.bottom, 2)
                                    
                                    Text(String(format: "%.0f", metric.value))
                                        .font(.title2)
                                        .bold()
                                        .foregroundColor(.white)
                                        .padding(.bottom, 2)
                                    
                                    // Use CustomProgressView instead of ProgressView
                                    CustomProgressView(score: CGFloat(metric.value))
                                        .frame(height: 12)
                                        .cornerRadius(7)
                                }
                                .padding(.horizontal, 10)
                            }
                        }
                        .padding(.horizontal, 10)
                        
                        // Add the app-logo image here
                        Image("app-name")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100, height: 40) // Adjust the size as needed
                            .padding(.top, 10)
                            .padding(.bottom, 20)
                        
                        Spacer()
                    }
                    .background(StyleConstants.backgroundColor)
                    .cornerRadius(30)
                    .frame(minHeight: 320)
                    .shadow(radius: 5)
                    .padding(.top, 60) // Adjust to leave space for the image
                    .padding(.bottom, 60)
                    
                    // Display passed image with the same styling as ScanRatingsCard2View
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 120, height: 120)
                        .clipShape(Circle())
                        .offset(y: -250) // Positioning halfway in, halfway out
                }
                
                // Save and Share Buttons (outside the VStack)
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
                .padding(.top, 30)
                .padding(.bottom, 20)
            }
            .frame(maxWidth: 325, maxHeight: 1200) // Ensure the VStack takes full space
            
            // Notification Pop-up
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

    // MARK: - Helper Functions

    private func saveToCameraRoll() {
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

    private func captureScreenshot() {
        let renderer = UIGraphicsImageRenderer(size: UIScreen.main.bounds.size)
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first {
            let screenshot = renderer.image { ctx in
                window.rootViewController?.view.drawHierarchy(in: UIScreen.main.bounds, afterScreenUpdates: true)
            }
            shareImage = screenshot
        }
    }
    
    private func colorForScore(_ score: Double) -> Color {
        switch score {
        case ..<60: return Color.red
        case 60..<70: return Color.orange
        case 70..<80: return Color.yellow
        case 80..<90: return Color.green.opacity(0.5)
        default: return Color.green.opacity(1.0)
        }
    }
}


#Preview {
    
    @Previewable @State var selectedTab = 1
    @Previewable @State var shouldNavigateToMain = false
    let sampleMetrics = [
        ("Overall", 82.0),
        ("Potential", 90.0),
        ("Hair Quality", 75.0),
        ("Hair Thickness", 60.0),
        ("Scalp Health", 88.0),
        ("Color", 52.0)
    ]
    
    // Sample image for the preview
    let sampleImage = UIImage(named: "example-image") ?? UIImage(systemName: "person.circle.fill")!


    return ScanRatingsCardView(
        metrics: sampleMetrics,
        image: sampleImage,
        selectedTab: $selectedTab,
        shouldNavigateToMain: $shouldNavigateToMain
    )
    .padding()
    .background(Color.white) // Use a background color for better visibility
}



