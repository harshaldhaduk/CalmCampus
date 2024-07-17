import SwiftUI
import Firebase

struct MoodGraphView: View {
    @State private var moods: [Mood] = []
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    
    var body: some View {
        VStack {
            if moods.isEmpty {
                Text("Loading mood data...")
                    .padding()
            } else {
                HStack(alignment: .bottom, spacing: horizontalSizeClass == .regular ? 15 : 10) {
                    ForEach(moods, id: \.day) { mood in
                        VStack(spacing: 5) {
                            Rectangle()
                                .fill(barColor(for: mood.moodCount))
                                .frame(width: horizontalSizeClass == .regular ? 52.5 : 35,
                                       height: CGFloat(mood.moodCount) * (horizontalSizeClass == .regular ? 75 : 50)) // Adjust height multiplier as needed
                                .cornerRadius(horizontalSizeClass == .regular ? 22.5 : 15)
                                .padding(.bottom, 5)
                            
                            Text("\(formattedMonth(mood.day))")
                                .font(.system(size: horizontalSizeClass == .regular ? 18 : 12, weight: .bold))
                                .foregroundColor(.white)
                            
                            Text("\(formattedDay(mood.day))")
                                .font(.system(size: horizontalSizeClass == .regular ? 18 : 12, weight: .bold))
                                .foregroundColor(.white)
                        }
                    }
                }
                .padding()
            }
        }
        .onAppear {
            loadMoodsFromFirebase()
        }
    }

    func loadMoodsFromFirebase() {
        guard let uid = Auth.auth().currentUser?.uid else {
            print("User is not logged in")
            return
        }
        
        let db = Firestore.firestore()
        let moodsRef = db.collection("users").document(uid).collection("moods")
        
        moodsRef.order(by: FieldPath.documentID(), descending: true).limit(to: 7).getDocuments { querySnapshot, error in
            if let error = error {
                print("Failed to fetch moods: \(error)")
                return
            }
            
            guard let querySnapshot = querySnapshot else {
                print("No snapshot found")
                return
            }
            
            var fetchedMoods: [Mood] = []
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            
            for document in querySnapshot.documents {
                let documentID = document.documentID
                let moodData = document.data()
                print("Document data: \(moodData)")
                
                guard let date = dateFormatter.date(from: documentID) else {
                    print("Invalid date format in document ID")
                    continue
                }
                guard let mood = moodData["mood"] as? String else {
                    print("Mood field missing or not a String")
                    continue
                }
                
                let moodCount = moodToLevel(mood: mood)
                
                let moodEntry = Mood(day: date, moodCount: moodCount)
                fetchedMoods.append(moodEntry)
                print("Mood added: \(moodEntry)")
            }
            
            fetchedMoods.sort { $0.day < $1.day }
            
            DispatchQueue.main.async {
                self.moods = fetchedMoods
                print("Moods array: \(self.moods)")
            }
        }
    }
    
    private func moodToLevel(mood: String) -> Int {
        switch mood {
        case "Happy":
            return 3
        case "Neutral":
            return 2
        case "Sad":
            return 1
        default:
            return 0 // Default mood count, adjust as needed
        }
    }
    
    private func formattedMonth(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM"
        return dateFormatter.string(from: date)
    }
    
    private func formattedDay(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd"
        return dateFormatter.string(from: date)
    }
    
    private func barColor(for moodCount: Int) -> Color {
        switch moodCount {
        case 3:
            return Color.white.opacity(0.7)
        case 2:
            return Color.white.opacity(0.7)
        case 1:
            return Color.white.opacity(0.7)
        default:
            return Color.gray // Default color, adjust as needed
        }
    }
}

struct MoodGraphView_Previews: PreviewProvider {
    static var previews: some View {
        MoodGraphView()
    }
}

struct Mood {
    let day: Date
    let moodCount: Int
}
