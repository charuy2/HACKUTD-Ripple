import Foundation

class LlamaResponseHandler {
    static func getResponse(for question: String, imageURL: String, completion: @escaping (String) -> Void) {
        // Define the API endpoint and request parameters
        guard let url = URL(string: "https://api.sambanova.ai/v1/chat/completions") else {
            print("Invalid URL")
            completion("Error: Invalid URL")
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer YOUR_LLAMA_API_KEY", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        // Build the request body with the correct format for including the image URL
        let requestBody: [String: Any] = [
            "stream": true,
            "model": "Llama-3.2-11B-Vision-Instruct",
            "messages": [
                [
                    "role": "user",
                    "content": question
                ],
                [
                    "role": "user",
                    "content": [
                        "type": "image_url",
                        "image_url": [
                            "url": imageURL // Directly use the image URL from Pinata
                        ]
                    ]
                ]
            ]
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
                print("Request error: \(error)")
                completion("Error: \(error.localizedDescription)")
                return
            }

            guard let data = data else {
                print("No response data")
                completion("Error: No response data")
                return
            }

            do {
                if let jsonResponse = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                   let choices = jsonResponse["choices"] as? [[String: Any]],
                   let message = choices.first?["message"] as? [String: Any],
                   let content = message["content"] as? String {
                    completion(content)
                } else {
                    print("Unexpected response format")
                    completion("Error: Unexpected response format")
                }
            } catch {
                print("Error parsing response: \(error)")
                print("Raw response data as UTF-8 string: \(String(data: data, encoding: .utf8) ?? "Unable to display response data")")
                completion("Error parsing response: \(error.localizedDescription)")
            }
        }

        task.resume()
    }
}
