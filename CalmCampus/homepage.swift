import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct homepage: View {
    @State private var userNickname: String? = "Welcome"
    @State private var isJournalPresented = false
    
    var body: some View {
        NavigationView {
            ScrollView(.vertical, showsIndicators: true) {
                VStack(spacing: 20) {
                    if let nickname = userNickname {
                        Text(nickname)
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .fontWeight(.bold)
                            .padding(.top, 20)
                            .padding(.bottom, 20)
                    }
                    
                    Button(action: {
                        isJournalPresented = true
                        }) {
                        VStack {
                            HStack {
                                Text("Journal")
                                    .font(.system(size: 25))
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                                    .foregroundColor(.white)
                                
                                
                                Image(systemName: "chevron.right")
                                    .foregroundColor(.white)
                                    .font(.headline)
                                
                            }
                            Text("Track Tasks and Homework!")
                                .font(.system(size: 15))
                                .foregroundColor(.white)
                            
                        }
                            .frame(maxWidth: .infinity)
                            .frame(height: 80)
                            .background(Color.blue.opacity(0.7))
                            .cornerRadius(30)
                            .padding(.horizontal,20)
                            .shadow(radius: 5)
                    }
                    .sheet(isPresented: $isJournalPresented) {
                        Journal()
                    }
                    
                    CalendarView()
                        .frame(minHeight: 410)
                        .padding(.horizontal)
                    
                    
                    //add leaderboard here
                    
                    .padding(.bottom, 100) //spacing to help offset the tabbar
            
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
