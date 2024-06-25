import SwiftUI
import FirebaseFirestore
import FirebaseAuth

struct ContentView: View {
    @State private var isLoading = true
    @State private var isShowingPopup = false
    @State private var selectedMood = ""
    @State private var isrelaxpagePresented = false
    @State private var isModalViewPresented = false // Track if any modal view is presented

    var body: some View {
        ZStack {
            if !isModalViewPresented {
                TabView {
                    homepage()
                        .tabItem {
                            Image(systemName: "house")
                            Text("Home")
                        }

                    relaxpage()
                        .tabItem {
                            Image(systemName: "figure.mind.and.body")
                            Text("Relax")
                        }
                        .tag(1)

                    ProfilePage()
                        .tabItem {
                            Image(systemName: "person.fill")
                            Text("Profile")
                        }
                }
                .zIndex(1)
            }

            if isLoading || isShowingPopup {
                // Blurred background
                BlurView(style: .systemMaterial)
                    .edgesIgnoringSafeArea(.all)
                    .zIndex(2)
            }

            if isLoading {
                // Loading Screen
                VStack {
                    Text("Loading...")
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .foregroundColor(.black)
                        .padding(.bottom, 0.1)
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                        .padding(.top, 10)
                }
                .zIndex(3)
            }

            if isShowingPopup {
                // Popup view
                MoodPopupView(isShowingPopup: $isShowingPopup, selectedMood: $selectedMood) { mood in
                    saveMood(mood)
                }
                .zIndex(4)
            }
        }
        .onAppear {
            checkMoodForToday()
        }
        .sheet(isPresented: $isrelaxpagePresented) {
            NavigationView {
                relaxpage() // Just present the relaxpage without additional parameters
            }
        }
    }

    
    func checkMoodForToday() {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let dateString = formatter.string(from: Date())
        
        guard let uid = Auth.auth().currentUser?.uid else {
            isLoading = false // Assuming no user is signed in
            return
        }
        let db = Firestore.firestore()
        
        db.collection("users").document(uid).collection("moods").document(dateString).getDocument { document, error in
            if let document = document, document.exists {
                // Mood already exists for today, no need to show the popup
                isShowingPopup = false
            } else {
                // Mood doesn't exist for today, show the popup
                isShowingPopup = true
            }
            isLoading = false // Update loading state after checking mood
        }
    }
    
    func saveMood(_ mood: String) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let db = Firestore.firestore()
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let dateString = formatter.string(from: Date())
        
        db.collection("users").document(uid).collection("moods").document(dateString).setData([
            "mood": mood
        ]) { error in
            if let error = error {
                print("Failed to save mood: \(error)")
            } else {
                print("Mood saved successfully!")
                UserDefaults.standard.set(dateString, forKey: "lastMoodDate")
                isShowingPopup = false
            }
        }
    }
}

struct BlurView: UIViewRepresentable {
    let style: UIBlurEffect.Style
    
    func makeUIView(context: Context) -> UIVisualEffectView {
        return UIVisualEffectView(effect: UIBlurEffect(style: style))
    }
    
    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {}
}

struct MoodPopupView: View {
    @Binding var isShowingPopup: Bool
    @Binding var selectedMood: String
    var onSave: (String) -> Void
    
    var body: some View {
        VStack(spacing: 10) {
            Text("How are you feeling today?")
                .font(.custom("Avenir", size: 28))
                .fontWeight(.bold)
                .padding(.top,5)
                .multilineTextAlignment(.center)
                .fixedSize(horizontal: false, vertical: true)
                .lineLimit(nil)
            
            HStack(spacing: 30) {
                Button(action: {
                    onSave("Happy")
                }) {
                    Text("😊")
                        .foregroundColor(.green)
                        .font(.system(size: 60))
                }
                
                Button(action: {
                    onSave("Neutral")
                }) {
                    Text("😐")
                        .foregroundColor(.yellow)
                        .font(.system(size: 60))
                }
                
                Button(action: {
                    onSave("Sad")
                }) {
                    Text("☹️")
                        .foregroundColor(.red)
                        .font(.system(size: 60))
                }
            }
        }
        .frame(width: 300, height: 150)
        .padding()
        .background(Color(UIColor.secondarySystemBackground))
        .cornerRadius(10)
        .padding(EdgeInsets(top: 150, leading: 10, bottom: 100, trailing: 10))
        .shadow(radius: 5)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
