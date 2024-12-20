//
//  SaveNotificationPopUpView.swift
//  hairapp
//
//  Created by Liam Syversen on 10/6/24.
//

import SwiftUI

struct SaveNotificationPopUpView: View {
    var message: String

    var body: some View {
        VStack {
            HStack {
                // Check mark icon on the left
                Image(systemName: "checkmark.circle.fill")
                    .resizable()
                    .frame(width: 24, height: 24)
                    .foregroundColor(.green)
                    .padding(.trailing, 5)

                // Notification message text
                Text(message)
                    .font(.headline)
                    .foregroundColor(.white)
            }
            .padding()
            .background(StyleConstants.buttonGradient) // Customize color as desired
            .cornerRadius(15)
            .shadow(radius: 5)
            .padding(.top, 50)
        }
        .frame(minWidth: 250)
    }
}

#Preview {
    SaveNotificationPopUpView(message: "Image saved to Camera Roll")
}

