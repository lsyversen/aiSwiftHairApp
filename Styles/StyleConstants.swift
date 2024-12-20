//
//  StyleConstants.swift
//  hairapp
//
//  Created by Liam Syversen on 9/4/24.
//

import SwiftUI

struct StyleConstants {
    static let backgroundColor = Color(hex: "#1a1a1a")
    static let textGradient = LinearGradient(
        gradient: Gradient(colors: [Color(hex: "#f9ac51"), Color(hex: "#d92e4f"), Color(hex: "#6e509d")]),
        startPoint: .leading,
        endPoint: .trailing
    )
    // New gradient background for ScanRatingsCardView
        static let greenGradientBackground = LinearGradient(
            gradient: Gradient(colors: [Color(hex: "#1b5e20"), Color(hex: "#2e7d32"), Color(hex: "#66bb6a")]),
            startPoint: .top,
            endPoint: .bottom
        )
    static let buttonBackgroundColor = Color(hex: "#0e6251")
    static let discordColor = Color(hex: "#5765ec")
    static let buttonGradient = LinearGradient(
           gradient: Gradient(colors: [Color(hex: "#0e6251"), Color(hex: "#28a745"), Color(hex: "#9cd9a0")]), // Dark green to lighter green shades
           startPoint: .topLeading,
           endPoint: .bottomTrailing
       )
}
