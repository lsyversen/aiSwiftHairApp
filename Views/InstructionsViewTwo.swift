//
//  InstructionsViewTwo.swift
//  hairapp
//
//  Created by Liam Syversen on 9/13/24.
// 

import SwiftUI

struct InstructionsViewTwo<NextView: View>: View {
    @Environment(\.presentationMode) var presentationMode
    var nextView: NextView // Parameter for the next view
    @Binding var selectedTab: Int // Binding to control navigation
    @State private var shouldNavigateToMain = false // State to control navigation to ContentView
 
    var body: some View {
        VStack(spacing: 20) {
            // Custom Header
            HStack {
                Button(action: {
                    selectedTab = 0
                    shouldNavigateToMain = true
                    HapticManager.instance.impact(style: .heavy)
                }) {
                    Image(systemName: "chevron.left")
                        .resizable()
                        .frame(width: 12, height: 24)
                        .foregroundColor(.white)
                }
                Spacer()
                Text("Instructions")
                    .font(.title2)
                    .bold()
                    .foregroundColor(.white)
                Spacer()
                Image(systemName: "arrow.left") // Invisible for symmetry
                    .resizable()
                    .frame(width: 12, height: 24)
                    .foregroundColor(.clear)
            }
            .padding()
            .background(StyleConstants.backgroundColor)

            ScrollView {
                VStack(spacing: 20) {
                    // Good Photos Instructions
                    InstructionsMenuView(
                        title: "Good Photos",
                        images: ["goodphoto1", "goodphoto2", "goodphoto3"],
                        instructions: [
                            (icon: "checkmark.circle", text: "Pictures of front, side, and top"),
                            (icon: "checkmark.circle", text: "High quality photo"),
                            (icon: "checkmark.circle", text: "Minimal background")
                        ]
                    )

                    // Bad Photos Instructions
                    InstructionsMenuView(
                        title: "Bad Photos",
                        images: ["badphoto1", "badphoto2", "badphoto3"],
                        instructions: [
                            (icon: "xmark.circle", text: "Picture too far away"),
                            (icon: "xmark.circle", text: "Do not cover your hair"),
                            (icon: "xmark.circle", text: "Keep the camera stable")
                        ]
                    )
                }
            }
            .padding(.top, 10)

            Spacer()

            // Continue Button
            NavigationLink(destination: nextView) {
                Text("Continue")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(StyleConstants.buttonBackgroundColor)
                    .cornerRadius(30)
                    .padding(.horizontal, 10)
            }
            .padding(.bottom, 20)
            .onTapGesture {
                HapticManager.instance.impact(style: .heavy)
            }
        }
        .navigationBarHidden(true)
        .background(StyleConstants.backgroundColor.edgesIgnoringSafeArea(.all))
        // Navigation Destination to ContentView
        .navigationDestination(isPresented: $shouldNavigateToMain) {
            ContentView(isOnboardingComplete: .constant(true), selectedTab: $selectedTab)
                .environmentObject(ScanViewModel()) // Pass the environment object
        }
    }
}

#Preview {
    NavigationView {
        InstructionsViewTwo(nextView: Text("Next View"), selectedTab: .constant(1)) // Replace 'Text("Next View")' with your actual next view
    }
}
