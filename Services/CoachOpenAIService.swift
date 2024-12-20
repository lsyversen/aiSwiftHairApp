//
//  CoachOpenAIService.swift
//  hairapp
//
//  Created by Liam Syversen on 9/4/24.
//

import Foundation
import Alamofire

// Define the structure of the response
struct CoachOpenAIResponse: Codable {
    struct Choice: Codable {
        let message: Message
    }
    
    struct Message: Codable {
        let content: String
    }
    
    let choices: [Choice]
}

class CoachOpenAIService: ObservableObject {
        private let apiKey = "Enter API Key"
        private let apiUrl = "https://api.openai.com/v1/chat/completions"

        func sendMessage(_ message: String, completion: @escaping (String) -> Void) {
            let parameters: [String: Any] = [
                "model": "gpt-3.5-turbo",
                "messages": [
                    ["role": "user", "content": message]
                ],
                "max_tokens": 999
            ]
            
            let headers: HTTPHeaders = [
                "Authorization": "Bearer \(apiKey)",
                "Content-Type": "application/json"
            ]

            AF.request(apiUrl, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
                .responseDecodable(of: CoachOpenAIResponse.self) { response in
                    switch response.result {
                    case .success(let openAIResponse):
                        if let text = openAIResponse.choices.first?.message.content {
                            completion(text.trimmingCharacters(in: .whitespacesAndNewlines))
                        } else {
                            completion("Sorry, I didn't understand that.")
                        }
                    case .failure:
                        completion("Sorry, there was an error processing your request.")
                    }
                }
        }
    }

