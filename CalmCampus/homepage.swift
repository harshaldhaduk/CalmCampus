import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct homepage: View {
    // Add a state variable to store the user's nickname
    @State private var userNickname: String? = "Welcome" // Initial value
    @State private var isJournalPresented = false // New state variable

    var body: some View {
        NavigationView {
            VStack(alignment: .center) {
                // Check if userNickname is available, and display a personalized welcome message
                if let nickname = userNickname {
                    Text(nickname)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .padding(.top, 20)
                        .padding(.horizontal)
                }

                // Add CalendarView at the top
                CalendarView()

                // Blue "Journal" button
                Button(action: {
                    isJournalPresented = true // Show the Journal sheet
                }) {
                    Text("Journal")
                        .font(.system(size: 20))
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 35) // Adjust the height as needed
                        .background(Color.blue)
                        .cornerRadius(10) // Add rounded corners
                        .padding(.horizontal, 20) // Add padding to the sides
                }
                .sheet(isPresented: $isJournalPresented) {
                    Journal()
                }

                Spacer()
                    .padding(.bottom, 12) // Add bottom padding to create spacing
            }
        }
        .onAppear {
            if let uid = Auth.auth().currentUser?.uid {
                let db = Firestore.firestore()
                let userRef = db.collection("users").document(uid)

                userRef.getDocument { (document, error) in
                    if let document = document, document.exists {
                        if let nickname = document.data()?["nickname"] as? String {
                            DispatchQueue.main.async {
                                userNickname = "Welcome \(nickname)!" // Update with the Firestore data
                            }
                        }
                    }
                }
            }
        }
    }
}

struct Homepage_Previews: PreviewProvider {
    static var previews: some View {
        homepage()
    }
}
