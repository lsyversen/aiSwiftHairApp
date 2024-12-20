//
//  SurchargeView.swift
//  hairapp
//
//  Created by Liam Syversen on 9/18/24.
// 
 
import SwiftUI
import StoreKit

struct SurchargeView: View {
    @Environment(\.dismiss) private var dismiss // Dismisses the current view
    @Binding var showPaywall: Bool
    @State private var selectedProduct: Product?
    @State private var shouldNavigateToMain = false // State to control navigation to ContentView
    @StateObject private var storeManager = StoreManager()
    @EnvironmentObject var scanViewModel: ScanViewModel // Add the ScanViewModel environment object
    @Binding var selectedTab: Int // Binding to control the selected tab in ContentView
    @State private var selectedTabTwo = 0
    
    // Assuming you pass the scan type to the SurchargeView to know which token to add
    var scanType: String

    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                ZStack {
                    StyleConstants.backgroundColor.ignoresSafeArea()

                    VStack {
                        // Dismiss Button in the top left corner
                        HStack {
                            Button(action: {
                                // Navigate back to ContentView instead of dismissing
                                selectedTab = 0
                                shouldNavigateToMain = true
                                HapticManager.instance.impact(style: .heavy)
                            }) {
                                Image(systemName: "xmark")
                                    .resizable()
                                    .frame(width: geometry.size.width * 0.03, height: geometry.size.width * 0.03)
                                    .foregroundColor(.gray)
                            }
                            Spacer()
                        }
                        .padding(.leading, geometry.size.width * 0.05)
                        .padding(.top, 10)

                        Spacer()

                        // Header Section
                        VStack(spacing: geometry.size.height * 0.01) {
                            Text("GLOW UP")
                                .font(.system(size: geometry.size.width * 0.08, weight: .bold))
                                .foregroundColor(.white)
                        }

                        // Feature TabView
                        TabView(selection: $selectedTabTwo) {
                            ForEach(1..<5) { index in
                                FeatureView(imageName: "feature\(index)", isLastTab: index == 6) // Last tab will display the video
                                    .tag(index)
                                }
                        }
                        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .automatic))
                        .frame(height: geometry.size.height * 0.5)

                        // Description Text
                        Text("We have to charge a small fee to help cover the analysis, as it’s expensive for us. We appreciate your understanding. 🙌")
                            .font(.system(size: geometry.size.width * 0.045))
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.center)

                        Spacer()

                        // Surcharge Purchase Button
                        if let surchargeProduct = storeManager.myProducts.first(where: { $0.id == Products.surcharge }) {
                            Button(action: {
                                selectedProduct = surchargeProduct
                                HapticManager.instance.impact(style: .heavy)
                                if let product = selectedProduct {
                                    storeManager.buyProduct(product: product)
                                }
                            }) {
                                Text("See Results Now 🙌")
                                    .font(.system(size: geometry.size.width * 0.05, weight: .bold))
                                    .foregroundColor(.white)
                                    .padding()
                                    .frame(maxWidth: geometry.size.width * 0.9)
                                    .background(Color.blue)
                                    .cornerRadius(30)
                            }
                            .padding(.top, geometry.size.height * 0.02)

                            // Display the price of the surcharge product
                            Text("\(surchargeProduct.displayPrice) per additional scan")
                                .font(.system(size: geometry.size.width * 0.03))
                                .foregroundColor(.gray)
                                .padding(.top, geometry.size.height * 0.01)
                                .padding(.bottom, 30)
                        } else {
                            // If no surcharge product is available
                            Text("Loading surcharge details...")
                                .font(.system(size: geometry.size.width * 0.045))
                                .foregroundColor(.gray)
                                .padding(.top, geometry.size.height * 0.02)

                            Button(action: {
                                print("Products available: \(storeManager.myProducts)")
                            }) {
                                Text("Check Product Fetching Status")
                                    .font(.system(size: geometry.size.width * 0.04))
                                    .foregroundColor(.white)
                            }
                        }

                        // Footer Options at the bottom
                        VStack(spacing: 10) {
                            HStack(spacing: geometry.size.width * 0.25) {
                                Button(action: {
                                    print("Terms of Service tapped")
                                }) {
                                    Text("Terms of Service")
                                        .font(.system(size: geometry.size.width * 0.035))
                                        .foregroundColor(.white)
                                }

                                Button(action: {
                                    print("Privacy Policy tapped")
                                }) {
                                    Text("Privacy Policy")
                                        .font(.system(size: geometry.size.width * 0.035))
                                        .foregroundColor(.white)
                                }
                            }
                            .padding(.bottom, 10)
                        }
                    }
                    .padding(.horizontal)
                }
            } 
            .navigationBarHidden(true)
            .onAppear {
                storeManager.fetchProducts()
                print("Fetching products...")
            }
            // Observe for purchase completion and dismiss the view
            .onChange(of: storeManager.purchasedProducts) {
                if storeManager.purchasedProducts.contains(Products.surcharge) {
                    showPaywall = false // Dismiss the paywall if surcharge purchased
                    scanViewModel.grantToken(for: scanType) // Grant a token for the appropriate scan type
                    selectedTab = 0 // Navigate back to ContentView tab
                    shouldNavigateToMain = true
                }
            }
            // Navigation Destination to ContentView
            .navigationDestination(isPresented: $shouldNavigateToMain) {
                ContentView(isOnboardingComplete: .constant(true), selectedTab: $selectedTab)
                    .environmentObject(scanViewModel)
            }
        }
    }
}


#Preview {
    SurchargeView(showPaywall: .constant(true), selectedTab: .constant(0), scanType: "hairrating")
        .environmentObject(ScanViewModel())
}
