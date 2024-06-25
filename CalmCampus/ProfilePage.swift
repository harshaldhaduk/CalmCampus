import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct ProfilePage: View {
    @State private var userNickname: String? = nil
    @State private var isSettingsPresented = false

    var body: some View {
        NavigationView {
                VStack(spacing: 20) {
                    HStack(alignment:.center) {
                        Circle()
                          .fill(Color.white)
                          .frame(width: 80, height: 80)
                          
                          .overlay(
                                Image("defaultpfp")
                                  .resizable()
                                  .aspectRatio(contentMode:.fill)
                                  .frame(width: 100, height: 100)
                                  .clipShape(Circle())
                            )

                        VStack(alignment:.leading) {
                            if let nickname = userNickname {
                                Text(nickname)
                                  .font(.system(size: 30))
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
                                      .font(.system(size: 20))
                                      .foregroundColor(.blue)
                                    Text("Settings")
                                      .font(.system(size: 17))
                                      .foregroundColor(.blue)
                                }
                              .foregroundColor(.primary)
                            }
                          .sheet(isPresented: $isSettingsPresented) {
                                SettingsView()
                            }
                        }
                      .padding(.leading, 20)
                        Spacer()
                    }
                  .padding(.horizontal, 20)
                  .padding(.top, 1)

                    RoundedRectangle(cornerRadius: 30)
                       .fill(Color.green.opacity(0.7))
                       .frame(height: 270)
                       .padding(.horizontal, 20)
                       .overlay(
                            VStack {
                                Text("Your Mood Scores Over Time")
                                   .font(.system(size: 18))
                                   .fontWeight(.bold)
                                   .foregroundColor(.white)
                                   .padding(.top, 15)
                                
                                MoodGraphView()
                                
                               .padding(.horizontal, 20)
                            }
                        )
                    
                    RoundedRectangle(cornerRadius: 30)
                       .fill(Color.blue.opacity(0.7))
                       .frame(height: 270)
                       .padding(.horizontal, 20)
                       .overlay(
                            VStack {
                                Text("Activities Completed Log")
                                   .font(.system(size: 18))
                                   .fontWeight(.bold)
                                   .foregroundColor(.white)
                                   .padding(.top, 20)
                                
                                ActivityGraphView()

                                
                               .padding(.horizontal, 20)
                                
                            }
                        )
                    
                    
                }
            }
           .onAppear {
                fetchNicknameFromFirebase()
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
