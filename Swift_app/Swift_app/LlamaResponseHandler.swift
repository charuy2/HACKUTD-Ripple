/*import Foundation

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
        request.setValue("Bearer bc3ecd54-60c4-45d4-80cf-0d8aa4fa44d6", forHTTPHeaderField: "Authorization")
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
            //            print("doing")
            request.httpBody = try JSONSerialization.data(withJSONObject: requestBody, options: [])
            //            print("done")
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
                //                if let jsonResponse = try JSONSerialization.jsonObject(with: data, options: []) as? [: Any] {
                
                let jsonString = String(data: data, encoding: .utf8)
                
                if let jsonData = jsonString!.data(using: .utf8) {
                    do {
                        if let jsonObject = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any] {
                            if let choices = jsonObject["choices"] as? String {
                                print("Choices: \(choices)")
                            }
                        }
                    }
                }
                //                    print(true)
                //                    print(data)
                /*let jsonString = String(data: data, encoding: .utf8)
                 print("Raw JSON string: \(jsonString ?? "No response")")
                 let jsonResponse = try JSONSerialization.jsonObject(with: jsonString, options: []) as? [String: Any]
                 print(jsonResponse)
                 let jsonString = String(data: data, encoding: .utf8)
                 print("Raw JSON string: \(jsonString ?? "No response")")
                 */
                // Convert JSON string to Data and parse it
                if let jsonString = jsonString, let jsonData = jsonString.data(using: .utf8) {
                    do {
                        // Parse JSON response as a dictionary
                        if let jsonResponse = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any] {
                            if let choices = jsonResponse["choices"] as? [[String: Any]],
                               let message = choices.first?["message"] as? [String: Any],
                               let content = message["content"] as? String {
                                // Successfully extracted the content
                                completion(content)
                            } else {
                                print("Failed to parse 'choices' or extract 'content'")
                                completion("")
                            }
                        } else {
                            print("JSON response is not a dictionary")
                            completion("")
                        }
                    } catch {
                        print("Error parsing JSON: \(error)")
                        completion("")
                    }
                } else {
                    print("Invalid JSON string or failed to convert JSON string to Data")
                    completion("")
                }
                
                
                //                print(data.absoluteString)
                //print("Raw response data as UTF-8 string: \(String(data: data, encoding: .utf8) ?? "Unable to display response data")")
                //print(jsonResponse)
                /*if ,
                 let choices = jsonResponse["choices"] as? [[String: Any]],
                 let message = choices.first?["message"] as? [String: Any],
                 let content = message["content"] as? String {
                 completion(content)
                 } else {
                 print("Unexpected response format")
                 completion("Error: Unexpected response format")
                 }*/
            } catch {
                print("Error parsing response: \(error)")
                completion("Error parsing response: \(error.localizedDescription)")
            }
        }
        
        task.resume()
    }
}
*/

import Foundation

struct LlamaResponse: Codable {
    let choices: [Choice]
    let created: Int
    let id: String
    let model: String
    let object: String
    let systemFingerprint: String
    
    enum CodingKeys: String, CodingKey {
        case choices, created, id, model, object
        case systemFingerprint = "system_fingerprint"
    }
}

struct Choice: Codable {
    let delta: Delta
    let finishReason: String?
    let index: Int
    let logprobs: String?
    
    enum CodingKeys: String, CodingKey {
        case delta
        case finishReason = "finish_reason"
        case index, logprobs
    }
}

struct Delta: Codable {
    let content: String?
    let role: String?
}

class LlamaResponseHandler {
    static func getResponse(for question: String, imageURL: String, completion: @escaping (String) -> Void) {
        guard let url = URL(string: "https://api.sambanova.ai/v1/chat/completions") else {
            print("Invalid URL")
            completion("Error: Invalid URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer ccc8bbfd-65b5-44a0-b6f3-166263b74435", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
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
                            "url": imageURL
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
            print("Task started") // Confirm the task is running
            
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
            
            // Convert data to a string for inspection
            if var jsonString = String(data: data, encoding: .utf8) {
                print("Raw JSON string: \(jsonString)")
                
                // Split the string by newline and filter out lines with "[DONE]"
                let jsonLines = jsonString.split(separator: "\n").map { String($0) }
                for line in jsonLines {
                    if line == "data: [DONE]" {
                        print("Received [DONE] message, skipping.")
                        continue
                    }
                    
                    // Remove the "data: " prefix if present
                    if line.hasPrefix("data: ") {
                        jsonString = String(line.dropFirst(6)) // Remove "data: "
                    } else {
                        jsonString = line
                    }
                    
                    // Attempt to decode the cleaned JSON string
                    if let jsonData = jsonString.data(using: .utf8) {
                        do {
                            let decodedResponse = try JSONDecoder().decode(LlamaResponse.self, from: jsonData)
                            if let content = decodedResponse.choices.first?.delta.content {
                                print("Extracted content: \(content)")
                                completion(content)
                            } else {
                                print("Failed to extract content from 'delta'")
                                completion("Error: Failed to extract content")
                            }
                        } catch {
                            print("Error decoding JSON: \(error)")
                            // Continue the loop to process the next line if needed
                        }
                    } else {
                        print("Failed to convert line to JSON data")
                    }
                }
            } else {
                print("Unable to convert data to UTF-8 string")
                completion("Error: Unable to convert response data")
                return
            }
        }

        print("Before task resume") // Confirm this statement runs
        task.resume()

    }
}


