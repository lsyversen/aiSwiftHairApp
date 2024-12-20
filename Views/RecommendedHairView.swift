//
//  RecommendedHairView.swift
//  hairapp
//
//  Created by Liam Syversen on 9/15/24.
//  

import SwiftUI

struct RecommendedHairView: View {
    @EnvironmentObject var scanViewModel: ScanViewModel // To fetch scans
    @State private var recommendedStyles: [HairStyle] = []
    @Environment(\.dismiss) private var dismiss // Environment dismiss to handle back navigation
    @State private var faceShape: String = "Unknown"
    @State private var gender: String = UserDefaults.standard.string(forKey: "selectedGender") ?? "Male"
    @State private var hairType: String = "Unknown" // Assuming this is fetched or stored
    @State private var isContentViewActive = false // Track navigation state
    private let hairStyleGenerator = GenerateHairStyle()

    var body: some View {
        ZStack {
            VStack {
                // Custom Header
                HStack {
                    Button(action: {
                        dismiss() // Dismiss the view
                        HapticManager.instance.impact(style: .heavy)
                    }) {
                        Image(systemName: "xmark")
                            .resizable()
                            .frame(width: 24, height: 24)
                            .foregroundColor(.white)
                    }
                    Spacer()
                    Text("Recommended Hairstyles")
                        .font(.title2)
                        .bold()
                        .foregroundColor(.white)
                    Spacer()
                    Image(systemName: "xmark")
                        .resizable()
                        .frame(width: 24, height: 24)
                        .foregroundColor(.clear)
                }
                .padding()
                .background(StyleConstants.backgroundColor.edgesIgnoringSafeArea(.all))

                ScrollView {
                    VStack(spacing: 20) {
                        // Horizontal ScrollView with Recommended Styles
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 20) {
                                // Recommended Styles
                                ForEach(recommendedStyles, id: \.self) { style in
                                    HairStyleView(style: style)
                                }
                            }
                            .padding(.horizontal)
                        }
                        
                        HStack(alignment: .top) {
                            // Face Shape Description
                            Text("Since you have a \(faceShape) face shape with \(hairType) hair we recommend the following hair styles.")
                                .font(.system(size: 21))
                                .foregroundColor(.gray)
                                .multilineTextAlignment(.center)
                                .padding()
                        }
                        .padding()
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(30)
                    }
                    Spacer()
                }
            }
            .background(StyleConstants.backgroundColor.edgesIgnoringSafeArea(.all))
            .navigationBarHidden(true)
            .onAppear {
                fetchLatestScanAndGenerateRecommendations()
            }
        }
    }

    // Function to fetch the latest scan and generate recommendations
    func fetchLatestScanAndGenerateRecommendations() {
        if let latestScan = scanViewModel.scans.last {
            faceShape = latestScan.faceShape ?? "Unknown"
            hairType = latestScan.hairtype ?? "Unknown" // Fetching hair type from scan
        }
        recommendedStyles = hairStyleGenerator.fetchRecommendations(for: faceShape, hairType: hairType, gender: gender)
    }

    // HairStyleView to display individual hairstyle cards with images
    struct HairStyleView: View {
        let style: HairStyle

        var body: some View {
            ZStack(alignment: .bottom) {
                Image(style.imageName)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 300, height: 400)
                    .cornerRadius(15)
                    .clipped()

                Text(style.name)
                    .font(.caption)
                    .bold()
                    .foregroundColor(.white)
                    .padding(.vertical, 5)
                    .padding(.horizontal, 10)
                    .background(Color.black.opacity(0.6))
                    .cornerRadius(10)
                    .padding(10)
            }
            .frame(width: 300, height: 400)
        }
    }
}

// Sample scan for preview
#Preview {
    let context = PersistenceController.shared.container.viewContext
    let sampleScan = ScanResult(context: context)
    
    // Set sample values for the scan
    sampleScan.overall = 85.0
    sampleScan.potential = 90.0
    sampleScan.frizzlevel = 80.0
    sampleScan.hairdensity = 75.0
    sampleScan.shine = 88.0
    sampleScan.volume = 82.0
    sampleScan.hairthickness = "Thick"
    sampleScan.haircolor = "Dark brown"
    sampleScan.hairtype = "Curly" // Example hair type
    sampleScan.faceShape = "Oval"

    let scanViewModel = ScanViewModel(context: context)
    scanViewModel.scans = [sampleScan] // Set the sample scan to the view model

    return RecommendedHairView()
        .environmentObject(scanViewModel)
}
