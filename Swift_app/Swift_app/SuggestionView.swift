import SwiftUI

struct SuggestionView: View {
    @State private var suggestions: [String] = ["Initial suggestions for sustainable repairs."]
    @State private var userInput: String = ""
    @State private var selectedImage: UIImage? // Image selected for analysis
    @State private var isUploading: Bool = false // State to show upload progress
    
    var body: some View {
        VStack {
            ScrollView {
                ForEach(suggestions, id: \.self) { suggestion in
                    Text(suggestion)
                        .padding()
                        .background(Color("SuggestionBubble"))
                        .cornerRadius(10)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
            
            if let selectedImage = selectedImage {
                Image(uiImage: selectedImage)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 150)
                    .cornerRadius(10)
                    .padding(.bottom, 10)
            }
            
            if isUploading {
                ProgressView("Uploading Image...")
                    .padding(.bottom, 10)
            }
            
            HStack {
                TextField("Type a message or describe the object...", text: $userInput)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                Button("Send") {
                    sendMessage()
                }
                .padding()
                .background(Color("DarkGreen"))
                .foregroundColor(.white)
                .cornerRadius(10)
            }
        }
        .padding()
        .onAppear {
            // Optionally, load an image here or implement an image picker for user interaction
            // selectedImage = UIImage(named: "exampleImage") // Replace with actual image selection logic
        }
    }
    
    func sendMessage() {
        guard let image = selectedImage else {
            // Fallback: Send only text if no image is available
            LlamaResponseHandler.getResponse(for: userInput, imageURL: "") { response in
                DispatchQueue.main.async {
                    suggestions.append("User: \(userInput)")
                    suggestions.append("Llama: \(response)")
                    userInput = ""
                }
            }
            return
        }
        
        isUploading = true // Show upload progress
        
        VideoFrameExtractor.uploadImageToPinata(image) { uploadedImage, imageURL in
            DispatchQueue.main.async {
                isUploading = false // Hide upload progress
                
                guard let imageURL = imageURL else {
                    suggestions.append("Error: Failed to upload image.")
                    return
                }
                
                let question = "Is \(userInput) damaged?"
                LlamaResponseHandler.getResponse(for: question, imageURL: imageURL.absoluteString) { response in
                    DispatchQueue.main.async {
                        suggestions.append("User: \(userInput)")
                        suggestions.append("Llama: \(response)")
                        userInput = ""
                    }
                }
            }
        }
    }
}
