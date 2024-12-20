//
//  DailyUploadsGalleryView.swift
//  hairapp
//
//  Created by Liam Syversen on 9/7/24.
//

import SwiftUI

struct DailyUploadsGalleryView: View {
    @State var progressPics: [ProgressPicMock] // Use @State to manage data
    @Environment(\.presentationMode) var presentationMode
    @State var selectedIndex: Int // Selected image index to start with

    var body: some View {
        ZStack {
            GeometryReader { geometry in
                TabView(selection: $selectedIndex) {
                    ForEach(progressPics.indices, id: \.self) { index in
                        let progressPic = progressPics[index]
                        ZStack {
                            Image(uiImage: progressPic.image)
                                .resizable()
                                .scaledToFill() // Ensure the image fills the entire view
                                .frame(width: geometry.size.width * 1.2, height: geometry.size.height * 1.2) // Fill the entire view from the start
                                .clipped() // Clip any excess
                                .ignoresSafeArea()
                                .edgesIgnoringSafeArea(.all)

                            VStack {
                                // Top bar with Xmark and date
                                HStack {
                                    // Xmark button
                                    Button(action: {
                                        presentationMode.wrappedValue.dismiss()
                                        HapticManager.instance.impact(style: .heavy)
                                    }) {
                                        Image(systemName: "xmark")
                                            .resizable()
                                            .frame(width: 24, height: 24)
                                            .foregroundColor(.white)
                                            .padding(.leading, 20)
                                    }

                                    Spacer()

                                    // Date formatted in "Sep. 11" or "June 2" style
                                    Text(formattedDate(progressPic.date))
                                        .font(.headline)
                                        .foregroundColor(.white)
                                        .padding(.trailing, 20)
                                }
                                .frame(maxWidth: geometry.size.width, alignment: .top) // Ensure the HStack is properly positioned from the start
                                .padding(.top, 50) // Adjust the padding to control distance from the top

                                Spacer()
                            }
                            .frame(width: geometry.size.width, height: geometry.size.height) // Ensure the entire VStack fills the view properly
                        }
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always)) // Allow swiping between images
                .navigationBarHidden(true)
            }
        }
        .edgesIgnoringSafeArea(.all)
    }

    // Helper function to format date
    private func formattedDate(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM. d" // Format for "Sep. 11" or "June 2"
        return dateFormatter.string(from: date)
    }
}

#Preview {
    // Create mock ProgressPic data for preview
    let exampleImage = UIImage(named: "Example")!

    let progressPics = [
        ProgressPicMock(image: exampleImage, date: Date()),
        ProgressPicMock(image: exampleImage, date: Date().addingTimeInterval(-86400)) // One day ago
    ]

    // Provide mock data using @State
    return DailyUploadsGalleryView(progressPics: progressPics, selectedIndex: 0)
}

// Mock structure to replace CoreData ProgressPic for preview
struct ProgressPicMock: Identifiable {
    let id = UUID()
    let image: UIImage
    let date: Date
}
 
