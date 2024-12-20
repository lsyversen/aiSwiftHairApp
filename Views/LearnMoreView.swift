//
//  LearnMoreView.swift
//  hairapp
//
//  Created by Liam Syversen on 9/10/24.
//
 
import SwiftUI

struct LearnMoreView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var shouldNavigateToMain = false
    @State private var selectedTab = 0
    @ObservedObject var viewModel = LearnMoreModel()
    @EnvironmentObject var scanViewModel: ScanViewModel
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        NavigationStack {
            VStack {
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
                    Text("Learn More")
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
                
                Spacer()
                
                // ScrollView containing the grid of sections
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 20) {
                        ForEach(viewModel.sections, id: \.title) { section in
                            Button(action: {
                                HapticManager.instance.impact(style: .heavy) // Trigger haptic feedback
                            }) {
                                NavigationLink(destination: LearnMoreSectionView(section: section)) {
                                    LearnMoreSectionButton(image: section.image, title: section.title)
                                }
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                    .padding()
                }
                
                Spacer()
            }
            .background(StyleConstants.backgroundColor.edgesIgnoringSafeArea(.all))
        }
        .navigationBarHidden(true)
        .navigationDestination(isPresented: $shouldNavigateToMain) {
            ContentView(isOnboardingComplete: .constant(true), selectedTab: $selectedTab)
                .environmentObject(scanViewModel)
        }
    }
}

struct LearnMoreSectionButton: View {
    let image: String
    let title: String

    var body: some View {
        VStack {
            
            
                Image(image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 200, height: 100)
                    .padding(.top, 10)
 
            
            Text(title)
                .font(.headline)
                .foregroundColor(.white)
                .padding(.top, 10)
                .padding(.bottom, 10)
            
            Spacer()
        }
        .frame(width: 140, height: 200)
        .background(StyleConstants.buttonGradient)
        .cornerRadius(15)
        .shadow(radius: 5)
    }
}

#Preview {
    LearnMoreView()
}


