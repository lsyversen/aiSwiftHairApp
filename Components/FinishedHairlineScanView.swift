//
//  FinishedHairlineScanView.swift
//  hairapp
//
//  Created by Liam Syversen on 9/5/24.
//

import SwiftUI
import CoreData

struct FinishedHairlineScanView: View {
    let hairlineScan: Hairline

    var body: some View {
        ZStack {
            // Extract image from scan's imageData
            if let imageData = hairlineScan.hairlineImageData, let image = UIImage(data: imageData) {
                Image(uiImage : image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 300, height: 400) // Adjusted size for UI display
                    .cornerRadius(10)
                    .overlay(
                        // Apply the gradient fade effect at the bottom
                        LinearGradient(gradient: Gradient(colors: [Color.clear, Color.black.opacity(0.7)]),
                                       startPoint: .center, endPoint: .bottom)
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 30)) // Clipping to match the corner radius
            }

            // Display the scan result at the bottom
            VStack {
                Text(hairlineScan.hairlossStage ?? "Unknown Stage") // Safely unwrap the stage or provide a default value
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(width: 250)
                    .padding()
                    .background(StyleConstants.backgroundColor.opacity(0.6))
                    .cornerRadius(30)
                    .padding(.top, 300)
            }
        }
        .frame(width: 300, height: 400)
        .shadow(radius: 5)
        .padding()
    }
}

#Preview {
    let context = PersistenceController.shared.container.viewContext
    
    // Creating a mock Hairline object
    let mockHairlineScan = Hairline(context: context)
    mockHairlineScan.hairlossStage = "Stage 2"
    mockHairlineScan.hairlineImageData = UIImage(systemName: "photo")?.pngData()

    // Preview the FinishedHairlineScanView
    return FinishedHairlineScanView(hairlineScan: mockHairlineScan)
}
