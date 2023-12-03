//
//  ContentView.swift
//  sample2
//
//  Created by Harshal Dhaduk on 9/18/23.
//

import SwiftUI
import FirebaseFirestore
import FirebaseAuth


struct ProfileView: View {
    var body: some View {
        Text("Profile View")
    }
}

//tabbar
struct ContentView: View {
    @State private var selectedTab = 0
    @State private var isShowingPopup = true
    @State private var selectedMood = ""
    
    var body: some View {
        ZStack {
            TabView(selection: $selectedTab) {
                homepage()
                    .tabItem {
                        Image(systemName: "house")
                        Text("Home")
                    }
                    .tag(0)
                
                relaxpage()
                    .tabItem {
                        Image(systemName: "figure.mind.and.body")
                        Text("Relax")
                    }
                    .tag(1)
                
                ProfileView()
                    .tabItem {
                        Image(systemName: "person.fill")
                        Text("Profile")
                    }
                    .tag(2)
            }
            .zIndex(1)
            
            if isShowingPopup {
                        // Background with blur effect
                BlurView(style: .systemMaterial)
                            .edgesIgnoringSafeArea(.all)
                            .zIndex(1)
                            .onTapGesture {
                                isShowingPopup = false
                            }
                            .zIndex(2)
                        
                        // Popup view
                        MoodPopupView(isShowingPopup: $isShowingPopup, selectedMood: $selectedMood)
                            .zIndex(3)
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
    
    func saveMood(_ mood: String) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let db = Firestore.firestore()
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let dateString = formatter.string(from: Date()) // Use the current date or selected date as needed
        
        db.collection("users").document(uid).collection("moods").document(dateString).setData([
            "mood": mood
        ]) { error in
            if let error = error {
                print("Failed to save mood: \(error)")
            } else {
                print("Mood saved successfully!")
                isShowingPopup = false // Close the mood popup after saving
                // Perform any additional actions upon successful save
            }
        }
    }
    
    var body: some View {
        VStack(spacing: 10) {
            Text("How are you feeling today?")
                .font(.custom("Avenir", size: 28))
                .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                .padding(.top,5)
        
                .multilineTextAlignment(.center)
                .fixedSize(horizontal: false, vertical: true) // Allows multiline
                .lineLimit(nil) // Removes line limit
            
            HStack(spacing: 30) {
                           Button(action: {
                               saveMood("Happy") // Save the selected mood
                           }) {
                               Text("😊")
                                   .foregroundColor(.green)
                                   .font(.system(size: 60))
                           }

                           Button(action: {
                               saveMood("Neutral") // Save the selected mood
                           }) {
                               Text("😐")
                                   .foregroundColor(.yellow)
                                   .font(.system(size: 60))
                           }

                           Button(action: {
                               saveMood("Sad") // Save the selected mood
                }) {
                    Text("☹️")
                        .foregroundColor(.red)
                        .font(.system(size: 60))
                }
            }
        }
        .frame(width: 300, height: 150)
        .padding()
        .background(Color.white)
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

