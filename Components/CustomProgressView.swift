//
//  CustomProgressView.swift
//  hairapp
//
//  Created by Liam Syversen on 10/11/24.
//

import SwiftUI

struct CustomProgressView: View {
    var score: CGFloat // Accepts score as a number between 0 and 100

    var body: some View {
        ZStack(alignment: .leading) {
            // Background Capsule
            Capsule()
                .fill(Color.black.opacity(0.08))
                .frame(width: 100, height: 22)
            
            // Filled Capsule for the progress
            Capsule()
                .fill(colorForScore(self.score))
                .frame(width: 100 * (self.score / 100), height: 22) // Adjust width based on score
        }
    }
     
    // Determine color based on the score
    private func colorForScore(_ score: CGFloat) -> LinearGradient {
        let color: Color
        switch score {
        case ..<60:
            color = Color.red
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

struct CustomProgressView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            CustomProgressView(score: 45) // Example with a low score
                .previewLayout(.sizeThatFits)
                .padding()

            CustomProgressView(score: 80) // Example with the maximum score
                .previewLayout(.sizeThatFits)
                .padding()
        }
    }
}




