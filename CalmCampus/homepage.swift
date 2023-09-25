import SwiftUI

struct homepage: View {
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                // Add CalendarView at the top
                CalendarView()
                
                // Grid of FeatureButtons
                LazyVGrid(columns: [GridItem(), GridItem()]) {
                    VStack(spacing: 10) {
                        FeatureButton(imageName: "list.number", label: "Leaderboard")
                        FeatureButton(imageName: "note.text", label: "Journal")
                        FeatureButton(imageName: "calendar", label: "Calendar")
                    }
                    VStack(spacing: 10) {
                        FeatureButton(imageName: "play.circle", label: "Meditation")
                        FeatureButton(imageName: "wind", label: "Breathing")
                        FeatureButton(imageName: "quote.bubble", label: "Motivator")
                    }
                }
            }
            .navigationBarTitle("Welcome")
        }
    }
}

struct FeatureButton: View { // Feature button UI
    let imageName: String
    let label: String
    let fontsize: CGFloat // Introduce a parameter for text size
    
    init(imageName: String, label: String, fontsize: CGFloat = 15.0) {
        self.imageName = imageName
        self.label = label
        self.fontsize = fontsize
    }
    
    var body: some View {
        NavigationLink(destination: FeatureView(featureName: label)) {
            HStack {
                Image(systemName: imageName)
                    .font(.system(size: 24)) // Image/logo size
                    .frame(width: 20, height: 20) // Grey box size
                    .padding(8) // Blue circle size
                    .background(Color.blue)
                    .clipShape(Circle())
                    .foregroundColor(.white)
                    .padding(5)
                    .overlay(
                        Circle()
                            .stroke(Color.white, lineWidth: 2)
                    )
                
                Text(label)
                    .font(.system(size: fontsize))
                    .fontWeight(.bold) // Make the text bold
                    .foregroundColor(.primary)
                
                Spacer() // Add Spacer to left-align content
            }
            .padding(.horizontal)
            .padding(.vertical, 5)
            .background(Color.secondary.opacity(0.1))
            .cornerRadius(10)
        }
    }
}

struct FeatureView: View {
    let featureName: String
    
    var body: some View {
        VStack {
            Text("\(featureName) View")
                .font(.largeTitle)
                .padding()
            Spacer()
        }
        .navigationBarTitle(featureName)
    }
}

struct Homepage_Previews: PreviewProvider {
    static var previews: some View {
        homepage()
    }
}
