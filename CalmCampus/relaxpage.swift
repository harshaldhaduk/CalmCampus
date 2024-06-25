import SwiftUI
import Firebase

struct relaxpage: View {
    @State private var clickCounter = 0
    
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
                            ForEach(0..<4) { index in
                                MeditationSessionButton(title: meditationTitles(index), imageName: index == 0 ? "breathe" : nil, clickCounter: $clickCounter)
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
                            ForEach(0..<3) { index in
                                RelaxationSessionButton(title: relaxationTitles(index), clickCounter: $clickCounter)
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
                    
                    ArticlesScrollView(clickCounter: $clickCounter)
                        .padding(.top, 10)
                        .padding(.horizontal)
                }
            }
        }
        .onAppear {
            fetchClickCounterFromFirebase()
        }
        .onChange(of: clickCounter) { newValue in
            updateClickCounterInFirebase(newValue)
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
        case 0: return "Relaxing Soundscapes"
        case 1: return "Garden Creator"
        case 2: return "Artistic Expression"
        default: return "Relaxation \(index + 1)"
        }
    }
    
    func fetchClickCounterFromFirebase() {
        guard let user = Auth.auth().currentUser else { return }
        
        let db = Firestore.firestore()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateString = dateFormatter.string(from: Date())
        
        let userActivityRef = db.collection("users").document(user.uid).collection("activity").document(dateString)
        
        userActivityRef.getDocument { snapshot, error in
            if let error = error {
                print("Error fetching document: \(error)")
                return
            }
            
            if let data = snapshot?.data(), let clickCounter = data["clickCounter"] as? Int {
                self.clickCounter = clickCounter
            }
        }
    }
    
    func updateClickCounterInFirebase(_ count: Int) {
        guard let user = Auth.auth().currentUser else { return }
        let db = Firestore.firestore()

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateString = dateFormatter.string(from: Date())

        let userActivityRef = db.collection("users").document(user.uid).collection("activity").document(dateString)

        userActivityRef.setData(["clickCounter": count], merge: true)
    }
}


struct MeditationSessionButton: View {
    var title: String
    var imageName: String?
    @Binding var clickCounter: Int
    
    var body: some View {
        Group {
            if title == "Breath Awareness" {
                NavigationLink(destination: breathawareness().onAppear { incrementCounter() }) {
                    buttonContent
                }
            } else if title == "Movement-Based" {
                NavigationLink(destination: movement().onAppear { incrementCounter() }) {
                    buttonContent
                }
            } else if title == "Mindfulness" {
                NavigationLink(destination: mindfulness().onAppear { incrementCounter() }) {
                    buttonContent
                }
            } else if title == "Loving-Kindness" {
                NavigationLink(destination: loving().onAppear { incrementCounter() }) {
                    buttonContent
                }
            } else {
                Button(action: {
                    incrementCounter()
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
        .cornerRadius(20)
        .shadow(color: Color.black.opacity(0.4), radius: 5, x: 0, y: 5) // Adjusted drop shadow
    }
    
    func incrementCounter() {
        clickCounter += 1
    }
}

struct RelaxationSessionButton: View {
    var title: String
    var imageName: String?
    @State private var showFullScreen = false
    @Binding var clickCounter: Int

    var body: some View {
        Group {
            if title == "Relaxing Soundscapes" {
                Button(action: {
                    showFullScreen = true
                    incrementCounter()
                }) {
                    buttonContent
                }
               .fullScreenCover(isPresented: $showFullScreen) {
                    NavigationView {
                        sensory().edgesIgnoringSafeArea(.all)
                           .navigationBarBackButtonHidden(true)
                           .toolbar {
                                ToolbarItem(placement:.navigationBarLeading) {
                                    Button(action: {
                                        showFullScreen = false
                                    }) {
                                        Image(systemName: "chevron.backward")
                                           .imageScale(.large)
                                    }
                                }
                            }
                    }
                }
            } else if title == "Garden Creator" {
                Button(action: {
                    showFullScreen = true
                    incrementCounter()
                }) {
                    buttonContent
                }
               .fullScreenCover(isPresented: $showFullScreen) {
                    NavigationView {
                        GameScenePreview().edgesIgnoringSafeArea(.all)
                           .navigationBarBackButtonHidden(true)
                           .toolbar {
                                ToolbarItem(placement:.navigationBarLeading) {
                                    Button(action: {
                                        showFullScreen = false
                                    }) {
                                        Image(systemName: "chevron.backward")
                                           .imageScale(.large)
                                    }
                                }
                            }
                    }
                }
            } else if title == "Artistic Expression" {
                Button(action: {
                    showFullScreen = true
                    incrementCounter()
                }) {
                    buttonContent
                }
               .fullScreenCover(isPresented: $showFullScreen) {
                    NavigationView {
                        artistic().edgesIgnoringSafeArea(.all)
                           .navigationBarBackButtonHidden(true)
                           .toolbar {
                                ToolbarItem(placement:.navigationBarLeading) {
                                    Button(action: {
                                        showFullScreen = false
                                    }) {
                                        Image(systemName: "chevron.backward")
                                           .imageScale(.large)
                                    }
                                }
                            }
                    }
                }
            } else {
                Button(action: {
                    incrementCounter()
                    // Action when the button is clicked for default cases
                }) {
                    buttonContent
                }
            }
        }
    }

    var buttonContent: some View {
        ZStack {
            if title == "Relaxing Soundscapes" {
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
            }  else if title == "Garden Creator" {
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
        .cornerRadius(20)
        .shadow(color: Color.black.opacity(0.4), radius: 5, x: 0, y: 5) // Adjusted drop shadow
    }
    
    func incrementCounter() {
        clickCounter += 1
    }
}


struct ArticlesScrollView: View {
    @State private var isArticle1Presented = false
    @State private var isArticle2Presented = false
    @State private var isArticle3Presented = false
    @Binding var clickCounter: Int

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 20) {
                // Article 1
                Button(action: {
                    isArticle1Presented = true
                    incrementCounter()
                }) {
                    VStack {
                        ZStack {
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.blue.opacity(0.7))
                                .frame(height: 52)
                            Text("The Power of Mindfulness in Everyday Life")
                                .font(.headline)
                                .foregroundColor(.white)
                                .padding(.horizontal, 10)
                        }
                        Text("Discover how simple mindfulness techniques can transform your daily routine and improve your mental well-being.")
                            .padding(.top, 10)
                            .foregroundColor(.gray)
                            .padding(.horizontal)
                        Spacer()
                    }
                    .padding(.top, 20)
                    .padding(.horizontal, 10)
                    .frame(width: 250, height: 250)
                    .background(Color(UIColor.secondarySystemBackground))
                    .cornerRadius(20)
                    .shadow(color: Color.black.opacity(0.4), radius: 5, x: 0, y: 5)
                }
                .sheet(isPresented: $isArticle1Presented) {
                    Article1()
                }
                
                // Article 2
                Button(action: {
                    isArticle2Presented = true
                    incrementCounter()
                }) {
                    VStack {
                        ZStack {
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.blue.opacity(0.7))
                                .frame(height: 52)
                            Text("Breaking the Cycle of Stress")
                                .font(.headline)
                                .foregroundColor(.white)
                                .padding(.horizontal, 10)
                        }
                        Text("Discover how simple mindfulness techniques can transform your daily routine and improve your mental well-being.")
                            .padding(.top, 10)
                            .foregroundColor(.gray)
                            .padding(.horizontal)
                        Spacer()
                    }
                    .padding(.top, 20)
                    .padding(.horizontal, 10)
                    .frame(width: 250, height: 250)
                    .background(Color(UIColor.secondarySystemBackground))
                    .cornerRadius(20)
                    .shadow(color: Color.black.opacity(0.4), radius: 5, x: 0, y: 5)
                }
                .sheet(isPresented: $isArticle2Presented) {
                    Article2()
                }
                
                // Article 3
                Button(action: {
                    isArticle3Presented = true
                    incrementCounter()
                }) {
                    VStack {
                        ZStack {
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.blue.opacity(0.7))
                                .frame(height: 52)
                            Text("Meditation for Beginners: A Simple Guide")
                                .font(.headline)
                                .foregroundColor(.white)
                                .padding(.horizontal, 10)
                        }
                        Text("Discover the basics of meditation with this simple guide for beginners and start your journey toward inner peace and relaxation.")
                            .padding(.top, 10)
                            .foregroundColor(Color.gray)
                            .padding(.horizontal)
                        Spacer()
                    }
                    .padding(.top, 20)
                    .padding(.horizontal, 10)
                    .frame(width: 250, height: 250)
                    .background(Color(UIColor.secondarySystemBackground))
                    .cornerRadius(20)
                    .shadow(color: Color.black.opacity(0.4), radius: 5, x: 0, y: 5)
                }
                .sheet(isPresented: $isArticle3Presented) {
                    Article3()
                }
            }
            .padding(.top, 5)
            .padding(.bottom, 30)
        }
        .edgesIgnoringSafeArea(.horizontal)
    }

    private func incrementCounter() {
        clickCounter += 1
    }
}




//ALL ARTICLES BELOW

struct Article1: View {

    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack (alignment:.leading) {
                Text("The Power of Mindfulness in Everyday Life")
                    .fixedSize(horizontal: false, vertical: true)
                    .font(.largeTitle)
                    .padding()
                
                Text("In our fast-paced world, finding moments of calm can be challenging. Mindfulness offers a solution, helping us to stay present and connected in our daily lives. By practicing mindfulness, we can reduce stress, enhance our focus, and improve our overall mental health.")
                    .fixedSize(horizontal: false, vertical: true)
                    .padding()
                
                Text("What is Mindfulness?")
                    .fixedSize(horizontal: false, vertical: true)
                    .font(.headline)
                    .padding()
                
                Text("Mindfulness is the practice of paying attention to the present moment without judgment. It involves observing your thoughts, emotions, and sensations with curiosity and openness. This can be done through various techniques such as meditation, deep breathing, or simply being aware of your surroundings.")
                    .fixedSize(horizontal: false, vertical: true)
                    .padding()
                
                Text("Benefits of Mindfulness")
                    .fixedSize(horizontal: false, vertical: true)
                    .font(.headline)
                    .padding()
                
                Text("Research has shown that mindfulness can reduce symptoms of anxiety and depression, improve sleep, and increase overall happiness. It can also enhance our ability to handle stress by allowing us to respond to situations more calmly and thoughtfully.")
                    .fixedSize(horizontal: false, vertical: true)
                    .padding()
                
                Text("How to Practice Mindfulness")
                    .fixedSize(horizontal: false, vertical: true)
                    .font(.headline)
                    .padding()
                
                Text("1. Start Small: Begin with just a few minutes of mindfulness each day. Focus on your breathing or pay attention to the sensations in your body.")
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(.bottom, 5)
                    .padding(.horizontal)
                
                Text("2. Be Consistent: Make mindfulness a daily habit. Over time, you’ll find it easier to stay present and centered.")
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(.bottom, 5)
                    .padding(.horizontal)
                
                Text("3. Incorporate Mindfulness into Daily Activities: Practice mindfulness while eating, walking, or even during conversations. This can help you stay grounded and connected throughout the day.")
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(.bottom, 5)
                    .padding(.horizontal)
                
                Text("By integrating mindfulness into your life, you can cultivate a greater sense of peace and well-being.")
                    .fixedSize(horizontal: false, vertical: true)
                    .padding()
            }
            .background(Color(UIColor.secondarySystemBackground))
            .edgesIgnoringSafeArea(.all)
        }
    }
}

struct Article2: View {

    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack (alignment:.leading) {
                Text("Breaking the Cycle of Stress")
                    .fixedSize(horizontal: false, vertical: true)
                    .font(.largeTitle)
                    .padding()
                
                Text("Stress is an inevitable part of life, but it doesn’t have to control you. By understanding the stress cycle and implementing effective strategies, you can break free from its grip and achieve a healthier, more balanced life.")
                    .fixedSize(horizontal: false, vertical: true)
                    .padding()
                
                Text("Understanding the Stress Cycle")
                    .fixedSize(horizontal: false, vertical: true)
                    .font(.headline)
                    .padding()
                
                Text("The stress cycle begins with a stressor, which triggers a response in your body. This response can be physical, emotional, or mental, and it often leads to a feeling of being overwhelmed. If not managed, stress can become chronic, affecting your health and well-being.")
                    .fixedSize(horizontal: false, vertical: true)
                    .padding()
                
                Text("Signs of Chronic Stress")
                    .fixedSize(horizontal: false, vertical: true)
                    .font(.headline)
                    .padding()
                
                Text("Chronic stress can manifest in various ways, including headaches, fatigue, irritability, and difficulty concentrating. Recognizing these signs is the first step toward breaking the cycle.")
                    .fixedSize(horizontal: false, vertical: true)
                    .padding()
                
                Text("By taking proactive steps to manage stress, you can break the cycle and improve your overall health and well-being.")
                    .fixedSize(horizontal: false, vertical: true)
                    .padding()
            
            }
            .background(Color(UIColor.secondarySystemBackground))
            .edgesIgnoringSafeArea(.all)
        }
    }
}

struct Article3: View {

    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack (alignment:.leading) {
                Text("Meditation for Beginners: A Simple Guide")
                    .fixedSize(horizontal: false, vertical: true)
                    .font(.largeTitle)
                    .padding()
                
                Text("Meditation is a powerful tool for achieving inner peace and relaxation. If you’re new to meditation, this guide will help you get started on your journey toward a calmer mind and a more balanced life.")
                    .fixedSize(horizontal: false, vertical: true)
                    .padding()
                
                Text("What is Meditation?")
                    .fixedSize(horizontal: false, vertical: true)
                    .font(.headline)
                    .padding()
                
                Text("Meditation is a practice that involves focusing your mind on a particular object, thought, or activity to achieve mental clarity and emotional calm. It has been practiced for thousands of years and is a cornerstone of many spiritual and wellness traditions.")
                    .fixedSize(horizontal: false, vertical: true)
                    .padding()
                
                Text("Benefits of Meditation")
                    .fixedSize(horizontal: false, vertical: true)
                    .font(.headline)
                    .padding()
                
                Text("Regular meditation can reduce stress, improve concentration, increase self-awareness, and promote emotional health. It can also enhance your ability to handle the challenges of daily life.")
                    .fixedSize(horizontal: false, vertical: true)
                    .padding()
                
                Text("How to Start Meditating")
                    .fixedSize(horizontal: false, vertical: true)
                    .font(.headline)
                    .padding()
                
                Text("1. Find a Quiet Space: Choose a quiet and comfortable place where you won’t be disturbed.")
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(.bottom, 5)
                    .padding(.horizontal)
                
                Text("2. Sit Comfortably: Sit in a comfortable position with your back straight. You can sit on a chair, cushion, or the floor.")
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(.bottom, 5)
                    .padding(.horizontal)
                
                Text("3. Focus on Your Breath: Close your eyes and focus on your breathing. Notice the sensation of each breath as it enters and leaves your body.")
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(.bottom, 5)
                    .padding(.horizontal)
                
                Text("4. Be Present: If your mind wanders, gently bring your focus back to your breath. It’s natural for thoughts to arise; the key is to acknowledge them without judgment and return to your breath.")
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(.bottom, 5)
                    .padding(.horizontal)
                
                
                Text("With regular practice, meditation can become a valuable part of your daily routine, helping you achieve greater peace and clarity.")
                    .fixedSize(horizontal: false, vertical: true)
                    .padding()
            
            }
            .background(Color(UIColor.secondarySystemBackground))
            .edgesIgnoringSafeArea(.all)
        }
    }
}

struct Relaxpage_Previews: PreviewProvider {
    static var previews: some View {
        relaxpage()
    }
}
