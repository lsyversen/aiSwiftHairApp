//
//  HairPorosityTestView.swift
//  hairapp
//
//  Created by Liam Syversen on 10/13/24.
//

import SwiftUI

struct HairPorosityTestView: View {
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
                    Text("Float Test")
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
                    VStack(spacing: 40) {
                        HStack(alignment: .top) {
                            Text("•")
                                .font(.system(size: 60))
                                .foregroundColor(.white)
                            Text("Take a few strands of clean, dry hair and place them in a cup of water.")
                                .font(.system(size: 25))
                                .foregroundColor(.white)
                        }
                        .padding()
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(30)
                        
                        // Porosity Level Chart Image
                        Image("floattest") // Replace with your image name
                            .resizable()
                            .scaledToFit()
                            .frame(width: 340)
                            .cornerRadius(15)
                        
                        HStack(alignment: .top) {
                            Text("• If your hair floats, it likely has **low porosity**.\n• If it sinks slowly, it has **medium porosity**.\n• If it sinks quickly, it has **high porosity**.")
                                .font(.system(size: 25))
                                .foregroundColor(.white)
                        }
                        .padding()
                        .frame(width: 340)
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(30)
                        
                        
                        VStack(alignment: .leading) {
                            Text("Why is it important?")
                                .font(.system(size: 33)).bold()
                                .foregroundColor(.white)
                                .padding()
                        }
                        .frame(width: 340)
                        .background(StyleConstants.buttonGradient)
                        .cornerRadius(15)
                        VStack (alignment: .leading){
                                HStack(alignment: .top) {
                                    Text("•")
                                        .font(.system(size: 60))
                                        .foregroundColor(.white)
                                        .padding(.top, 8)
                                    Text("\nHair porosity determines how well your hair absorbs and retains moisture. Knowing your hair’s porosity can help you choose the right products and routine to keep it healthy.")
                                        .font(.system(size: 25))
                                        .foregroundColor(.white)
                                }
                                Spacer()
                                HStack(alignment: .top) {
                                    Text("•")
                                        .font(.system(size: 60))
                                        .foregroundColor(.white)
                                        .padding(.top, 8)
                                    Text("\nLow porosity hair often resists moisture, medium porosity is well-balanced, and high porosity absorbs moisture quickly but loses it just as fast, often indicating **damage**.")
                                        .font(.system(size: 25))
                                        .foregroundColor(.white)
                                        .padding(.bottom, 30)
                                    
                                }
                            }
                            .padding()
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(30)
                        }
                    }
                    .padding()
                }
                Spacer()
        }
        .navigationBarHidden(true)
        .transition(.move(edge: .bottom)) // Add slide-up transition
    }
}

#Preview {
    HairPorosityTestView()
}
 
