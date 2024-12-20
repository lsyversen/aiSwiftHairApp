//
//  ContentView.swift
//  hairapp
//
//  Created by Liam Syversen on 9/4/24.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @State private var isSettingsPresented = false
    @EnvironmentObject var scanViewModel: ScanViewModel
    @Binding var isOnboardingComplete: Bool
    @State private var showCoachMessenger = false
    @State private var selectedCoachTitle: String? = nil
    @State private var initialMessage: String = ""
    @Binding var selectedTab: Int
    @State private var showGenderPopup = false
    @State private var genderPopupText: String = ""
    @State private var navigationPath = NavigationPath()

    init(isOnboardingComplete: Binding<Bool>, selectedTab: Binding<Int>) {
        _isOnboardingComplete = isOnboardingComplete
        _selectedTab = selectedTab
        UITabBar.appearance().backgroundColor = UIColor(StyleConstants.backgroundColor)
        UITabBar.appearance().unselectedItemTintColor = UIColor.white
    }

    var body: some View {
        NavigationStack(path: $navigationPath) {
            ZStack {
                StyleConstants.backgroundColor
                    .ignoresSafeArea(.keyboard, edges: .bottom)

                VStack(spacing: 0) {
                    TabView(selection: $selectedTab) {
                        ScanView(isSettingsPresented: $isSettingsPresented, selectedTab: $selectedTab)
                            .environmentObject(scanViewModel)
                            .tabItem {
                                Image(systemName: "camera.fill")
                                Text("Scan")
                            }
                            .tag(0)

                        ResultsView(isSettingsPresented: $isSettingsPresented, selectedTab: $selectedTab, isOnboardingComplete: $isOnboardingComplete)
                            .environmentObject(scanViewModel)
                            .tabItem {
                                Image(systemName: "bubbles.and.sparkles")
                                Text("Results")
                            }
                            .tag(1)

                        DailyView(isSettingsPresented: $isSettingsPresented)
                            .environmentObject(scanViewModel)
                            .tabItem {
                                Image(systemName: "calendar")
                                Text("Daily")
                            }
                            .tag(2)

                        CoachView(
                            isSettingsPresented: $isSettingsPresented,
                            showCoachMessenger: $showCoachMessenger,
                            selectedCoachTitle: $selectedCoachTitle,
                            initialMessage: $initialMessage
                        )
                            .tabItem {
                                Image(systemName: "rectangle.and.pencil.and.ellipsis")
                                Text("Coach")
                            }
                            .tag(3)
                    }
                }

                if showGenderPopup {
                    VStack {
                        ChangeGenderPopUpView(gender: genderPopupText)
                            .transition(.move(edge: .top))
                            .zIndex(1)
                        Spacer()
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.clear)
                }

                if isSettingsPresented {
                    Color.black.opacity(0.4)
                        .ignoresSafeArea()
                        .onTapGesture {
                            withAnimation {
                                isSettingsPresented = false
                            }
                        }

                    SettingsMenuView(
                        isPresented: $isSettingsPresented,
                        isOnboardingComplete: $isOnboardingComplete,
                        showGenderPopup: $showGenderPopup,
                        genderPopupText: $genderPopupText
                    )
                        .transition(.move(edge: .bottom))
                        .animation(.easeInOut, value: isSettingsPresented)
                }
            }
            .navigationDestination(for: CombinedScan.self) { scan in
                destinationView(for: scan)
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(true)
    }

    @ViewBuilder
    private func destinationView(for scan: CombinedScan) -> some View {
        switch scan.type {
        case .hairRating(let hairScan):
            ScanRatingsTabView(
                selectedTab: $selectedTab,
                shouldNavigateToMain: .constant(false),
                scan: hairScan
            )
        case .hairline(let hairlineScan):
            ResultsGalleryView(
                hairlineScans: [
                    HairlineScanMock(
                        image: UIImage(data: hairlineScan.hairlineImageData ?? Data()) ?? UIImage(),
                        stage: hairlineScan.hairlossStage ?? "Unknown Stage"
                    ),
                    HairlineScanMock(
                        image: UIImage(data: hairlineScan.topOfHeadImageData ?? Data()) ?? UIImage(),
                        stage: hairlineScan.hairlossStage ?? "Unknown Stage"
                    )
                ],
                selectedTab: $selectedTab,
                selectedIndex: 0
            )
        default:
            Text("Unknown Scan Type")
        }
    }
}

#Preview {
    @Previewable @State var selectedTab = 0
    let persistentContainer = PersistenceController.shared.container
    let context = persistentContainer.viewContext
    
    // Mock environment objects
    let mockScanViewModel = ScanViewModel(context: context)
    let mockStoreManager = StoreManager()
    
    ContentView(isOnboardingComplete: .constant(true), selectedTab: $selectedTab)
        .environmentObject(mockScanViewModel)
        .environmentObject(mockStoreManager)
        .environment(\.managedObjectContext, context)
}



