import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            ZStack {
                Image("city_skyline") // Ensure this image is added to your Assets folder
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
                
                VStack {
                    Spacer()
                    Text("Tap the button below to view the current status")
                        .foregroundColor(.white)
                        .padding()
                    
                    NavigationLink(destination: CurrentStatusView()) {
                        Text("Go to Current Status")
                            .padding()
                            .background(Color("DarkGreen"))
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    Spacer()
                }
            }
            .background(Color("DarkGreen"))
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
