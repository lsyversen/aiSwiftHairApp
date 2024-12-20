//
//  RoutineHairTypeView.swift
//  hairapp
//
//  Created by Liam Syversen on 10/12/24.
//

import SwiftUI

struct RoutineHairTypeView: View {
    @Environment(\.dismiss) private var dismiss // Environment dismiss to handle back navigation
    @EnvironmentObject var scanViewModel: ScanViewModel // Access the ScanViewModel
    
    private func getHairType() -> String {
        return scanViewModel.scans.last?.hairtype ?? "Unknown"
    }

    // Sample products for each hair type
    private var recommendedProducts: [ProductLink] {
        switch getHairType() {
        case "Straight":
            return [
                ProductLink(name: "Texture Powder", imageName: "texturepowder", url: "https://www.amazon.com/gp/product/B0CXLYHYHN/ref=ewc_pr_img_2?smid=A330SBD214O4BU&psc=1")
            ]
        case "Wavy":
            return [
                ProductLink(name: "Sea Salt Spray", imageName: "seasalt", url: "https://www.amazon.com/gp/product/B0DCWLLKRS/ref=ewc_pr_img_1?smid=A330SBD214O4BU&psc=1")
            ]
        case "Curly":
            return [
                ProductLink(name: "Shower Filter", imageName: "showerfilter", url: "https://www.amazon.com/AquaBliss-Output-12-Stage-Shower-Filter/dp/B01MUBU0YC/ref=sr_1_5?crid=26VVXRI3X01QO&dib=eyJ2IjoiMSJ9.9meMwRpqRkskxk26qqHdRd6zIQv7NRn7MjyxybHXWdI5_hTMInpEhL4BkbG1mMsltbcUELDQ8B9LjECPS9oL780dnRIIV56vmMEPxlUz6tjoXfm8m8PPVsIRhKsf8ZA9Ruh4tO3mAImfFb3Km3meZeW7aM6mCIaGa3oMbKFiKvG1N7yJPi-wdhnyMtAHrzu1gGKiN6YJynhZSSC8ss6Gn8aOG_uzGys9EiKkMuZwa3_EeX3cTYcpVWmZeuvcwA_ykO6V5b3Ma6S1rh9Fs2N0r3jmnXm7-vOb2RUse6idhB4.X7G8_9jqm4uoHr9KT-wZ0KInru6TPvOYDhDo8Y62xjU&dib_tag=se&keywords=shower+filter&qid=1728883548&sprefix=shower+fi%2Caps%2C103&sr=8-5")
            ]
        case "Coily":
            return [
                ProductLink(name: "Satin Pillowcase", imageName: "pillowcase", url: "https://www.amazon.com/Bedsure-Satin-Pillowcase-Hair-2-Pack/dp/B07H23HFGZ/ref=sr_1_5?crid=HC8WVFPSZ6XB&dib=eyJ2IjoiMSJ9.RfUPbUEwnf6xir05O1wf2bJ0fpfFVUGUMvmTjbaK7VvpA4zQlDTzzYKJBgScjdA8B0308HaMBrN559DenwvjRsEqAd5hWSpa0E6h4yFkjtkxqCMjZPiH39eIUmOY_hnfqgQiTvdOH0lPGPW_aMgNLqQon3BK1mMUoOmF0f-ZqR8wGQyAn11fTaMByZS6LyYGeh8cc8k09R2IvwTQRIjH6BEU4g1M9Ii2B4vq9_If4V8qu0XUjL6PrqxRLkJEmmatnLJoOKE2Cxlqw76M-ZtH7VkANKEd6D1MZ-06VqCf2zc.uJfvYg_V1fJmeNDKgqMVXqZiXSQACAW-r7TghY1nOyw&dib_tag=se&keywords=satin%2Bpillowcase&qid=1728883572&sprefix=sat%2Caps%2C124&sr=8-5&th=1")
            ]
        default:
            return []
        }
    }
    
    var body: some View {
        ZStack {
            StyleConstants.backgroundColor
                .edgesIgnoringSafeArea(.all)

            VStack {
                // Custom Header with back button
                HStack {
                    Button(action: {
                        dismiss() // Dismiss the view
                        HapticManager.instance.impact(style: .heavy)
                    }) {
                        Image(systemName: "xmark")
                            .resizable()
                            .frame(width: 24, height: 24)
                            .foregroundColor(.white)
                    }
                    Spacer()
                    Text("\(getHairType()) Hair Tips")
                        .font(.title2)
                        .bold()
                        .foregroundColor(.white)
                    Spacer()
                    Image(systemName: "xmark")
                        .resizable()
                        .frame(width: 24, height: 24)
                        .foregroundColor(.clear) // For symmetry
                }
                .padding()
                .background(StyleConstants.backgroundColor)

                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        if getHairType() == "Straight" {
                            hairTypeTips(title: "Hair Care Tips", tips: [
                                "Use lightweight, non-greasy products to avoid weighing down your hair.",
                                "Avoid over-washing, as it can strip natural oils and make hair appear greasy.",
                                "Use a shine serum to enhance your hair's natural gloss and keep it looking sleek."
                            ])
                        } else if getHairType() == "Wavy" {
                            hairTypeTips(title: "Hair Care Tips", tips: [
                                "Use a lightweight mousse or sea salt spray to define waves without weighing them down.",
                                "Avoid excessive brushing, which can disrupt the wave pattern and cause frizz.",
                                "Diffuse-dry or air-dry your hair to preserve the natural wave pattern."
                            ])
                        } else if getHairType() == "Curly" {
                            hairTypeTips(title: "Hair Care Tips", tips: [
                                "Use a leave-in conditioner and curl cream to enhance and define your curls.",
                                "Avoid touching your hair while it dries to minimize frizz and maintain curl shape.",
                                "Opt for a microfiber towel or t-shirt to dry your hair, which reduces frizz."
                            ])
                        } else if getHairType() == "Coily" {
                            hairTypeTips(title: "Hair Care Tips", tips: [
                                "Deep condition regularly to keep your curls moisturized and reduce breakage.",
                                "Avoid using heat styling tools frequently, as coily hair is prone to dryness.",
                                "Use the LOC method (Liquid, Oil, Cream) to lock in moisture for longer-lasting hydration."
                            ])
                        } else {
                            Text("No specific care tips available for this hair type.")
                                .font(.headline)
                                .foregroundColor(.white)
                                .padding()
                                .background(Color.gray.opacity(0.2))
                                .cornerRadius(15)
                        }

                        // Recommended Products Section
                        if !recommendedProducts.isEmpty {
                            Text("Recommended Products")
                                .font(.title2)
                                .bold()
                                .foregroundColor(.white)
                                .padding(.top, 20)

                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 15) {
                                    ForEach(recommendedProducts) { product in
                                        VStack {
                                            Button(action: {
                                                if let url = URL(string: product.url) {
                                                    UIApplication.shared.open(url)
                                                }
                                            }) {
                                                Image(product.imageName)
                                                    .resizable()
                                                    .scaledToFit()
                                                    .frame(width: 100, height: 100)
                                                    .cornerRadius(15)
                                                    .shadow(radius: 5)
                                            }
                                            Text(product.name)
                                                .font(.caption)
                                                .foregroundColor(.white)
                                        }
                                    }
                                }
                                .padding(.horizontal)
                            }
                        }
                    }
                    .padding()
                }
                Spacer()
            }
        }
        .navigationBarHidden(true)
        .transition(.move(edge: .bottom)) // Add slide-up transition
    }
    
    // Helper function to display tips for a specific hair type
    private func hairTypeTips(title: String, tips: [String]) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            // Each Tip on Separate Card
            ForEach(tips, id: \.self) { tip in
                HStack(alignment: .top) {
                    Text("•")
                        .font(.system(size: 20))
                        .foregroundColor(.white)
                    Text(tip)
                        .font(.body)
                        .foregroundColor(.white)
                        .padding(.leading, 5)
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.gray.opacity(0.2))
                .cornerRadius(15)
            }
        }
    }
}

#Preview {
    let context = PersistenceController.shared.container.viewContext
    let scanViewModel = ScanViewModel(context: context)
    
    // Mock data for the preview
    let mockHairScan = ScanResult(context: context)
    mockHairScan.hairtype = "Curly"
    scanViewModel.scans = [mockHairScan]
    
    return RoutineHairTypeView()
        .environmentObject(scanViewModel)
}


