import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct ProfilePage: View {
    @State private var userNickname: String? = nil
    @State private var isSettingsPresented = false
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @Environment(\.verticalSizeClass) var verticalSizeClass

    var isIPad: Bool {
        horizontalSizeClass == .regular && verticalSizeClass == .regular
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    HStack(alignment: .center) {
                        Circle()
                            .fill(Color.white)
                            .frame(width: isIPad ? 120 : 80, height: isIPad ? 120 : 80)
                            .overlay(
                                Image("defaultpfp")
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: isIPad ? 120 : 100, height: isIPad ? 120 : 100)
                                    .clipShape(Circle())
                            )
                        
                        VStack(alignment: .leading) {
                            if let nickname = userNickname {
                                Text(nickname)
                                    .font(.system(size: isIPad ? 45 : 30))
                                    .fontWeight(.bold)
                                    .padding(.bottom, 0.5)
                            } else {
                                Text("Loading...")
                                    .font(.title)
                                    .fontWeight(.bold)
                                    .padding(.bottom, 0.5)
                            }
                            
                            Button(action: {
                                isSettingsPresented = true
                            }) {
                                HStack {
                                    Image(systemName: "gear")
                                        .font(.system(size: isIPad ? 30 : 20))
                                        .foregroundColor(.blue)
                                    Text("Settings")
                                        .font(.system(size: isIPad ? 25 : 17))
                                        .foregroundColor(.blue)
                                }
                                .foregroundColor(.primary)
                            }
                            .sheet(isPresented: $isSettingsPresented) {
                                SettingsView()
                            }
                        }
                        .padding(.leading, isIPad ? 30 : 20)
                        Spacer()
                    }
                    .padding(.horizontal, isIPad ? 30 : 20)
                    .padding(.top, isIPad ? 45 : 30)
                    
                    RoundedRectangle(cornerRadius: isIPad ? 45 : 30)
                        .fill(Color.green.opacity(0.7))
                        .frame(height: isIPad ? 435 : 290)
                        .padding(.horizontal, isIPad ? 30 : 20)
                        .overlay(
                            VStack {
                                Text("Your Mood Scores Over Time")
                                    .font(.system(size: isIPad ? 27 : 18))
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                                    .padding(.top, isIPad ? 22.5 : 15)
                                
                                MoodGraphView()
                                    .padding(.horizontal, isIPad ? 30 : 20)
                            }
                        )
                        .padding(.top, isIPad ? 22.5 : 15)
                    
                    RoundedRectangle(cornerRadius: isIPad ? 45 : 30)
                        .fill(Color.blue.opacity(0.7))
                        .frame(height: isIPad ? 435 : 290)
                        .padding(.horizontal, isIPad ? 30 : 20)
                        .overlay(
                            VStack {
                                Text("Activities Completed Log")
                                    .font(.system(size: isIPad ? 27 : 18))
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                                    .padding(.top, isIPad ? 30 : 20)
                                
                                ActivityGraphView()
                                    .padding(.horizontal, isIPad ? 30 : 20)
                            }
                        )
                        .padding(.bottom, isIPad ? 22.5 : 15)
                        .padding(.top, isIPad ? 15 : 10)
                    
                    Spacer()
                }
            }
            .onAppear {
                fetchNicknameFromFirebase()
            }
        }
    }

    func fetchNicknameFromFirebase() {
        let db = Firestore.firestore()

        // Get the current user's ID
        if let userId = Auth.auth().currentUser?.uid {
            // Fetch the user's nickname from Firestore
            db.collection("users").document(userId).getDocument { snapshot, error in
                if let error = error {
                    print("Error fetching nickname: \(error.localizedDescription)")
                    return
                }

                if let snapshot = snapshot, let nickname = snapshot.get("nickname") as? String {
                    self.userNickname = nickname
                } else {
                    self.userNickname = "Unknown"
                }
            }
        }
    }
}

struct ProfilePage_Previews: PreviewProvider {
    static var previews: some View {
        ProfilePage()
    }
}
