//
//  ChangeGenderPopUpView.swift
//  hairapp
//
//  Created by Liam Syversen on 9/10/24.
//

import SwiftUI

struct ChangeGenderPopUpView: View {
    var gender: String

    var body: some View {
        VStack {
            HStack {
                // Check mark icon on the left
                Image(systemName: "checkmark.circle.fill")
                    .resizable()
                    .frame(width: 24, height: 24)
                    .foregroundColor(.green)
                    .padding(.trailing, 5)

                // Gender change text
                Text(gender)
                    .font(.headline)
                    .foregroundColor(.white)
            }
            .padding()
            .background(StyleConstants.buttonGradient) // Customizable color for the popup
            .cornerRadius(15)
            .shadow(radius: 5)
            .padding(.top, 50)
        }
        .frame(minWidth: 250)
    }
}

#Preview {
    ChangeGenderPopUpView(gender: "Gender changed to: Female")
} 

