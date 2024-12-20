//
//  ProgressPicCardView.swift
//  hairapp
//
//  Created by Liam Syversen on 9/7/24.
//

import SwiftUI

struct ProgressPicCardView: View {
    var image: UIImage
    var date: Date

    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            Image(uiImage: image)
                .resizable()
                .scaledToFill()
                .frame(width: 125, height: 200)
                .clipShape(RoundedRectangle(cornerRadius: 20))

            // Date in the bottom right corner of the image
            Text(formattedDate(date: date))
                .font(.caption)
                .bold()
                .foregroundColor(.white)
                .padding(8)
                .background(Color.black.opacity(0.7))
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .padding([.bottom, .trailing], 10)
        }
        .frame(width: 125, height: 200) // Ensures the size of the card is fixed
        .clipShape(RoundedRectangle(cornerRadius: 20)) // Round the corners of the image and card
    }

    private func formattedDate(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d"
        return dateFormatter.string(from: date)
    }
}

#Preview {
    ProgressPicCardView(image: UIImage(named: "Example")!, date: Date())
}


