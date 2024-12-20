//
//  hairappApp.swift
//  hairapp
//
//  Created by Liam Syversen on 9/4/24.
//
 
import SwiftUI

@main
struct hairappApp: App {
    @State private var isOnboardingComplete: Bool = UserDefaults.standard.bool(forKey: "isOnboardingComplete")
    @StateObject private var scanViewModel = ScanViewModel()
    @StateObject private var storeManager = StoreManager()
    @State private var selectedTab: Int = 0 // Add a state for selectedTab

    var body: some Scene {
        WindowGroup {
            if isOnboardingComplete {
                ContentView(isOnboardingComplete: $isOnboardingComplete, selectedTab: $selectedTab)
                    .environmentObject(scanViewModel)
                    .environmentObject(storeManager)
            } else {
                OnboardingView(isOnboardingComplete: $isOnboardingComplete)
                    .environmentObject(scanViewModel)
                    .environmentObject(storeManager)
            }
        }
    }
}


