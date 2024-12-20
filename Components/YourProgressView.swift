//
//  YourProgressView.swift
//  hairapp
//
//  Created by Liam Syversen on 9/12/24.
// 

import SwiftUI

struct YourProgressView: View {
    var recentProgressImage: UIImage // This is where the most recent image will be passed
    
    var body: some View {
                HStack {
                    // Display the progress image in a circle
                    if let image = UIImage(data: recentProgressImage.pngData() ?? Data()) {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 100, height: 100)
                            .clipShape(Circle())
                            .overlay(Circle().stroke(StyleConstants.buttonGradient, lineWidth: 4))
                            .shadow(radius: 5)
                            .padding(.top, 20)
                    } else {
                        // Placeholder for when there is no image available
                        Circle()
                            .fill(Color.gray)
                            .frame(width: 100, height: 100)
                            .overlay(Circle().stroke(StyleConstants.textGradient, lineWidth: 4))
                            .shadow(radius: 5)
                            .padding(.top, 20)
                    }

                    Spacer()

                    Text("View Progress")
                        .font(.subheadline)
                        .foregroundColor(.white)
                        .padding(.horizontal)
                        .padding(.vertical, 8)
                        .background(StyleConstants.buttonGradient)
                        .cornerRadius(10)
                        .padding(.trailing)
                }
                .padding()
                .background(StyleConstants.buttonGradient)
                .cornerRadius(30)
                .padding(.horizontal)
                .padding(.top, 20)
            }
}

#Preview {
    YourProgressView(recentProgressImage: UIImage(named: "hairrating1") ?? UIImage())
}
