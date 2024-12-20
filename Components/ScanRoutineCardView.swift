//
//  ScanRoutineCardView.swift
//  hairapp
//
//  Created by Liam Syversen on 10/11/24.
//

import SwiftUI

struct ScanRoutineCardView: View {
    let routineItems: [RoutineItem]
    @Binding var selectedTab: Int
    @Binding var shouldNavigateToMain: Bool
    @State private var checkedItems: Set<String> = [] // Track checked routine items
    @State private var selectedRoutineItem: RoutineItem? = nil // Track the selected item for detailed view
    @State private var showRoutineInfoView: Bool = false // Control showing the RoutineItemInfoView
    @State private var showRecommendedHairView: Bool = false // Control showing the RecommendedHairView
    @State private var showFaceShapeView: Bool = false // New state for RoutineHairTypeView
    @State private var showRoutineHairTypeView: Bool = false // New state for RoutineHairTypeView
    @State private var showHairPorosityView: Bool = false // New state for HairPorosityTestView
    @AppStorage("selectedGender") private var selectedGender: String = "Male" // Observe gender changes
    @EnvironmentObject var scanViewModel: ScanViewModel

    var body: some View {
        NavigationStack {
            ZStack {
                VStack {
                    ZStack {
                        VStack {
                            Spacer().frame(height: 30)
                            
                            if routineItems.isEmpty {
                                Text("Complete a scan to generate your custom routine.")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                    .padding(.horizontal)
                                    .padding(.top, 10)
                            } else {
                                HStack {
                                    Spacer()
                                    Text("Start Improving ✅")
                                        .font(.title)
                                        .bold()
                                        .foregroundColor(.white)
                                        .padding(.horizontal, 20)
                                    Spacer()
                                }
                                ScrollView {
                                    VStack(alignment: .leading, spacing: 10) {
                                        
                                        RoutineItemView(
                                            item: "Recommended Hairstyles",
                                            emoji: "✂️",
                                            isChecked: checkedItems.contains(" Hair Type")) {
                                            toggleCheckmark(for: "Hair Type")
                                        }
                                        .onTapGesture {
                                            HapticManager.instance.impact(style: .heavy)
                                            showRecommendedHairView = true
                                        }
                                        
                                        // Face Shape Routine Item
                                        if let faceShape = getFaceShape() {
                                            RoutineItemView(
                                                item: "\(faceShape) Face Shape",
                                                emoji: getEmojiTwo(for: selectedGender),
                                                isChecked: checkedItems.contains("\(faceShape) Face Shape")) {
                                                toggleCheckmark(for: "\(faceShape) Face Shape")
                                            }
                                            .onTapGesture {
                                                HapticManager.instance.impact(style: .heavy)
                                                showFaceShapeView = true
                                            }
                                        }
                                            RoutineItemView(
                                                item: "\(getHairType()) Hair Type",
                                                emoji: getEmoji(for: selectedGender),
                                                isChecked: checkedItems.contains(" Hair Type")) {
                                                toggleCheckmark(for: "Hair Type")
                                            }
                                            .onTapGesture {
                                                HapticManager.instance.impact(style: .heavy)
                                                showRoutineHairTypeView = true
                                            }
                                        
                                        
                                        ForEach(routineItems) { item in
                                            RoutineItemView(
                                                item: item.title,
                                                emoji: item.emoji,
                                                isChecked: checkedItems.contains(item.title)) {
                                                toggleCheckmark(for: item.title)
                                            }
                                            .onTapGesture {
                                                HapticManager.instance.impact(style: .heavy)
                                                if item.title == "\(String(describing: getFaceShape())) Face Shape" {
                                                    showFaceShapeView = true
                                                } else if item.title == "\(getHairType()) Hair Type" {
                                                    showRoutineHairTypeView = true
                                                } else if item.title == "Hair Porosity Test" {
                                                    showHairPorosityView = true
                                                } else if item.title == "Recommended Hairstyles" {
                                                    showRecommendedHairView = true
                                                } else {
                                                    selectedRoutineItem = item
                                                    showRoutineInfoView = true
                                                }
                                            }
                                        }
                                        RoutineItemView(
                                            item: "Hair Porosity Test",
                                            emoji: "🧪",
                                            isChecked: checkedItems.contains(" Hair Type")) {
                                            toggleCheckmark(for: "Hair Type")
                                        }
                                        .onTapGesture {
                                            HapticManager.instance.impact(style: .heavy)
                                            showHairPorosityView = true
                                        }
                                        
                                    }
                                    .padding(.horizontal)
                                    .padding(.top, 10)
                                }
                            }
                            Image("app-name")
                                .resizable()
                                .scaledToFit()
                                .frame(height: 50)
                                .padding(.top, 10)
                            
                            Spacer()
                        }
                        .background(StyleConstants.backgroundColor)
                        .cornerRadius(30)
                        .frame(maxWidth: 350, minHeight: 475)
                        .shadow(radius: 5)
                        .padding(.top, 60)
                        .padding(.bottom, 60)
                    }
                    
                    Spacer()
                    
                    // Continue Button
                    Button(action: {
                        selectedTab = 1
                        shouldNavigateToMain = true
                    }) {
                        Text("Continue")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: 350)
                            .background(StyleConstants.buttonGradient)
                            .cornerRadius(30)
                            .padding(.horizontal, 10)
                    }
                    .padding(.bottom, 20)
                }
                .fullScreenCover(isPresented: $showRoutineInfoView) {
                    RoutineInfoContent(selectedRoutineItem: $selectedRoutineItem)
                }
                .fullScreenCover(isPresented: $showRecommendedHairView) {
                    ZStack {
                        RecommendedHairView()
                            .transition(.move(edge: .bottom)) // Slide up transition
                    }
                }
                .fullScreenCover(isPresented: $showFaceShapeView) {
                    ZStack {
                        FaceShapeView()
                            .transition(.move(edge: .bottom)) // Slide up transition
                    }
                }
                .fullScreenCover(isPresented: $showRoutineHairTypeView) {
                    ZStack {
                        RoutineHairTypeView()
                        .transition(.move(edge: .bottom)) // Slide up transition
                    }
                }
                .fullScreenCover(isPresented: $showHairPorosityView) {
                    ZStack {
                        HairPorosityTestView()
                            .transition(.move(edge: .bottom)) // Slide up transition
                    }
                }
            }
        }
    }
    
    private func toggleCheckmark(for item: String) {
        if checkedItems.contains(item) {
            checkedItems.remove(item)
        } else {
            checkedItems.insert(item)
        }
    }
    
    private func getFaceShape() -> String? {
        return scanViewModel.scans.last?.faceShape
    }
    
    private func getHairType() -> String {
        return scanViewModel.scans.last?.hairtype ?? "Unknown"
    }
    
    private func getEmoji(for gender: String) -> String {
        return gender.lowercased() == "female" ? "💇‍♀️" : "💇‍♂️"
    }
    
    private func getEmojiTwo(for gender: String) -> String {
        return gender.lowercased() == "female" ? "👩" : "🧑"
    }
}

struct RoutineInfoContent: View {
    @Binding var selectedRoutineItem: RoutineItem?

    var body: some View {
        if let routine = selectedRoutineItem {
            RoutineItemInfoView(title: routine.title, descriptions: routine.description)
        } else {
            VStack {
                Text("Error: No routine item selected")
                    .foregroundColor(.red)
                    .padding()
            }
            .onAppear {
                print("Error in RoutineInfoContent: selectedRoutineItem is nil")
            }
        }
    }
}

struct RoutineItemView: View {
    var item: String
    var emoji: String
    var isChecked: Bool
    var toggleCheckmark: () -> Void
    
    var body: some View {
        HStack {
            Text(emoji)
                .font(.largeTitle)
                .padding(.trailing, 10)
            Text(item)
                .font(.headline)
                .foregroundColor(.white)
            Spacer()
            Image(systemName: "chevron.right")
                .foregroundColor(.white)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color.gray.opacity(0.3))
        .cornerRadius(30)
        .padding(.horizontal, 2)
    }
}


// Preview for ScanRoutineCardView
#Preview {
    @Previewable @State var selectedTab = 0
    @Previewable @State var shouldNavigateToMain = false
    let sampleRoutineItems = [
        RoutineItem(emoji: "✂️", title: "Haircuts Regularly", description: ["Getting regular trims helps remove split ends.", "It ensures hair stays healthy for better growth.", "Regular haircuts improve overall appearance."], productLinks: nil),
        RoutineItem(emoji: "🧴", title: "Shampoo/Moisturize", description: ["Use sulfate-free shampoo to maintain natural oils.", "Follow with a conditioner for moisture.", "Choose products suitable for your hair type."], productLinks: nil),
        RoutineItem(emoji: "🌬", title: "Frizz Control", description: ["Use anti-frizz serums to smooth cuticles.", "Avoid over-brushing hair to reduce frizz.", "Consider moisturizing products for frizz control."], productLinks: nil)
    ]
    let context = PersistenceController.shared.container.viewContext
    let scanViewModel = ScanViewModel(context: context)
    
    return ScanRoutineCardView(
        routineItems: sampleRoutineItems,
        selectedTab: $selectedTab,
        shouldNavigateToMain: $shouldNavigateToMain
    )
    .environmentObject(scanViewModel)
    .padding()
}

