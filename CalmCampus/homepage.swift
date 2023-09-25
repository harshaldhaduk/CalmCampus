import SwiftUI

struct homepage: View {
    var body: some View {
        NavigationView {
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
            .navigationBarTitle("Welcome")
        }
    }
}

struct FeatureButton: View {
    let imageName: String
    let label: String
    
    var body: some View {
        NavigationLink(destination: FeatureView(featureName: label)) {
            HStack {
                Image(systemName: imageName)
                    .font(.title)
                    .frame(width: 30, height: 30)
                    .background(Color.blue)
                    .clipShape(Circle())
                    .foregroundColor(.white)
                    .padding(.trailing, 5)
                
                Text(label)
                    .font(.subheadline)
                    .foregroundColor(.primary)
            }
            .frame(maxWidth: .infinity)
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
