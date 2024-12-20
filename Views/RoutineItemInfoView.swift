//
//  RoutineItemInfoView.swift
//  hairapp
//
//  Created by Liam Syversen on 10/5/24.
//

import SwiftUI

struct RoutineItemInfoView: View {
    var title: String // Title of the routine item
    var descriptions: [String] // Array of descriptions for the routine item
    var productLinks: [ProductLink]? // Optional list of products

    @Environment(\.dismiss) private var dismiss // Environment dismiss to handle back navigation

    var body: some View {
        ZStack {
            StyleConstants.backgroundColor
                .edgesIgnoringSafeArea(.all)

            VStack {
                // Custom Header with back button
                HStack {
                    Button(action: {
                        dismiss() // Dismiss the view
                        HapticManager.instance.impact(style: .heavy)
                    }) {
                        Image(systemName: "xmark")
                            .resizable()
                            .frame(width: 24, height: 24)
                            .foregroundColor(.white)
                    }
                    Spacer()
                    Text(title)
                        .font(.title2)
                        .bold()
                        .foregroundColor(.white)
                    Spacer()
                    Image(systemName: "xmark")
                        .resizable()
                        .frame(width: 24, height: 24)
                        .foregroundColor(.clear) // For symmetry
                }
                .padding()
                .background(StyleConstants.backgroundColor)

                ScrollView {
                    VStack(alignment: .leading, spacing: 40) {
                        ForEach(descriptions, id: \.self) { description in
                            HStack(alignment: .top) {
                                Text("•")
                                    .font(.system(size: 60))
                                    .foregroundColor(.white)
                                Text(description)
                                    .font(.system(size: 25))
                                    .foregroundColor(.white)
                            }
                            .padding()
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(30)
                        }

                        // Recommended Products Section
                        if let products = productLinks {
                            Text("Recommended Products")
                                .font(.title2)
                                .bold()
                                .foregroundColor(.white)
                                .padding(.top, 20)
                            
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 20) {
                                    ForEach(products, id: \.id) { product in
                                        Button(action: {
                                            openAmazonLink(for: product.url)
                                        }) {
                                            VStack {
                                                Image(product.imageName)
                                                    .resizable()
                                                    .scaledToFit()
                                                    .frame(width: 100, height: 100)
                                                    .cornerRadius(20)
                                                Text(product.name)
                                                    .font(.caption)
                                                    .foregroundColor(.white)
                                                    .lineLimit(2)
                                                    .multilineTextAlignment(.center)
                                                    .padding(.top, 5)
                                            }
                                        }
                                    }
                                }
                            }
                            .padding(.vertical)
                        }
                    }
                    .padding()
                }
                
                Spacer()
            }
        }
        .navigationBarHidden(true)
        .transition(.move(edge: .bottom)) // Add slide-up transition
    }
    
    // Function to open the Amazon URL
    private func openAmazonLink(for url: String) {
        if let url = URL(string: url) {
            UIApplication.shared.open(url)
        }
    }
}

// Example Product model
struct ProductLink: Identifiable {
    let id = UUID()
    let name: String
    let imageName: String
    let url: String
}

#Preview {
    RoutineItemInfoView(
        title: "Natural Shampoo & Moisturize",
        descriptions: [
            "Use a sulfate-free shampoo to maintain natural oils.",
            "Follow with a hydrating conditioner to lock in moisture.",
            "Choose products that suit your hair type for best results."
        ],
        productLinks: [
            ProductLink(name: "Sulfate-Free Shampoo", imageName: "shampoo", url: "https://www.amazon.com/"),
            ProductLink(name: "Moisturizing Conditioner", imageName: "conditioner", url: "https://www.amazon.com/")
        ]
    )
}




