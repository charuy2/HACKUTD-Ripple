import SwiftUI

struct HomePageView: View {
    var body: some View {
        ZStack {
            // Background image of the city skyline
            Image("city_skyline")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()

            // Floating block with the app name
            VStack {
                Text("My Sustainable App")
                    .font(.largeTitle)
                    .foregroundColor(Color.green.opacity(0.9))
                    .padding()
                    .background(Color.white.opacity(0.8))
                    .cornerRadius(12)
                
                NavigationLink(destination: CurrentStatusView()) {
                    Text("Go to Current Status")
                        .font(.headline)
                        .padding()
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .padding(.top, 20)
                }
            }
        }
        .navigationBarHidden(true)
    }
}
