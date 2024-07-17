import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct homepage: View {
    @State private var userNickname: String? = "Welcome"
    @State private var isJournalPresented = false
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    
    var body: some View {
        let isRegularSizeClass = horizontalSizeClass == .regular
        let scaleFactor: CGFloat = isRegularSizeClass ? 1.5 : 1.0
        
        NavigationStack {
            ScrollView(.vertical, showsIndicators: true) {
                VStack(spacing: 20 * scaleFactor) {
                    if let nickname = userNickname {
                        Text(nickname)
                            .font(.system(size: 34 * scaleFactor))
                            .fontWeight(.bold)
                            .padding(.top, 20 * scaleFactor)
                            .padding(.bottom, 20 * scaleFactor)
                    }
                    
                    RoundedRectangle(cornerRadius: 30 * scaleFactor)
                       .fill(Color(UIColor.secondarySystemBackground))
                       .frame(height: 250 * scaleFactor)
                       .padding(.horizontal, 20 * scaleFactor)
                       .shadow(color: Color.black.opacity(0.2), radius: 5 * scaleFactor, x: 0, y: 5 * scaleFactor)
                       .overlay(
                            VStack {
                                Text("Activity Tracker")
                                    .font(.system(size: 24 * scaleFactor))
                                    .fontWeight(.semibold)
                                    .padding(.bottom, 30 * scaleFactor)
                                
                                ActivityTracker().padding(.horizontal, 20 * scaleFactor)
                            }
                        )
                    
                    RoundedRectangle(cornerRadius: 30 * scaleFactor)
                       .fill(Color(UIColor.secondarySystemBackground))
                       .frame(height: 450 * scaleFactor)
                       .padding(.horizontal, 20 * scaleFactor)
                       .shadow(color: Color.black.opacity(0.2), radius: 5 * scaleFactor, x: 0, y: 5 * scaleFactor)
                       .overlay(
                            VStack {
                                
                                CalendarView()
                               .padding(.horizontal, 20 * scaleFactor)
                               .padding(.top, 400)
                               .padding(.bottom, 400)
                            }
                        )
                    
                    Button(action: {
                        isJournalPresented = true
                        }) {
                        VStack {
                            HStack {
                                Text("Journal")
                                    .font(.system(size: 25 * scaleFactor))
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                                
                                Image(systemName: "chevron.right")
                                    .foregroundColor(.white)
                                    .font(.headline)
                                
                            }
                            Text("Track Tasks and Homework!")
                                .font(.system(size: 15 * scaleFactor))
                                .foregroundColor(.white)
                            
                        }
                            .frame(maxWidth: .infinity)
                            .frame(height: 80 * scaleFactor)
                            .background(Color.blue.opacity(0.7))
                            .cornerRadius(30 * scaleFactor)
                            .padding(.horizontal, 20 * scaleFactor)
                            .shadow(color: Color.black.opacity(0.4), radius: 5 * scaleFactor, x: 0, y: 5 * scaleFactor)
                    }
                    .sheet(isPresented: $isJournalPresented) {
                        Journal()
                    }
                    .padding(.bottom, 30 * scaleFactor) // spacing to help offset the tabbar
                }
                .onAppear {
                    // Fetch user data from Firestore
                    if let uid = Auth.auth().currentUser?.uid {
                        let db = Firestore.firestore()
                        let userRef = db.collection("users").document(uid)
                        
                        userRef.getDocument { (document, error) in
                            if let document = document, document.exists {
                                if let nickname = document.data()?["nickname"] as? String {
                                    DispatchQueue.main.async {
                                        userNickname = "Welcome \(nickname)!"
                                    }
                                }
                            }
                        }
                    }
                }
                .navigationBarTitle("", displayMode: .inline)
            }
        }
    }
}

struct Homepage_Previews: PreviewProvider {
    static var previews: some View {
        homepage()
    }
}
