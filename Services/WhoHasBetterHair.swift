//
//  WhoHasBetterHair.swift
//  hairapp
//
//  Created by Liam Syversen on 9/12/24.
//

import Foundation
import Alamofire
import UIKit

struct WhoHasBetterHairResponse: Decodable {
    let choices: [Choice]
    
    struct Choice: Decodable {
        let message: Message
    }
    
    struct Message: Decodable {
        let content: String
    }
}

class WhoHasBetterHairService {
    private let apiKey = "ENter API"
    private let apiURL = "https://api.openai.com/v1/chat/completions"
    
    func compareHair(firstPerson: String, secondPerson: String, images: [UIImage], completion: @escaping (String?) -> Void) {
        guard images.count == 2 else {
            print("Error: Two images are required.")
            completion("Error: Two images are required.")
            return
        }
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(apiKey)",
            "Content-Type": "application/json"
        ]
        
        // Convert images to base64 strings
        let base64Images = images.compactMap { image -> String? in
            let targetSize = CGSize(width: 300, height: 400)
            let resizedImage = resizeImage(image: image, targetSize: targetSize)
            return compressImage(image: resizedImage, quality: 0.5)?.base64EncodedString()
        }
        
        guard base64Images.count == 2 else {
            print("Error: Unable to process both images.")
            completion("Error: Unable to process both images.")
            return
        }
        
        let promptText = """
            You are a scalp hair comparison expert. Two individuals, \(firstPerson) and \(secondPerson), have uploaded images of their hair. Based on the look of the hair on top of their head and metrics like overall hair health, hair thickness, hair line, frizz level, and style, determine who has better hair. If a person is bald then they will instantly lose. Provide a simple response stating the winner's name in the exact format:
            
            Example Response: [Name]

            Where [Name] is either "\(firstPerson)" or "\(secondPerson)" based on who has better scalp hair. Ensure that the response includes only the name without any additional text or explanation.

            Image for \(firstPerson): ![hair1](data:image/jpeg;base64,\(base64Images[0]))
            Image for \(secondPerson): ![hair2](data:image/jpeg;base64,\(base64Images[1]))
        
            Respond only with the name. Do not provide any additional text or explanation.
        
            Example Response if winner's name was John: John
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
            .responseDecodable(of: WhoHasBetterHairResponse.self) { response in
                switch response.result {
                case .success(let openAIResponse):
                    if let firstChoice = openAIResponse.choices.first {
                        let result = firstChoice.message.content.trimmingCharacters(in: .whitespacesAndNewlines)
                        print("Better Hair: \(result)") // Console log the result
                        completion(result)
                    } else {
                        print("No result found.")
                        completion("No result found.")
                    }
                case .failure(let error):
                    print("Error: \(error.localizedDescription)")
                    completion("Failed to get response.")
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

