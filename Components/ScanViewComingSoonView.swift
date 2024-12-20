//
//  ScanViewComingSoonView.swift
//  hairapp
//
//  Created by Liam Syversen on 9/22/24.
//

import SwiftUI

struct ScanViewComingSoonView: View {
    @State private var selectedGender: String = UserDefaults.standard.string(forKey: "selectedGender") ?? "Unspecified"

    var body: some View {
        ZStack {
            // Dynamically update the background image based on gender
            Image(getImageForGender(baseImage: "whohasbetter"))
                .resizable()
                .scaledToFit()
                .frame(width: 300, height: 450) // Adjusted size for UI display
                .cornerRadius(10)
                .overlay(
                    // Apply the gradient fade effect at the bottom
                    LinearGradient(
                        gradient: Gradient(colors: [Color.clear, Color.black.opacity(0.7)]),
                        startPoint: .center,
                        endPoint: .bottom
                    )
                )
                .clipShape(RoundedRectangle(cornerRadius: 30)) // Clipping to match the corner radius

            // Overlay title at the top and "Coming Soon" button at the bottom
            VStack {
                // Title at the top of the image
                Text("Try On Hairstyles")
                    .font(.largeTitle)
                    .foregroundColor(Color.gray)
                    .padding(.top, 10)

                Spacer() // Spacer to push the "Coming Soon" button to the bottom

                // "Coming Soon" button at the bottom of the image
                Text("Coming Soon...")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(minWidth: 250)
                    .background(StyleConstants.buttonGradient)
                    .cornerRadius(30)
                    .padding(.bottom, 20)
            }
            .frame(width: 300, height: 450) // Ensuring the VStack respects the image frame
        }
        .shadow(radius: 5)
        .padding()
        .onTapGesture {
            HapticManager.instance.impact(style: .heavy) // Trigger haptic feedback
        }
        .onChange(of: UserDefaults.standard.string(forKey: "selectedGender") ?? "Unspecified") {
            selectedGender = UserDefaults.standard.string(forKey: "selectedGender") ?? "Unspecified"
        }
    }

    // Function to dynamically get the image name based on gender
    private func getImageForGender(baseImage: String) -> String {
        switch selectedGender {
        case "Female":
            return baseImage + "women"
        case "Male":
            return baseImage + "men"
        default:
            return baseImage + "men" // Default to "men" if gender is unspecified
        }
    }

    // Function to load gender from UserDefaults
    private func loadGender() {
        selectedGender = UserDefaults.standard.string(forKey: "selectedGender") ?? "Unspecified"
    }
}

#Preview {
    ScanViewComingSoonView()
}

