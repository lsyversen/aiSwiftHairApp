//
//  ImageResizer.swift
//  hairapp
//
//  Created by Liam Syversen on 9/4/24.
//

import UIKit

// Utility function to resize the image
func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
    let size = image.size

    let widthRatio = (targetSize.width / size.width)
    let heightRatio = (targetSize.height / size.height)

    // Determine the scale factor to use
    let scaleFactor = min(widthRatio, heightRatio)

    // Calculate the new image size
    let newSize = CGSize(width: size.width * scaleFactor, height: size.height * scaleFactor)

    // Create a new image context and draw the resized image
    UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
    image.draw(in: CGRect(origin: .zero, size: newSize))
    let newImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()

    return newImage!
}

// Utility function to compress the image
func compressImage(image: UIImage, quality: CGFloat) -> Data? {
    return image.jpegData(compressionQuality: quality)
}


