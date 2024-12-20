//
//  faceShapeView.swift
//  hairapp
//
//  Created by Liam Syversen on 10/14/24.
//

import SwiftUI

struct FaceShapeView: View {
    @EnvironmentObject var scanViewModel: ScanViewModel // To fetch scans
    @State private var recommendedStyles: [HairStyle] = []
    @Environment(\.dismiss) private var dismiss // Environment dismiss to handle back navigation
    @State private var faceShape: String = "Unknown"
    @State private var hairType: String = "Unknown"
    @State private var gender: String = UserDefaults.standard.string(forKey: "selectedGender") ?? "Male"
    @State private var isContentViewActive = false // Track navigation state
    private let hairStyleGenerator = GenerateHairStyle()

    var body: some View {
        ZStack {
            VStack {
                // Custom Header
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
                    Text("\(getFaceShape()) Face Shape")
                        .font(.title2)
                        .bold()
                        .foregroundColor(.white)
                    Spacer()
                    Image(systemName: "xmark")
                        .resizable()
                        .frame(width: 24, height: 24)
                        .foregroundColor(.clear)
                }
                .padding()
                .background(StyleConstants.backgroundColor.edgesIgnoringSafeArea(.all))

                ScrollView {
                    VStack(spacing: 20) {
                        
                        // Display the face shape image dynamically based on the user's face shape
                        faceShapeImage(for: faceShape)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 300, height: 300)
                            .cornerRadius(30)
                        
                        HStack(alignment: .top) {
                            // Face Shape Description
                            Text(faceShapeDescription(for: faceShape))
                                .font(.system(size: 21))
                                .foregroundColor(.gray)
                                .multilineTextAlignment(.center)
                                .padding()
                        }
                        .padding()
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(30)
                        
                        // Best and Worst Haircuts Section
                        VStack {
                            HStack(alignment: .top, spacing: 50) {
                                // Best Haircuts
                                VStack {
                                    Text("BEST")
                                        .font(.system(size: 35))
                                        .bold()
                                        .foregroundColor(.green)

                                    ForEach(bestHaircuts(for: faceShape, gender: gender), id: \.self) { haircut in
                                        HStack {
                                            Text("•")
                                                .font(.system(size: 30))
                                                .foregroundColor(.white)
                                            Text(haircut)
                                                .font(.system(size: 20))
                                                .foregroundColor(.white)
                                                .multilineTextAlignment(.center)
                                        }
                                    }
                                }

                                // Worst Haircuts
                                VStack {
                                    Text("WORST")
                                        .font(.system(size: 35))
                                        .bold()
                                        .foregroundColor(.red)

                                    ForEach(worstHaircuts(for: faceShape, gender: gender), id: \.self) { haircut in
                                        HStack {
                                            Text("•")
                                                .font(.system(size: 30))
                                                .foregroundColor(.white)
                                            Text(haircut)
                                                .font(.system(size: 20))
                                                .foregroundColor(.white)
                                                .multilineTextAlignment(.center)
                                        }
                                    }
                                }
                            }
                            .padding()
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(30)
                        }
                        .padding([.horizontal, .bottom])
                    }
                    Spacer()
                }
            }
            .background(StyleConstants.backgroundColor.edgesIgnoringSafeArea(.all))
            .navigationBarHidden(true)
            .onAppear {
                fetchLatestScanAndGenerateRecommendations()
            }
        }
    }

    // Function to dynamically fetch the face shape image
    private func faceShapeImage(for faceShape: String) -> Image {
        switch faceShape.lowercased() {
        case "oval":
            return Image("oval")
        case "round":
            return Image("round")
        case "square":
            return Image("square")
        case "oblong":
            return Image("oblong")
        case "rectangular":
            return Image("rectangle")
        case "diamond":
            return Image("diamond")
        case "triangular", "triangle":
            return Image("triangle")
        case "heart":
            return Image("heart")
        default:
            return Image("face_default") // A default image in case the face shape isn't recognized
        }
    }

    private func getFaceShape() -> String {
        return scanViewModel.scans.last?.faceShape ?? "Unknown"
    }
    
    // Function to fetch the latest scan and generate recommendations
    func fetchLatestScanAndGenerateRecommendations() {
        if let latestScan = scanViewModel.scans.last {
            faceShape = latestScan.faceShape ?? "Unknown"
            hairType = latestScan.hairtype ?? "Unknown"
        }
        recommendedStyles = hairStyleGenerator.fetchRecommendations(for: faceShape, hairType: hairType, gender: gender)
    }

    // Function to return a brief description of the face shape
    func faceShapeDescription(for faceShape: String) -> String {
        switch faceShape.lowercased() {
        case "oval":
            return "The oval face shape is considered ideal by many stylists because it's well-balanced and proportions allow for a lot of haircut versatility."
        case "round":
            return "Round faces benefit from hairstyles that add height and structure to elongate the appearance."
        case "square":
            return "Square faces are complemented by hairstyles that soften the jawline and add texture."
        case "rectangular":
            return "A rectangular face shape is longer than it is wide and often has a strong jawline."
        case "oblong":
            return "A oblong face shape is longer than it is wide and often has a strong jawline."
        case "diamond":
            return "Diamond faces can benefit from styles that add width to the forehead and soften the cheekbones."
        case "triangular", "pear":
            return "For a triangular face shape, the goal is to create balance by adding volume to the top and sides of the head."
        case "heart":
            return "Heart-shaped faces benefit from softening the forehead while adding volume around the jawline."
        default:
            return "No specific recommendations available for this face shape."
        }
    }
    
    // Function to get best haircuts based on face shape and gender
    func bestHaircuts(for faceShape: String, gender: String) -> [String] {
        switch faceShape.lowercased() {
        case "oval":
            return gender.lowercased() == "male" ? ["Buzz Cut", "Slicked Back", "Mullet", "Taper Fade"] : ["Long Layers", "Bob Cut", "Side Part"]
        case "round":
            return gender.lowercased() == "male" ? ["Quiff", "Faux Hawk", "Undercut"] : ["Layered Pixie", "Side-Swept Bangs", "Long Waves"]
        case "square":
            return gender.lowercased() == "male" ? ["Textured Crop", "Crew Cut", "Side Part"] : ["Shoulder-Length Waves", "Soft Curls", "Textured Bob"]
        case "rectangular", "oblong":
            return gender.lowercased() == "male" ? ["Side Swept", "Classic Taper", "Short Fringe"] : ["Soft Waves", "Long Layers", "Curtain Bangs"]
        case "diamond":
            return gender.lowercased() == "male" ? ["Messy Fringe", "Tapered Sides", "Textured Crop"] : ["Chin-Length Bob", "Side-Swept Bangs", "Layered Curls"]
        case "triangular", "pear":
            return gender.lowercased() == "male" ? ["Comb Over", "Textured Fringe", "Pompadour"] : ["Long Layers", "Curtain Bangs", "Wavy Bob"]
        case "heart":
            return gender.lowercased() == "male" ? ["Side Part", "Surfer Hair", "Short Fringe"] : ["Layered Waves", "Side Bangs", "Soft Bob"]
        default:
            return ["No specific recommendations"]
        }
    }

    // Function to get worst haircuts based on face shape and gender
    func worstHaircuts(for faceShape: String, gender: String) -> [String] {
        switch faceShape.lowercased() {
        case "oval":
            return gender.lowercased() == "male" ? ["Heavy Fringe", "Flat Top", "R9 Haircut"] : ["Straight Bob", "Blunt Fringe"]
        case "round":
            return gender.lowercased() == "male" ? ["Slicked Back", "Bowl Cut"] : ["Blunt Cut", "Heavy Bangs"]
        case "square":
            return gender.lowercased() == "male" ? ["Blunt Cut", "Buzz Cut"] : ["Straight Blunt", "Flat Cut"]
        case "rectangular", "oblong":
            return gender.lowercased() == "male" ? ["Flat Top", "Long Straight Hair"] : ["Straight Long Hair", "Pixie Cut"]
        case "diamond":
            return gender.lowercased() == "male" ? ["Buzz Cut", "Heavy Bangs"] : ["Flat Fringe", "Blunt Bob"]
        case "triangular", "pear":
            return gender.lowercased() == "male" ? ["Straight Bob", "Chin-Length Cut"] : ["Heavy Bangs", "Straight Bob"]
        case "heart":
            return gender.lowercased() == "male" ? ["Bowl Cut", "Buzz Cut"] : ["Heavy Bangs", "Straight Bob"]
        default:
            return ["No specific recommendations"]
        }
    }
}


// Sample scan for preview
#Preview {
    @Previewable @State var selectedTab = 1
    @Previewable @State var shouldNavigateToMain = false
    let context = PersistenceController.shared.container.viewContext
    let sampleScan = ScanResult(context: context)
    

    // Set sample values for the scan
    sampleScan.overall = 85.0
    sampleScan.potential = 90.0
    sampleScan.frizzlevel = 80.0
    sampleScan.hairdensity = 75.0
    sampleScan.shine = 88.0
    sampleScan.volume = 82.0
    sampleScan.hairthickness = "Thick"
    sampleScan.haircolor = "Dark brown"
    sampleScan.hairtype = "Wavy"
    sampleScan.faceShape = "Oblong"

    let scanViewModel = ScanViewModel(context: context)
    scanViewModel.scans = [sampleScan] // Set the sample scan to the view model

    return FaceShapeView()
        .environmentObject(scanViewModel)
}


