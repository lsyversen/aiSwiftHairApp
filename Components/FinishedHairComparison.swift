//
//  FinishedHairComparison.swift
//  hairapp
//
//  Created by Liam Syversen on 9/12/24.
//
 
import SwiftUI
import CoreData

struct FinishedHairComparison: View {
    let firstImage: UIImage
    let secondImage: UIImage
    let winnerName: String
    let date: Date?

    var body: some View {
        ZStack {
            // Rounded Rectangle background
            RoundedRectangle(cornerRadius: 30)
                .fill(Color.gray.opacity(0.2))
                .frame(width: 300, height: 400)
                .shadow(radius: 5)

            // Images positioned halfway in and halfway out
            HStack(spacing: 0) {
                // First image (left side)
                Image(uiImage: firstImage)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 150, height: 400)
                    .clipped()
                    .overlay(
                        LinearGradient(gradient: Gradient(colors: [Color.clear, Color.black.opacity(0.3)]),
                                       startPoint: .center, endPoint: .bottom)
                    )

                // Second image (right side)
                Image(uiImage: secondImage)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 150, height: 400)
                    .clipped()
                    .overlay(
                        LinearGradient(gradient: Gradient(colors: [Color.clear, Color.black.opacity(0.3)]),
                                       startPoint: .center, endPoint: .bottom)
                    )
            }
            .frame(width: 300, height: 400)

            // Winner's name overlay on top of the images
            VStack {
                Text(winnerName)
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .background(StyleConstants.buttonGradient)
                    .cornerRadius(30)
                    .padding(.top, 300)
            }
            .frame(width: 250)
        }
        .frame(width: 300, height: 400)
        .cornerRadius(30)
        .padding()
    }

}

