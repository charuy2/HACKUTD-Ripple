import SwiftUI
import AVKit

struct CurrentStatusView: View {
    @State private var videoURL: URL?
    @State private var analysisResults: [String] = []
    @State private var isAnalyzing: Bool = false

    var body: some View {
        VStack {
            if let videoURL = videoURL {
                VideoPlayer(player: AVPlayer(url: videoURL))
                    .frame(height: 300)
                    .onAppear {
                        if !isAnalyzing {
                            analyzeVideo()
                        }
                    }
            } else {
                VideoPicker(videoURL: $videoURL)
            }
            
            if isAnalyzing {
                ProgressView("Analyzing video...")
                    .padding()
            } else {
                ScrollView {
                    ForEach(analysisResults.indices, id: \.self) { index in
                        Text(analysisResults[index])
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(10)
                            .padding(.vertical, 2)
                    }
                }
            }
            
            Button("Back to Home") {
                // Add navigation logic to return to the main content view
            }
            .padding()
            .background(Color("DarkGreen"))
            .foregroundColor(.white)
            .cornerRadius(10)
        }
        .padding()
    }

    func analyzeVideo() {
        guard let videoURL = videoURL else {
            return
        }
        
        isAnalyzing = true
        analysisResults = ["Initializing analysis..."]
        
        // Extract frames and analyze each frame
        VideoFrameExtractor.extractFrames(from: videoURL) { frames in
            let dispatchGroup = DispatchGroup()

            for (index, frame) in frames.enumerated() {
                dispatchGroup.enter()
                
                // Upload the frame to Pinata and get both the image and the URL
                VideoFrameExtractor.uploadImageToPinata(frame) { uploadedImage, imageURL in
                    DispatchQueue.main.async {
                        if let imageURL = imageURL {
                            // Call LlamaResponseHandler with the image URL
                            let detectedObject = "object" // Replace with actual object detection logic
                            let question = "Is \(detectedObject) damaged?"

                            LlamaResponseHandler.getResponse(for: question, imageURL: imageURL.absoluteString) { response in
                                DispatchQueue.main.async {
                                    analysisResults.append("Frame at \(index + 1)s: \(response)")
                                    if index == frames.count - 1 {
                                        isAnalyzing = false
                                    }
                                    dispatchGroup.leave()
                                }
                            }
                        } else {
                            analysisResults.append("Failed to upload frame at \(index + 1)s")
                            dispatchGroup.leave()
                        }
                    }
                }
            }

            // Notify when all frames are processed
            dispatchGroup.notify(queue: .main) {
                isAnalyzing = false
            }
        }
    }
}
