//
//  LoadingHairstyleView.swift
//  hairapp
//
//  Created by Liam Syversen on 10/16/24.
//

import SwiftUI

struct LoadingHairstyleView: View {
    let tryOnHairstyle: TryOnHairstyle
    @State private var showMenu = false // State to trigger the menu display
    @State private var showSaveNotification = false // State to show save confirmation

    var body: some View {
        ZStack {
            // Display the generated hairstyle image
            if let imageData = tryOnHairstyle.beforeImage, let image = UIImage(data: imageData) {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 300, height: 300)
                    .cornerRadius(10)
                    .overlay(
                        LinearGradient(gradient: Gradient(colors: [Color.clear, Color.black.opacity(0.7)]),
                                       startPoint: .center, endPoint: .bottom)
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 30))
                    .onTapGesture {
                        showMenu = true // Show the menu when the image is tapped
                    }
                    .overlay(
                        VStack {
                            Spacer()
                            CircleFlip()
                                .frame(width: 60, height: 60)
                            Spacer()
                        }
                    )
            }
        }
        .shadow(radius: 5)
        .padding()
    }
}

struct CustomProgressViewTwo: View {
    var score: CGFloat // Accepts score as a number between 0 and 100

    var body: some View {
        ZStack(alignment: .leading) {
            // Background Capsule
            Capsule()
                .fill(Color.black)
                .frame(width: 250, height: 22)
            
            // Filled Capsule for the progress
            Capsule()
                .fill(colorForScore(self.score))
                .frame(width: 250 * (self.score / 100), height: 22) // Adjust width based on score
        }
    }
     
    // Determine color based on the score
    private func colorForScore(_ score: CGFloat) -> LinearGradient {
        let color: Color
        switch score {
        case ..<60:
            color = Color.green
        case 60..<70:
            color = Color.orange
        case 70..<80:
            color = Color.yellow
        case 80..<90:
            color = Color.green.opacity(0.6)
        default:
            color = Color.green.opacity(1.0)
        }
        return LinearGradient(
            gradient: Gradient(colors: [color.opacity(0.6), color]),
            startPoint: .leading,
            endPoint: .trailing
        )
    }
}

#Preview {
    let context = PersistenceController.shared.container.viewContext
    
    // Creating a mock TryOnHairstyle object
    let mockTryOnHairstyle = TryOnHairstyle(context: context)
    mockTryOnHairstyle.hairstyle = "Curly Afro"
    mockTryOnHairstyle.beforeImage = UIImage(named: "hairstylesample")?.pngData() // Load the image from assets

    return LoadingHairstyleView(tryOnHairstyle: mockTryOnHairstyle)
        .environment(\.managedObjectContext, context)
}
