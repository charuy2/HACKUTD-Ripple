import Foundation
import UIKit

// Function to analyze the image using Llama API for damage detection
func analyzeImageWithLlama(imageBase64: String, llamaApiKey: String, object: String, completion: @escaping (String?) -> Void) {
    let url = URL(string: "https://api.sambanova.ai/v1/chat/completions")!

    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.setValue("Bearer ccc8bbfd-65b5-44a0-b6f3-166263b74435", forHTTPHeaderField: "Authorization")
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")

    // Construct the full image URL format with base64 prefix
    let formattedBase64Image = "data:image/jpeg;base64,\(imageBase64)"

    let requestBody: [String: Any] = [
        "model": "Meta-Llama-3.1-70B-Instruct",
        "messages": [
            [
                "role": "user",
                "content": [
                    [
                        "type": "text",
                        "text": "Is \(object) damaged?"
                    ],
                    [
                        "type": "image_url",
                        "image_url": [
                            "url": formattedBase64Image
                        ]
                    ]
                ]
            ]
        ],
        "max_tokens": 300,
        "temperature": 0,
        "top_p": 0,
        "top_k": 100,
        "stream": true,
        "stream_options": ["include_usage": true]
    ]

    do {
        request.httpBody = try JSONSerialization.data(withJSONObject: requestBody, options: [])
    } catch {
        print("Error serializing request body: \(error)")
        completion("Error: Failed to serialize request body")
        return
    }

    let task = URLSession.shared.dataTask(with: request) { data, response, error in
        if let error = error {
            print("Llama API request error: \(error)")
            completion("Llama API request error: \(error.localizedDescription)")
            return
        }

        guard let data = data else {
            print("No response data from Llama API")
            completion("Error: No response data from Llama API")
            return
        }

        // Log the full response for debugging
        if let responseString = String(data: data, encoding: .utf8) {
            print("Llama API Response Data:", responseString)
        }

        // Parse the response data
        do {
            if let jsonResponse = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
               let choices = jsonResponse["choices"] as? [[String: Any]],
               let message = choices.first?["message"] as? [String: Any],
               let content = message["content"] as? String {
                completion(content)
            } else {
                print("Error: 'choices' not found in Llama response or response format is different.")
                completion("Error: 'choices' not found in Llama response or response format is different.")
            }
        } catch {
            print("Error parsing Llama response: \(error)")
            print("Response Data as String:", String(data: data, encoding: .utf8) ?? "Unable to convert response data to string")
            completion("Error parsing Llama response: \(error.localizedDescription)")
        }
    }

    task.resume()
}
