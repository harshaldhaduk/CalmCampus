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
                            .padding(.top, 20)
                    }
                    
                    CalendarView()
                        .frame(minHeight: 410)
                        .padding(.horizontal)
                    
                    Button(action: {
                        isJournalPresented = true
                    }) {
                        HStack {
                            Text("Journal")
                                .font(.system(size: 20))
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                
                            
                            Image(systemName: "chevron.right")
                                .foregroundColor(.white)
                                .font(.headline)
                               
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(Color.blue)
                        .cornerRadius(10)
                        .padding(.horizontal,20)
                        .shadow(radius: 5)
                        
                    }
                    .sheet(isPresented: $isJournalPresented) {
                        Journal()
                    }
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
