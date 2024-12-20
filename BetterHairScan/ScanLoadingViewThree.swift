//
//  ScanLoadingViewThree.swift
//  hairapp
//
//  Created by Liam Syversen on 9/12/24.
//

import SwiftUI

struct ScanLoadingViewThree: View {
    var uploadedImages: [UIImage]
    var personOneName: String
    var personTwoName: String
    @EnvironmentObject var scanViewModel: ScanViewModel
    @State private var winnerName: String?
    @State private var isScanComplete = false
    @State private var isNavigating = false
    @Binding var selectedTab: Int

    var body: some View {
        NavigationStack { 
            ZStack {
                // Background image (first uploaded image)
                Image(uiImage: uploadedImages.first ?? UIImage())
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
                    .overlay(Color.black.opacity(0.5))

                VStack(spacing: 20) {
                    Text("Scanning...")
                        .font(.largeTitle)
                        .bold()
                        .foregroundColor(.white)
                        .padding()

                    // Use CircleFlip for loading animation
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
            .navigationDestination(isPresented: $isNavigating) {
                ContentView(isOnboardingComplete: .constant(true), selectedTab: $selectedTab)
                    .environmentObject(scanViewModel)
            }
        }
    }
}




