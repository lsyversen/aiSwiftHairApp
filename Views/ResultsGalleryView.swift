//
//  ResultsGalleryView.swift
//  hairapp
//
//  Created by Liam Syversen on 10/12/24.
// 
   
import SwiftUI

struct ResultsGalleryView: View {
    @State var hairlineScans: [HairlineScanMock] // Array to hold the scan images and results
    @Binding var selectedTab: Int // Binding to control the selected tab
    @State private var shouldNavigateToMainOne = false // State to control navigation
    @State var selectedIndex: Int // Selected image index to start with

    var body: some View { 
        NavigationStack {
            ZStack {
                GeometryReader { geometry in
                    TabView(selection: $selectedIndex) {
                        ForEach(hairlineScans.indices, id: \.self) { index in
                            let hairlineScan = hairlineScans[index]
                            ZStack {
                                Image(uiImage: hairlineScan.image)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: geometry.size.width * 1.2, height: geometry.size.height * 1.2)
                                    .clipped()
                                    .ignoresSafeArea()
                                    .edgesIgnoringSafeArea(.all)
                                
                                VStack {
                                    // Top bar with Xmark and hairline stage
                                    HStack {
                                        Button(action: {
                                            // Navigate to ContentView with selectedTab = 1
                                            selectedTab = 1
                                            shouldNavigateToMainOne = true
                                            HapticManager.instance.impact(style: .heavy)
                                        }) {
                                            Image(systemName: "xmark")
                                                .resizable()
                                                .frame(width: 24, height: 24)
                                                .foregroundColor(.white)
                                                .padding(.leading, 20)
                                        }
                                        
                                        Spacer()
                                        
                                        // Hairline scan result (e.g., "Stage 2")
                                        Text(hairlineScan.stage)
                                            .font(.headline)
                                            .foregroundColor(.white)
                                            .padding(.trailing, 20)
                                    }
                                    .frame(maxWidth: geometry.size.width, alignment: .top)
                                    .padding(.top, 50)
                                    
                                    Spacer()
                                }
                                .frame(width: geometry.size.width, height: geometry.size.height)
                            }
                        }
                    }
                    .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
                    .navigationBarHidden(true)
                }
            }
            .navigationDestination(isPresented: $shouldNavigateToMainOne) {
                ContentView(isOnboardingComplete: .constant(true), selectedTab: $selectedTab)
                    .environmentObject(ScanViewModel())
                    .transition(.move(edge: .bottom)) 
            }
        }
        .navigationBarHidden(true)
    }
}
 
#Preview {
    @Previewable @State var selectedTab = 0
    @Previewable @State var shouldNavigateToMain = false
    let exampleImage = UIImage(named: "example-image") ?? UIImage(systemName: "photo")!
    
    let hairlineScans = [
        HairlineScanMock(image: exampleImage, stage: "Stage 2"),
        HairlineScanMock(image: exampleImage, stage: "Stage 3")
    ]
    
    return ResultsGalleryView(
        hairlineScans: hairlineScans,
        selectedTab: $selectedTab,
        selectedIndex: 0
    )
}

// Mock structure to replace CoreData HairlineScan for preview
struct HairlineScanMock: Identifiable {
    let id = UUID()
    let image: UIImage
    let stage: String // Represents the hairline stage result
}
