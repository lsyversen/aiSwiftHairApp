//
//  DailyUpdateView.swift
//  hairapp
//
//  Created by Liam Syversen on 9/6/24.
//

import SwiftUI

struct DailyUpdateView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var scanViewModel: ScanViewModel
    @State private var selectedIndex: Int = -1 // Non-optional to control navigation
    @State private var showGalleryView: Bool = false
    @State private var showUploadView: Bool = false

    let columns = [GridItem(.flexible()), GridItem(.flexible())]

    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottomTrailing) {
                VStack(spacing: 20) {
                    // Custom Header
                    HStack {
                        Button(action: {
                            presentationMode.wrappedValue.dismiss()
                            HapticManager.instance.impact(style: .heavy)
                        }) {
                            Image(systemName: "xmark")
                                .resizable()
                                .frame(width: 24, height: 24)
                                .foregroundColor(.white)
                        }
                        Spacer()
                        Text("View Progress Pics")
                            .font(.title2)
                            .bold()
                            .foregroundColor(.white)
                        Spacer()
                        Image(systemName: "xmark")
                            .resizable()
                            .frame(width: 24, height: 24)
                            .foregroundColor(.clear)
                    }
                    .padding()
                    .background(StyleConstants.backgroundColor)

                    Spacer()

                    // Display the progress pics in grid or single layout
                    ScrollView {
                        if scanViewModel.progressPics.count == 1 {
                            // Single image view
                            VStack {
                                if let progressPic = scanViewModel.progressPics.first,
                                   let imageData = progressPic.image,
                                   let uiImage = UIImage(data: imageData) {
                                    Button(action: {
                                        selectedIndex = 0
                                        showGalleryView = true
                                    }) {
                                        ProgressPicCardView(image: uiImage, date: progressPic.date ?? Date())
                                    }
                                }
                            }
                            .padding()
                        } else {
                            // Grid layout for multiple images
                            LazyVGrid(columns: columns, spacing: 20) {
                                ForEach(scanViewModel.progressPics.indices, id: \.self) { index in
                                    if let imageData = scanViewModel.progressPics[index].image,
                                       let uiImage = UIImage(data: imageData) {
                                        Button(action: {
                                            selectedIndex = index
                                            showGalleryView = true
                                        }) {
                                            ProgressPicCardView(image: uiImage, date: scanViewModel.progressPics[index].date ?? Date())
                                        }
                                    }
                                }
                            }
                            .padding()
                        }
                    }
                }
                
                // Plus button in the bottom right
                Button(action: {
                    showUploadView = true
                }) {
                    ZStack {
                        Circle()
                            .fill(Color.white)
                            .frame(width: 60, height: 60)
                        Image(systemName: "plus")
                            .resizable()
                            .frame(width: 24, height: 24)
                            .foregroundColor(StyleConstants.buttonBackgroundColor)
                    }
                }
                .padding(.trailing, 30)
                .padding(.bottom, 30)
            }
            .background(StyleConstants.backgroundColor.edgesIgnoringSafeArea(.all))
            .fullScreenCover(isPresented: $showUploadView) {
                DailyUploadView()
                    .transition(.move(edge: .bottom))
            }
            .navigationDestination(isPresented: $showGalleryView) {
                DailyUploadsGalleryView(
                    progressPics: mapToProgressPicMock(),
                    selectedIndex: selectedIndex
                )
            }
            .navigationBarHidden(true)
            .onChange(of: selectedIndex) {
                if selectedIndex >= 0 {
                    print("Navigating to DailyUploadsGalleryView with index \(selectedIndex)")
                    showGalleryView = true
                }
            }
            .onAppear {
                showUploadView = false
                logProgressPics()
            }
        }

    }
    
    private func logProgressPics() {
        print("Logging progress pics:")
        for progressPic in scanViewModel.progressPics {
            print("Progress Pic - Date: \(progressPic.date ?? Date()), Image Size: \(progressPic.image?.count ?? 0) bytes")
        }
    }

    private func mapToProgressPicMock() -> [ProgressPicMock] {
        let mappedPics = scanViewModel.progressPics.compactMap { progressPic in
            if let imageData = progressPic.image, let uiImage = UIImage(data: imageData) {
                return ProgressPicMock(image: uiImage, date: progressPic.date ?? Date())
            }
            return nil
        }
        print("Mapped progress pictures count: \(mappedPics.count)")
        return mappedPics
    }
}

#Preview {
    NavigationView {
        DailyUpdateView()
            .environmentObject(ScanViewModel())
    }
}
