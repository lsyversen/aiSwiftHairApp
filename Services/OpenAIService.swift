//
//  OpenAIService.swift
//  hairapp
//
//  Created by Liam Syversen on 9/4/24.
//

import Foundation
import Alamofire
import UIKit

struct OpenAIResponse: Decodable {
    let choices: [Choice]
    
    struct Choice: Decodable {
        let message: Message
    }
    
    struct Message: Decodable {
        let content: String
    }
}

class OpenAIService {
    private let apiKey = "Enter API KEY"
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
            You are an expert in head hair analysis. Based on the provided images of a \(gender), analyze the hair and face features using the metrics below. Return the results **only** in the specified JSON format without additional text, explanations, or commentary.

            Metrics:

            - Overall: The general health and condition of the hair, considering all visible aspects.
            - Potential: The maximum possible health and appearance of the hair with optimal care, rated higher than "Overall."
            - Frizz Level: How smooth and frizz-free the hair appears, with higher ratings indicating less frizz.
            - Hair Density: The fullness of the hair, based on how closely packed the hair strands appear.
            - Shine: The hair's natural gloss and sheen, rated higher for more shine.
            - Volume: The perceived body and fullness of the hair.
            - Hair Thickness: The diameter of individual strands, categorized as:
                - Fine
                - Medium
                - Thick
            - Hair Color: A description of the users hair's color (e.g., "Light brown," "Black", "Blonde").
            - Hair Type: One of the following categories:
                - Straight
                - Wavy
                - Curly
                - Coily
            - Face Shape: The general shape of the face in the first image, categorized as:
                - Oval, Round, Square, Rectangular, Diamond, Triangular, Oblong, or Heart.

            Return the response in this JSON format:

            {
                "Overall": "Rating: [30-100]",
                "Potential": "Rating: [75-100, greater than Overall]",
                "Frizz Level": "Rating: [10-100, higher is better]",
                "Hair Density": "Rating: [10-100]",
                "Shine": "Rating: [10-100]",
                "Volume": "Rating: [10-100]",
                "Hair Thickness": "Description: [Fine, Medium, Thick]",
                "Hair Color": "Description: [1-2 word color description]",
                "Hair Type": "Description: [Straight, Wavy, Curly, Coily]",
                "Face Shape": "Description: [Oval, Round, Square, Rectangular, Diamond, Triangular, Oblong, Heart]"
            }

            Example:

            {
                "Overall": "Rating: 85",
                "Potential": "Rating: 92",
                "Frizz Level": "Rating: 78",
                "Hair Density": "Rating: 88",
                "Shine": "Rating: 90",
                "Volume": "Rating: 86",
                "Hair Thickness": "Description: Medium",
                "Hair Color": "Description: Brown",
                "Hair Type": "Description: Curly",
                "Face Shape": "Description: Oval"
            }

            Analyze the images and provide **only** the results in the exact JSON format above.

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
