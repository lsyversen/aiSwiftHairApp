//
//  RatingsView.swift
//  hair-app
//
//  Created by Liam Syversen on 9/2/24.
//

import SwiftUI
import StoreKit

struct RatingsView: View {
    @Binding var currentTab: Int // Add binding for the current tab

    var body: some View {
        VStack {
            // "Trusted by" Text aligned to the left and limited in width
            HStack {
                Text("100,000+ scans completed")
                    .font(.title)
                    .bold()
                    .foregroundColor(.white)
                    .multilineTextAlignment(.leading)
                    .frame(width: UIScreen.main.bounds.width / 2, alignment: .leading) // Limit text width
                    .padding(.top, 60)
                Spacer()
            }
            .padding(.leading, 20) // Align text to the left side of the view

            Spacer()

            // Centered App Logo and 5 Stars
            VStack(spacing: 20) {
                Image("app_icon") // Replace with your app's logo
                    .resizable()
                    .scaledToFit()
                    .frame(width: 350, height: 350) // Adjust the size as needed
            }
            .padding(.vertical, 10) // Adds space above and below

            Spacer()

            // Continue Button
            Button(action: {
                requestReview() // Trigger the Apple review prompt
                currentTab += 1 // Move to the next tab
            }) {
                Text("Continue")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .cornerRadius(30)
                    .padding(.horizontal, 20)
            }
            .padding(.bottom, 50)
        }
        .navigationBarHidden(true) // Hide default navigation bar
    }

    // Function to request a review from the user
    func requestReview() {
        if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            SKStoreReviewController.requestReview(in: scene)
        }
    }
}

#Preview {
    RatingsView(currentTab: .constant(2))
}



