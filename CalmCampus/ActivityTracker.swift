import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct ActivityTracker: View {
    @State private var clickCounter: Int = 0
    @State private var activityGoal: Int = 30
    @State private var showGoalInput = false
    @State private var newGoal: String = ""

    var body: some View {
        ZStack {
            // Grey box behind the elements

            VStack {

                HStack(spacing: 20) {
                    CircularProgressBar(progress: Double(clickCounter) / Double(activityGoal), activityGoal: activityGoal)
                        .frame(width: 100, height: 100)

                    VStack(alignment: .leading, spacing: 10) {
                        Text(clickCounter >= activityGoal ? "You've met your goal!" : "Keep going! You're almost there!")
                            .font(.headline)

                        Button(action: {
                            showGoalInput = true
                        }) {
                            Text("Change Daily Activity Goal")
                                .font(.subheadline)
                                .foregroundColor(.blue)
                        }
                    }
                }
                .padding(.bottom, 5)
                .padding(.horizontal, 15)
            }
            .onAppear {
                loadClickCounterFromFirebase()
            }
            .sheet(isPresented: $showGoalInput) {
                GoalInputView(activityGoal: $activityGoal, newGoal: $newGoal, showGoalInput: $showGoalInput)
            }
        }
    }

    func loadClickCounterFromFirebase() {
        guard let uid = Auth.auth().currentUser?.uid else {
            print("User is not logged in")
            return
        }

        let db = Firestore.firestore()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let today = dateFormatter.string(from: Date())

        let activityRef = db.collection("users").document(uid).collection("activity").document(today)

        activityRef.getDocument { document, error in
            if let error = error {
                print("Failed to fetch click counter: \(error)")
                return
            }

            if let document = document, document.exists {
                if let clickCounter = document.data()?["clickCounter"] as? Int,
                   let lastUpdateDate = document.data()?["date"] as? String {
                    if lastUpdateDate == today {
                        DispatchQueue.main.async {
                            self.clickCounter = clickCounter
                        }
                    } else {
                        DispatchQueue.main.async {
                            self.clickCounter = 0
                        }
                        updateFirestoreCounter(date: today, counter: 0) // Reset the counter in Firestore
                    }
                }
            } else {
                DispatchQueue.main.async {
                    self.clickCounter = 0
                }
                updateFirestoreCounter(date: today, counter: 0) // Initialize the counter in Firestore
            }
        }
    }

    func updateFirestoreCounter(date: String, counter: Int) {
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }

        let db = Firestore.firestore()
        let activityRef = db.collection("users").document(uid).collection("activity").document(date)
        activityRef.setData([
            "clickCounter": counter,
            "date": date
        ]) { error in
            if let error = error {
                print("Error updating counter: \(error)")
            }
        }
    }
}

struct CircularProgressBar: View {
    var progress: Double
    var activityGoal: Int

    var body: some View {
        ZStack {
            Circle()
                .stroke(lineWidth: 10)
                .opacity(0.3)
                .foregroundColor(Color.blue)

            Circle()
                .trim(from: 0.0, to: CGFloat(min(self.progress, 1.0)))
                .stroke(style: StrokeStyle(lineWidth: 10, lineCap: .round, lineJoin: .round))
                .foregroundColor(Color.blue)
                .rotationEffect(Angle(degrees: 270.0))
                .animation(.linear(duration: 0.6), value: progress)

            VStack {
                Text(String(format: "%.0f%%", min(self.progress, 1.0) * 100.0))
                    .font(.title)
                    .bold()
                Text("\(Int(progress * Double(activityGoal))) / \(activityGoal) activities")
                    .font(.system(size: 8))
                    .foregroundColor(.gray)
            }
        }
    }
}

struct GoalInputView: View {
    @Binding var activityGoal: Int
    @Binding var newGoal: String
    @Binding var showGoalInput: Bool

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Set New Activity Goal")) {
                    TextField("Enter new goal", text: $newGoal)
                        .keyboardType(.numberPad)
                }
                Section {
                    Button("Save") {
                        if let newGoalInt = Int(newGoal), newGoalInt > 0 {
                            activityGoal = newGoalInt
                            showGoalInput = false
                        }
                    }
                }
            }
            .navigationBarTitle("Change Daily Activity Goal", displayMode: .inline)
            .navigationBarItems(trailing: Button("Cancel") {
                showGoalInput = false
            })
        }
    }
}

struct ActivityTracker_Previews: PreviewProvider {
    static var previews: some View {
        ActivityTracker()
    }
}
