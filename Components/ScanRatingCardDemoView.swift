//
//  ScanRatingCardDemoView.swift
//  hairapp
//
//  Created by Liam Syversen on 9/15/24.
// 

import SwiftUI
import UIKit

struct ScanRatingsDemoView: View {
    let metrics: [(name: String, value: Double)]
    let image: UIImage

    var body: some View {
        VStack {
            // Metrics Card
            ZStack {
                // Main Content Frame
                VStack {
                    Spacer().frame(height: 80)
                        
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 25) {
                        ForEach(metrics, id: \.name) { metric in
                            VStack(alignment: .leading) {
                                Text(metric.name)
                                    .font(.subheadline)
                                    .foregroundColor(.white)
                                    .lineLimit(2)
                                    .minimumScaleFactor(0.8)
                                    .padding(.bottom, 2)
                                
                                Text(String("888"))
                                    .font(.title2)
                                    .bold()
                                    .blur(radius: 12.0)
                                    .foregroundColor(.white)
                                    .padding(.bottom, 2)
                                
                                // Use CustomProgressView instead of ProgressView
                                CustomProgressView(score: CGFloat(metric.value))
                                    .frame(width: 100,height: 12)
                                    .cornerRadius(7)
                            }
                            .padding(.horizontal, 10)
                            .padding(.bottom, 16)
                        }
                    }
                    .padding(.horizontal, 10)
                    
                    Spacer()
                }
                .background(StyleConstants.backgroundColor)
                .cornerRadius(30)
                .frame(maxHeight: 320)
                .shadow(radius: 5)
                
                // Display passed image with the same styling as ScanRatingsCard2View
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 120, height: 120)
                    .clipShape(Circle())
                    .offset(y: -225) // Positioning halfway in, halfway out
            }
        }
        .frame(maxWidth: 325, maxHeight: 600) // Ensure the VStack takes full space
    }
}

#Preview {
    let sampleMetrics: [(name: String, value: Double)] = [
        ("Overall", 75.0),
        ("Potential", 85.0),
        ("Frizz Level", 65.0),
        ("Thickness", 90.0),
        ("Scalp Health", 80.0),
        ("Volume", 50.0)
    ]
    
    // Sample image for the preview
    let sampleImage = UIImage(named: "example-image") ?? UIImage(systemName: "person.circle.fill")!

    return ScanRatingsDemoView(
        metrics: sampleMetrics,
        image: sampleImage
    )
    .padding()
}
