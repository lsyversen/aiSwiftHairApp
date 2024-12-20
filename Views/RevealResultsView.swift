//
//  RevealResultsView.swift
//  hairapp
//
//  Created by Liam Syversen on 9/11/24.
//

import SwiftUI
import StoreKit

struct RevealResultsView: View {
    // Sample metrics for testing
    let sampleMetrics = [
        ("Overall", 500.0),
        ("Potential", 500.0),
        ("Frizz Level", 500.0),
        ("Thickness", 500.0),
        ("Shine", 500.0),
        ("Volume", 500.0)
    ]
    
    // Placeholder image if no image is provided
    let sampleImage: UIImage
    @EnvironmentObject var scanViewModel: ScanViewModel // Add the ScanViewModel environment object
    @StateObject private var storeManager = StoreManager() // StoreManager for handling purchases
    @State private var showSurcharge = false // State to show surcharge view
    @State private var isUserSubscribed = false // State for user subscription status
    @State private var showPaywall = false // State to show paywall view
    @Binding var shouldNavigateToMain: Bool // Binding for navigation control
    @Binding var selectedTab: Int
    @Binding var showSurchargeView: Bool // Binding for navigation control
    @State private var isCheckingSubscription: Bool = true

    var body: some View {
        if isCheckingSubscription {
            VStack {
                // Title at the top
                Text("👀 Reveal your results")
                    .font(.system(size: 32))
                    .bold()
                    .foregroundColor(.white)
                    .padding(.top, 5)
                    .padding(.bottom, 60)
                
                Spacer()
                
                CircleFlip()
                    .frame(width: 60, height: 60)
                    .padding()
                
                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(StyleConstants.backgroundColor.edgesIgnoringSafeArea(.all))
            .onAppear {
                checkSubscriptionStatus() // Check subscription status on load
            }
        } else {
            NavigationStack {
                VStack {
                    // Title at the top
                    Text("👀 Reveal your results")
                        .font(.system(size: 32))
                        .bold()
                        .foregroundColor(.white)
                        .padding(.top, 5)
                        .padding(.bottom, 60)
                    
                    Spacer()
                    
                    // Scan Ratings Demo View in the center
                    ScanRatingsDemoView(metrics: sampleMetrics, image: sampleImage)
                        .frame(maxHeight: .infinity) // Ensures it stays centered
                    
                    // "Get Results Now" button at the bottom
                    Button(action: {
                        checkAccessToResults()
                    }) {
                        Text("Get Results Now")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(StyleConstants.buttonGradient)
                            .cornerRadius(30)
                            .padding(.horizontal, 20)
                    }
                    .padding(.bottom, 30) // Adjust bottom padding as needed
                }
                .background(StyleConstants.backgroundColor.opacity(0.8).edgesIgnoringSafeArea(.all))
                .navigationBarHidden(false) // Keeps the navigation bar for swipe-back gesture
                .navigationBarBackButtonHidden(true) // Hides the default back button
                .onAppear {
                    storeManager.fetchProducts() // Fetch available products when the view appears
                }
                // Navigation to SurchargeView if subscribed
                .navigationDestination(isPresented: $showSurcharge) {
                    SurchargeView(showPaywall: .constant(false), selectedTab: .constant(0), scanType: "hairrating")
                        .environmentObject(scanViewModel)
                        .environmentObject(storeManager)
                }
                // Navigation to PaywallView if not subscribed
                .navigationDestination(isPresented: $showPaywall) {
                    PaywallView(showPaywall: $showPaywall)
                        .environmentObject(scanViewModel)
                        .environmentObject(storeManager)
                }
            }
        }
    }

    // MARK: - Helper Functions
    private func checkAccessToResults() {
        // Ensure UI updates happen on the main thread
        DispatchQueue.main.async {
            if isUserSubscribed {
                print("User is subscribed, navigating to the surcharge view.")
                showSurcharge = true
            } else {
                print("User is not subscribed, navigating to the paywall view.")
                showPaywall = true
            }
        }
    }

    private func checkSubscriptionStatus() {
        Task {
            await storeManager.checkPurchases() // This method does not throw

            DispatchQueue.main.async {
                if storeManager.isProductPurchased(Products.weekly) {
                    isUserSubscribed = true
                } else {
                    isUserSubscribed = false
                }
                isCheckingSubscription = false // Subscription check complete
            }
        }
    }
}

    
// MARK: - Preview
#Preview {
    struct RevealResultsPreview: View {
        @State private var shouldNavigateToMain = false
        @State private var selectedTab = 0
        @StateObject private var scanViewModel = ScanViewModel()
        @State private var showSurcharge = false // State to show surcharge view
        var body: some View {
            RevealResultsView(
                sampleImage: UIImage(systemName: "person.circle.fill") ?? UIImage(),
                shouldNavigateToMain: $shouldNavigateToMain,
                selectedTab: $selectedTab, showSurchargeView: $showSurcharge
            )
            .environmentObject(scanViewModel)
        }
    }
    
    return RevealResultsPreview()
}
