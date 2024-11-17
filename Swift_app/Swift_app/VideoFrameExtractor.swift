import AVFoundation
import UIKit

class VideoFrameExtractor {
    // Extract frames from a video and return them as an array of UIImage
    // Extract frames from a video and return them as an array of UIImage
    static func extractFrames(from videoURL: URL, completion: @escaping ([UIImage]) -> Void) {
        var frames: [UIImage] = []
        let asset = AVAsset(url: videoURL)
        let assetGenerator = AVAssetImageGenerator(asset: asset)
        assetGenerator.appliesPreferredTrackTransform = true
        
        let duration = asset.duration
        let frameInterval = CMTime(seconds: 1, preferredTimescale: 600) // Adjust the interval as needed
        var currentTime = CMTime.zero
        
        while currentTime < duration {
            do {
                let cgImage = try assetGenerator.copyCGImage(at: currentTime, actualTime: nil)
                let frameImage = UIImage(cgImage: cgImage)
                frames.append(frameImage)
            } catch {
                print("Failed to extract frame at \(CMTimeGetSeconds(currentTime))s: \(error)")
            }
            
            currentTime = CMTimeAdd(currentTime, frameInterval)
        }
        
        completion(frames)
    }
    
    // Upload an image to Pinata and return both the UIImage and its URL
    static func uploadImageToPinata(_ image: UIImage, completion: @escaping (UIImage?, URL?) -> Void) {
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            print("Failed to convert image to JPEG data")
            completion(nil, nil)
            return
        }
        
        let url1 = URL(string: "https://api.pinata.cloud/data/testAuthentication")!
        var request1 = URLRequest(url: url1)
        request1.httpMethod = "GET"
        request1.setValue("Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySW5mb3JtYXRpb24iOnsiaWQiOiIzMTIwZjhjYy0yN2Y4LTQyZDEtODJjYi00YWI2YjgwYjc4OTgiLCJlbWFpbCI6InByYWduYXNyaS52ZWxsYW5raUBnbWFpbC5jb20iLCJlbWFpbF92ZXJpZmllZCI6dHJ1ZSwicGluX3BvbGljeSI6eyJyZWdpb25zIjpbeyJkZXNpcmVkUmVwbGljYXRpb25Db3VudCI6MSwiaWQiOiJGUkExIn0seyJkZXNpcmVkUmVwbGljYXRpb25Db3VudCI6MSwiaWQiOiJOWUMxIn1dLCJ2ZXJzaW9uIjoxfSwibWZhX2VuYWJsZWQiOmZhbHNlLCJzdGF0dXMiOiJBQ1RJVkUifSwiYXV0aGVudGljYXRpb25UeXBlIjoic2NvcGVkS2V5Iiwic2NvcGVkS2V5S2V5IjoiZDk1YTA1NzMyOGFmNWZkNDExYzkiLCJzY29wZWRLZXlTZWNyZXQiOiJlZTE0MGNhMWY2MjU4M2Q0YmM0NzZhOWNmYWE0MzY5ZmQ4NzJkOWExNzM3MTM3YzZhMzZjZTEwOGNlMmVjZjJjIiwiZXhwIjoxNzYzMzU2MTI5fQ.z-Qk2smN0UTYHAduDXuZxnL6Fl3WmSR8Ig_9OWjBu0M", forHTTPHeaderField: "Authorization")
        request1.setValue("application/json", forHTTPHeaderField: "accept")
        
        
        let url = URL(string: "https://uploads.pinata.cloud/v3/files")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySW5mb3JtYXRpb24iOnsiaWQiOiIzMTIwZjhjYy0yN2Y4LTQyZDEtODJjYi00YWI2YjgwYjc4OTgiLCJlbWFpbCI6InByYWduYXNyaS52ZWxsYW5raUBnbWFpbC5jb20iLCJlbWFpbF92ZXJpZmllZCI6dHJ1ZSwicGluX3BvbGljeSI6eyJyZWdpb25zIjpbeyJkZXNpcmVkUmVwbGljYXRpb25Db3VudCI6MSwiaWQiOiJGUkExIn0seyJkZXNpcmVkUmVwbGljYXRpb25Db3VudCI6MSwiaWQiOiJOWUMxIn1dLCJ2ZXJzaW9uIjoxfSwibWZhX2VuYWJsZWQiOmZhbHNlLCJzdGF0dXMiOiJBQ1RJVkUifSwiYXV0aGVudGljYXRpb25UeXBlIjoic2NvcGVkS2V5Iiwic2NvcGVkS2V5S2V5IjoiZDk1YTA1NzMyOGFmNWZkNDExYzkiLCJzY29wZWRLZXlTZWNyZXQiOiJlZTE0MGNhMWY2MjU4M2Q0YmM0NzZhOWNmYWE0MzY5ZmQ4NzJkOWExNzM3MTM3YzZhMzZjZTEwOGNlMmVjZjJjIiwiZXhwIjoxNzYzMzU2MTI5fQ.z-Qk2smN0UTYHAduDXuZxnL6Fl3WmSR8Ig_9OWjBu0M", forHTTPHeaderField: "Authorization") // Replace with a secure method for production
        
        let boundary = "Boundary-\(UUID().uuidString)"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        var body = Data()
        let filename = "frame-\(UUID().uuidString).jpg"
        
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"file\"; filename=\"\(filename)\"\r\n".data(using: .utf8)!)
        body.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
        body.append(imageData)
        body.append("\r\n".data(using: .utf8)!)
        body.append("--\(boundary)--\r\n".data(using: .utf8)!)
        
        request.httpBody = body
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error uploading to Pinata: \(error)")
                completion(nil, nil)
                return
            }
            
            guard let data = data else {
                print("No response data from Pinata")
                completion(nil, nil)
                return
            }
            
            do {
                // Parse JSON response as a dictionary
                var jsonResponse = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                if jsonResponse != nil,
                   let dataSection = jsonResponse?["data"] as? AnyObject {
                    let id = dataSection["id"] as? String
                    var idString: String = ""
                    idString = id!
                    // Access the 'id' directly from the 'data' object
                    if id != nil {
                        // Construct the image URL using the retrieved id
                        guard let imageURL = URL(string: "https://api.pinata.cloud/v3/files/\(idString)") else {
                            print("Failed to construct a valid image URL")
                            completion(nil, nil)
                            return
                        }
                        print(imageURL)
                        // Call completion handler with the image and imageURL
                        completion(image, imageURL)
                    } else {
                        // Handle case where 'id' is not found
                        print("ID not found in the data object")
                        completion(nil, nil)
                    }
                } else {
                    // Handle unexpected response format
                    print("Unexpected response format from Pinata")
                    print(jsonResponse ?? "No response")
                    completion(nil, nil)
                }
            } catch {
                // Handle parsing error
                print("Error parsing Pinata response: \(error)")
                completion(nil, nil)
            }
        }

        // Start the network task
        task.resume()

    }

}
