//
//  LearnMoreSectionView.swift
//  hairapp
//
//  Created by Liam Syversen on 9/12/24.
//

import SwiftUI

struct LearnMoreSectionView: View {
    let section: LearnMoreSection
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ZStack {
            // Background color covering the entire screen
            StyleConstants.backgroundColor
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                // Custom Header with back button
                HStack {
                    Button(action: {
                        dismiss() // Go back to the previous screen with animation
                        HapticManager.instance.impact(style: .heavy)
                    }) {
                        Image(systemName: "chevron.left")
                            .resizable()
                            .frame(width: 12, height: 24)
                            .foregroundColor(.white)
                    }
                    Spacer()
                    Text(section.title)
                        .font(.title2)
                        .bold()
                        .foregroundColor(.white)
                    Spacer()
                    Image(systemName: "chevron.left")
                        .resizable()
                        .frame(width: 12, height: 24)
                        .foregroundColor(.clear) // For symmetry
                }
                .padding()
                .background(StyleConstants.backgroundColor)
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        // Iterate over each description in the section and display it with bullet points
                        ForEach(section.description, id: \.self) { description in
                            HStack(alignment: .top, spacing: 10) {
                                Text(description)
                                    .font(.body)
                                    .foregroundColor(.white)
                                    .padding()
                                    .background(Color.gray.opacity(0.2))
                                    .cornerRadius(15)
                            }
                        }
                    }
                    .padding()
                }
            }
        }
        .navigationBarHidden(true)
    }
}

#Preview {
    LearnMoreSectionView(section: LearnMoreSection(
        title: "Hair Scans",
        description: [
            "The Hair Rating Scan provides an in-depth analysis of your hair's overall health, evaluating aspects like thickness, luster, and resilience. It helps you understand your hair’s condition, enabling better care and maintenance.",
            "Our Hair Line Scan is designed to detect early signs of hairline recession. By assessing the density and position of your hairline, it provides actionable insights to help you maintain or improve your hairline.",
            "The Who Has Better Hair Scan offers a fun and interactive way to compare your hair with friends. It evaluates multiple factors such as volume, texture, and sheen, giving a lighthearted comparison based on scientific metrics."
        ],
        image: "hairscans"
    ))
}

