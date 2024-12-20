//
//  ScanLoadingView.swift
//  hair-app
// 

import SwiftUI 

struct ScanLoadingView: View {
    var uploadedImages: [UIImage] // All selected images
    @EnvironmentObject var scanViewModel: ScanViewModel
    @State private var parsedMetrics: [String: Any]? = nil // Store parsed metrics
    @State private var shouldNavigateToScanRatings = false // State to control navigation
    @State private var shouldNavigateToMain = false // State to control navigation
    @Binding var selectedTab: Int
    @State private var latestScan: ScanResult? = nil // Store the latest scan result
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Background image (first uploaded image)
                Image(uiImage: uploadedImages.first ?? UIImage())
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
                    .overlay(Color.black.opacity(0.5)) // Darken background for better text visibility

                VStack(spacing: 20) {
                    Text("Analyzing")
                        .font(.largeTitle) 
                        .bold()
                        .foregroundColor(.white)
                        .padding()

                    CircleFlip()
                        .frame(width: 60, height: 60)

                    Text("Don't close the app. This may take ~ 2 min.")
                        .font(.footnote)
                        .foregroundColor(.white)
                        .padding(.top, 10)
                        .padding(.horizontal, 5)
                }
            }
            .navigationBarHidden(true)
            .onAppear {
                analyzeHair()
                shouldNavigateToMain = false
            }
            .navigationDestination(isPresented: $shouldNavigateToScanRatings) {
                if let latestScan = latestScan {
                    ScanRatingsTabView(selectedTab: $selectedTab, shouldNavigateToMain: $shouldNavigateToMain, scan: latestScan)
                        .environmentObject(scanViewModel)
                }
            }
        }
    }

    private func analyzeHair() {
            let openAIService = OpenAIService()
            openAIService.analyzeHair(images: uploadedImages) { result in
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    if let result = result, let metrics = parseAnalysisResults(result) {
                        print("Parsed Metrics:", metrics)
                        
                        // Use only the first image
                        if let firstImage = uploadedImages.first {
                            scanViewModel.addCompletedScan(image: firstImage, result: result, metrics: metrics)
                            
                            // Ensure that the latest scan result is retrieved only after the scan is saved
                            DispatchQueue.main.asyncAfter(deadline: .now() + 8) {
                                if let latest = scanViewModel.scans.last {
                                    self.latestScan = latest // Store the latest scan
                                    shouldNavigateToScanRatings = true // Trigger the navigation only after latest scan is set
                                }
                            }
                        }
                    } else {
                        // Handle analysis failure
                        print("Failed to analyze hair.")
                    }
                }
            }
        }

    private func parseAnalysisResults(_ result: String) -> [String: Any]? {
        var metrics: [String: Any] = [:]
        
        // Safeguard against empty input
        guard !result.isEmpty else {
            print("Error: Input string is empty")
            return nil
        }

        // Trim the input and make sure it is valid JSON
        let trimmedResult = result.trimmingCharacters(in: .whitespacesAndNewlines)
        
        // Attempt to convert the string to JSON data
        guard let jsonData = trimmedResult.data(using: .utf8) else {
            print("Error: Failed to convert string to JSON Data.")
            return nil
        }

        // Parse JSON data
        do {
            if let jsonObject = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: String] {
                for (key, value) in jsonObject {
                    if value.contains("Rating:") {
                        // Extract and convert the number from the "Rating:"
                        let numberString = value.replacingOccurrences(of: "Rating:", with: "").trimmingCharacters(in: .whitespaces)
                        if let number = Double(numberString) {
                            metrics[key] = number
                        } else {
                            print("Failed to convert \(numberString) to Double for key: \(key)")
                        }
                    } else if value.contains("Description:") {
                        // Extract the description
                        let description = value.replacingOccurrences(of: "Description:", with: "").trimmingCharacters(in: .whitespaces)
                        metrics[key] = description
                    }
                }
            } else {
                print("Failed to parse JSON into [String: String] format.")
            }
        } catch {
            print("Error parsing JSON: \(error)")
            return nil
        }
        
        print("Parsed Metrics: \(metrics)") // Debugging log to check parsed output
        return metrics
    }
}
