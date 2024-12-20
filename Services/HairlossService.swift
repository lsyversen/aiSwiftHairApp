//
//  HairlossService.swift
//  hairapp
//
//  Created by Liam Syversen on 10/31/24.
//  

import Foundation
import Alamofire
import UIKit

struct OpenAIResponseTwo: Decodable {
    let choices: [Choice]
    
    struct Choice: Decodable {
        let message: Message
    }
    
    struct Message: Decodable {
        let content: String
    }
}

class HairlossService {
    private let apiKey = "ENter API"
    private let apiURL = "https://api.openai.com/v1/chat/completions"
    
    func analyzeHair(images: [UIImage], completion: @escaping (String?) -> Void) {
        guard !apiKey.isEmpty else {
            print("Error: API Key is missing.")
            completion("Error: API Key is missing.")
            return
        }
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(apiKey)",
            "Content-Type": "application/json"
        ]
        
        // Retrieve the selected gender from UserDefaults
        let gender = UserDefaults.standard.string(forKey: "selectedGender") ?? "Unspecified"
        
        // Convert images to base64 strings
        let base64Images = images.compactMap { image -> String? in
            let targetSize = CGSize(width: 300, height: 400)
            let resizedImage = resizeImage(image: image, targetSize: targetSize)
            return compressImage(image: resizedImage, quality: 0.5)?.base64EncodedString()
        }
        
        // Ensure at least one image is valid
        guard !base64Images.isEmpty else {
            print("Error: No valid images provided.")
            completion("Error: No valid images provided.")
            return
        }
         
        let imagePrompts = base64Images.enumerated().map { index, base64Image in
            "![hair\(index)](data:image/jpeg;base64,\(base64Image))"
        }.joined(separator: "\n")
        
        let promptText = """
            You are a hair loss assessment expert. Analyze the provided images of a \(gender) and determine the Hair Loss Stage (1-7) based on these guidelines:

            - Stage 1: Early signs of hair loss; slight recession of the hairline or no hair loss.
            - Stage 4: Extensive hair loss; the bridge between the crown and the receding hairline begins to thin, with less distinction between the two.
            - Stage 7: Severe hair loss; fully bald with minimal hair remaining only on the sides and back.
        
            Return **only** the results in the exact JSON format below:

            {
                "Hair Loss Stage": "Stage [1-7]"
            }

            Example:

            {
                "Hair Loss Stage": "Stage 2"
            }

            \(imagePrompts)
        """

        
        let requestBody: [String: Any] = [
            "model": "gpt-4-turbo",
            "messages": [
                ["role": "user", "content": promptText]
            ],
            "max_tokens": 2000
        ]
        
        AF.request(apiURL, method: .post, parameters: requestBody, encoding: JSONEncoding.default, headers: headers)
            .validate(statusCode: 200..<300)
            .responseDecodable(of: OpenAIResponse.self) { response in
                switch response.result {
                case .success(let openAIResponse):
                    if let firstChoice = openAIResponse.choices.first {
                        let result = firstChoice.message.content
                        print("Analysis Result: \(result)") // Console log the result
                        completion(result)
                    } else {
                        print("No analysis result found.")
                        completion("No analysis result.")
                    }
                case .failure(let error):
                    if let data = response.data, let responseString = String(data: data, encoding: .utf8) {
                        print("Response data: \(responseString)")
                    }
                    print("Error: \(error.localizedDescription)")
                    completion("Failed to get response. Status Code: \(response.response?.statusCode ?? 0)")
                }
            }
    }
    
    // Utility function to resize the image
    private func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size

        let widthRatio = targetSize.width / size.width
        let heightRatio = targetSize.height / size.height

        let scaleFactor = min(widthRatio, heightRatio)

        let newSize = CGSize(width: size.width * scaleFactor, height: size.height * scaleFactor)

        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: CGRect(origin: .zero, size: newSize))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return newImage!
    }

    // Utility function to compress the image
    private func compressImage(image: UIImage, quality: CGFloat) -> Data? {
        return image.jpegData(compressionQuality: quality)
    }
}

