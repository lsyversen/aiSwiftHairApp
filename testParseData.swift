//
//  TestParseData.swift
//  hair-app
//
//  Created by Liam Syversen on 9/3/24.
//

import SwiftUI

struct TestParseData: View {
    @State private var parsedMetrics: [String: Any] = [:]
    
    // Sample output to be parsed
    let sampleOutput = """
    {
        "Overall": "Rating: 72",
        "Potential": "Rating: 91",
        "Frizz Level": "Rating: 76",
        "Hair Thickness": "Rating: 80",
        "Scalp Health": "Rating: 82",
        "Luster": "Rating: 75",
        "Hair Style": "Description: Big Black N",
        "Hair Color": "Description: Dark brown",
        "Hair Type": "Description: Type 3A",
        "Hair Texture": "Description: Coarse and thick"
    }
    """
    
    var body: some View {
        VStack {
            Button(action: {
                // Parse the sample output when button is pressed
                self.parsedMetrics = parseAnalysisResults(sampleOutput) ?? [:]
            }) {
                Text("Test Parse Function")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            
            // Display parsed metrics
            ScrollView {
                VStack(alignment: .leading) {
                    ForEach(parsedMetrics.keys.sorted(), id: \.self) { key in
                        if let value = parsedMetrics[key] {
                            Text("\(key): \(value)")
                                .padding(.bottom, 5)
                        }
                    }
                }
                .padding()
            }
        }
        .padding()
    }
    
    private func parseAnalysisResults(_ result: String) -> [String: Any]? {
        var metrics: [String: Any] = [:]
        
        // Safeguard against empty input
        guard !result.isEmpty else {
            print("Error: Input string is empty")
            return nil
        }

        // Trim the input and make sure it is valid JSON
        let trimmedResult = result.trimmingCharacters(in: .whitespacesAndNewlines)
        
        // Attempt to convert the string to JSON data
        guard let jsonData = trimmedResult.data(using: .utf8) else {
            print("Error: Failed to convert string to JSON Data.")
            return nil
        }

        // Parse JSON data
        do {
            if let jsonObject = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: String] {
                for (key, value) in jsonObject {
                    if value.contains("Rating:") {
                        // Extract and convert the number from the "Rating:"
                        let numberString = value.replacingOccurrences(of: "Rating:", with: "").trimmingCharacters(in: .whitespaces)
                        if let number = Double(numberString) {
                            metrics[key] = number
                        } else {
                            print("Failed to convert \(numberString) to Double for key: \(key)")
                        }
                    } else if value.contains("Description:") {
                        // Extract the description
                        let description = value.replacingOccurrences(of: "Description:", with: "").trimmingCharacters(in: .whitespaces)
                        metrics[key] = description
                    }
                }
            } else {
                print("Failed to parse JSON into [String: String] format.")
            }
        } catch {
            print("Error parsing JSON: \(error)")
            return nil
        }
        
        print("Parsed Metrics: \(metrics)") // Debugging log to check parsed output
        return metrics
    }
}

#Preview {
    TestParseData()
}


