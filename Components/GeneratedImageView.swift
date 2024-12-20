//
//  GeneratedImageView.swift
//  hairapp
//
//  Created by Liam Syversen on 9/20/24.
//

import SwiftUI

struct GeneratedImageView: View {
    let image: UIImage
    let result: String

    var body: some View {
        ZStack {
            // Background image with fade effect
            Image(uiImage: image)
                .resizable()
                .scaledToFit()
                .frame(width: 300, height: 450) // Adjusted size for UI display
                .cornerRadius(10)
                .overlay(
                    // Apply the gradient fade effect at the bottom
                    LinearGradient(gradient: Gradient(colors: [Color.clear, Color.black.opacity(0.7)]),
                                   startPoint: .center, endPoint: .bottom)
                )
                .clipShape(RoundedRectangle(cornerRadius: 30)) // Clipping to match the corner radius
            
            // Display the classification result at the bottom
            VStack {
                HStack{
                    Button(action: {
                        print("Save pressed")
                    }) {
                        HStack {
                            Image(systemName: "square.and.arrow.down")
                            Text("Save")
                        }
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(minWidth: 150)
                        .background(StyleConstants.buttonBackgroundColor)
                        .cornerRadius(30)
                    }

                    Button(action: {
                        print("Share pressed")
                    }) {
                        HStack {
                            Image(systemName: "square.and.arrow.up")
                            Text("Share")
                        }
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(minWidth: 155)
                        .background(StyleConstants.buttonBackgroundColor)
                        .cornerRadius(30)
                    }
                    
                }
            }
        }
        .shadow(radius: 5)
        .padding()
    }
}


#Preview {
    GeneratedImageView(image: UIImage(named: "Example")!, result: "Stage 2")
}

