import SwiftUI

struct relaxpage: View {
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    Text("Meditate")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .padding(.top, 20)
                        .padding(.horizontal)
                        .id("Meditate")
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 20) {
                            // Meditation Session Boxes as Buttons in a Horizontal Scroll
                            ForEach(0..<4) { index in
                                MeditationSessionButton(title: meditationTitles(index), imageName: index == 0 ? "breathe" : nil)
                            }
                        }
                        .padding(.horizontal)
                        .padding(.bottom,5)
                    }
                    .frame(height: 130)
                    
                    Divider()
                        .padding(.horizontal)
                    
                    Text("Relax")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .padding(.horizontal)
                        .id("Relax")
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 20) {
                            // Relaxation Session Boxes as Buttons in a Horizontal Scroll
                            ForEach(0..<4) { index in
                                RelaxationSessionButton(title: relaxationTitles(index))
                            }
                        }
                        .padding(.horizontal)
                        .padding(.bottom,5)
                    }
                    .frame(height: 130)
                    
                    Divider()
                        .padding(.horizontal)
                    
                    Text("Featured Articles")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .padding(.horizontal)
                        .id("Featured")
                    
                    ArticlesScrollView()
                        .padding(.horizontal)
                }
            }
        }
    }
}

func meditationTitles(_ index: Int) -> String {
    switch index {
    case 0: return "Breath Awareness"
    case 1: return "Movement-Based"
    case 2: return "Mindfulness"
    case 3: return "Loving-Kindness"
    default: return "Meditation \(index + 1)"
    }
}

func relaxationTitles(_ index: Int) -> String {
    switch index {
    case 0: return "Sensory Discovery"
    case 1: return "Nature Soundscape"
    case 2: return "Artistic Expression"
    case 3: return "Mental Imagery"
    default: return "Relaxation \(index + 1)"
    }
}

struct MeditationSessionButton: View {
    var title: String
    var imageName: String?
    
    var body: some View {
        Group {
            if title == "Breath Awareness" {
                NavigationLink(destination: breathawareness()) {
                    buttonContent
                }
            } else if title == "Movement-Based" {
                NavigationLink(destination: movement()) {
                    buttonContent
                }
            } else if title == "Mindfulness" {
                NavigationLink(destination: mindfulness()) {
                    buttonContent
                }
            }
            else if title == "Loving-Kindness" {
                NavigationLink(destination: loving()) {
                    buttonContent
                }
            } else {
                Button(action: {
                    // Action when the button is clicked for default cases
                }) {
                    buttonContent
                }
            }
        }
    }
    
    var buttonContent: some View {
        ZStack {
            if title == "Movement-Based" {
                Image("movement")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 200, height: 130)
                    .clipped()
                    .overlay(
                        Color.black.opacity(0.3) // Increased opacity to 0.7
                            .edgesIgnoringSafeArea(.all)
                    )
                    .blur(radius: 0) // Blur the image
            }  else if title == "Mindfulness" {
                Image("mindfulness")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 200, height: 130)
                    .clipped()
                    .overlay(
                        Color.black.opacity(0.3) // Increased opacity to 0.7
                            .edgesIgnoringSafeArea(.all)
                    )
                    .blur(radius: 0) // Blur the image
            }  else if title == "Loving-Kindness" {
                Image("loving")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 200, height: 130)
                    .clipped()
                    .overlay(
                        Color.black.opacity(0.3) // Increased opacity to 0.7
                            .edgesIgnoringSafeArea(.all)
                    )
                    .blur(radius: 0) // Blur the image
            } else if let imageName = imageName {
                Image(imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 200, height: 130)
                    .clipped()
                    .overlay(
                        Color.black.opacity(0.3) // Increased opacity to 0.7
                            .edgesIgnoringSafeArea(.all)
                    )
                    .blur(radius: 0) // Blur the image
            }
            VStack {
                Spacer()
                Text(title)
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding()
                Spacer()
            }
        }
        .frame(width: 200, height: 130)
        .background(Color.white)
        .cornerRadius(10)
        .shadow(color: Color.black.opacity(0.4), radius: 5, x: 0, y: 5) // Adjusted drop shadow
    }
}

struct RelaxationSessionButton: View {
    var title: String
    var imageName: String?
    
    var body: some View {
        Group {
            if title == "Sensory Discovery" {
                NavigationLink(destination: sensory().edgesIgnoringSafeArea(.all)) {
                    buttonContent
                }
            } else if title == "Nature Soundscape" {
                NavigationLink(destination: nature().edgesIgnoringSafeArea(.all)) {
                    buttonContent
                }
            } else if title == "Artistic Expression" {
                NavigationLink(destination: artistic().edgesIgnoringSafeArea(.all)) {
                    buttonContent
                }
            }
            else if title == "Mental Imagery" {
                NavigationLink(destination: mentalimagery().edgesIgnoringSafeArea(.all)) {
                    buttonContent
                }
            } else {
                Button(action: {
                    // Action when the button is clicked for default cases
                }) {
                    buttonContent
                }
            }
        }
    }
    
    var buttonContent: some View {
        ZStack {
            if title == "Sensory Discovery" {
                Image("sensory")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 200, height: 130)
                    .clipped()
                    .overlay(
                        Color.black.opacity(0.3) // Increased opacity to 0.7
                            .edgesIgnoringSafeArea(.all)
                    )
                    .blur(radius: 0) // Blur the image
            }  else if title == "Nature Soundscape" {
                Image("nature")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 200, height: 130)
                    .clipped()
                    .overlay(
                        Color.black.opacity(0.3) // Increased opacity to 0.7
                            .edgesIgnoringSafeArea(.all)
                    )
                    .blur(radius: 0) // Blur the image
            }  else if title == "Artistic Expression" {
                Image("artistic")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 200, height: 130)
                    .clipped()
                    .overlay(
                        Color.black.opacity(0.3) // Increased opacity to 0.7
                            .edgesIgnoringSafeArea(.all)
                    )
                    .blur(radius: 0) // Blur the image
            } else if title == "Mental Imagery" {
                Image("mental")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 200, height: 130)
                    .clipped()
                    .overlay(
                        Color.black.opacity(0.3) // Increased opacity to 0.7
                            .edgesIgnoringSafeArea(.all)
                    )
                    .blur(radius: 0) // Blur the image
            }
            VStack {
                Spacer()
                Text(title)
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding()
                Spacer()
            }
        }
        .frame(width: 200, height: 130)
        .background(Color.white)
        .cornerRadius(10)
        .shadow(color: Color.black.opacity(0.4), radius: 5, x: 0, y: 5) // Adjusted drop shadow
    }
}

struct ArticlesScrollView: View {
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 20) {
                ForEach(0..<5) { index in
                    ArticleCardView()
                }
            }
            .padding()
        }
    }
}

struct ArticleCardView: View {
    var body: some View {
        VStack {
            Text("Article Title")
                .font(.headline)
                .foregroundColor(.white)
                .padding(.vertical, 5)
                .padding(.horizontal, 10)
                .background(Color.blue)
                .cornerRadius(10)
            
            Text("Add article content here.")
                .foregroundColor(.gray)
                .padding(.horizontal)
                .lineLimit(2)
        }
        .frame(width: 250, height: 250)
        .background(Color.white)
        .cornerRadius(10)
        .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 5) // Applied drop shadow
    }
}

struct Relaxpage_Previews: PreviewProvider {
    static var previews: some View {
        relaxpage()
    }
}
