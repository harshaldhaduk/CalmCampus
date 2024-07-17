import SwiftUI
import Firebase

struct ActivityGraphView: View {
    @State private var activityData: [ActivityData] = []
    @State private var maxClickCounter: Int = 1 // Minimum value to prevent division by zero
    @Environment(\.horizontalSizeClass) var horizontalSizeClass

    var body: some View {
        VStack {
            if activityData.isEmpty {
                Text("Loading activity data...")
                    .padding()
            } else {
                HStack(alignment: .bottom, spacing: horizontalSizeClass == .regular ? 15 : 10) {
                    ForEach(activityData, id: \.date) { data in
                        VStack(spacing: 5) {
                            Text("\(data.clickCounter)") // Display clickCounter value
                                .font(.system(size: horizontalSizeClass == .regular ? 18 : 12, weight: .bold))
                                .foregroundColor(.white)
                            
                            Rectangle()
                                .fill(barColor(for: data.clickCounter))
                                .frame(width: horizontalSizeClass == .regular ? 52.5 : 35,
                                       height: barHeight(for: data.clickCounter)) // Adjusted height
                                .cornerRadius(horizontalSizeClass == .regular ? 22.5 : 15)
                                .padding(.bottom, 5)
                            
                            Text("\(formattedMonth(data.date))")
                                .font(.system(size: horizontalSizeClass == .regular ? 18 : 12, weight: .bold))
                                .foregroundColor(.white)
                            
                            Text("\(formattedDay(data.date))")
                                .font(.system(size: horizontalSizeClass == .regular ? 18 : 12, weight: .bold))
                                .foregroundColor(.white)
                        }
                    }
                }
                .padding()
            }
        }
        .onAppear {
            loadActivityDataFromFirebase()
        }
    }

    func loadActivityDataFromFirebase() {
        guard let uid = Auth.auth().currentUser?.uid else {
            print("User is not logged in")
            return
        }
        
        let db = Firestore.firestore()
        let activityRef = db.collection("users").document(uid).collection("activity")
        
        activityRef.order(by: FieldPath.documentID(), descending: true).limit(to: 7).getDocuments { querySnapshot, error in
            if let error = error {
                print("Failed to fetch activity data: \(error)")
                return
            }
            
            guard let querySnapshot = querySnapshot else {
                print("No activity data snapshot found")
                return
            }
            
            var fetchedActivityData: [ActivityData] = []
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            
            for document in querySnapshot.documents {
                let documentID = document.documentID
                let activityData = document.data()
                print("Document data: \(activityData)")
                
                guard let date = dateFormatter.date(from: documentID) else {
                    print("Invalid date format in document ID")
                    continue
                }
                
                let clickCounter = activityData["clickCounter"] as? Int ?? 0
                let activityEntry = ActivityData(date: date, clickCounter: clickCounter)
                fetchedActivityData.append(activityEntry)
                print("Activity data added: \(activityEntry)")
            }
            
            if let maxClickCounter = fetchedActivityData.map({ $0.clickCounter }).max() {
                self.maxClickCounter = maxClickCounter
            }
            
            fetchedActivityData.sort { $0.date < $1.date }
            
            DispatchQueue.main.async {
                self.activityData = fetchedActivityData
                print("Activity data array: \(self.activityData)")
            }
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
    
    private func barHeight(for clickCounter: Int) -> CGFloat {
        let maxHeight: CGFloat = horizontalSizeClass == .regular ? 195 : 130 // Maximum height you want the bars to reach
        let scaledHeight = CGFloat(clickCounter) / CGFloat(maxClickCounter) * maxHeight
        return scaledHeight
    }
    
    private func barColor(for clickCounter: Int) -> Color {
        switch clickCounter {
        case 0..<10:
            return Color.white.opacity(0.7)
        case 10..<20:
            return Color.white.opacity(0.7)
        case 20..<30:
            return Color.white.opacity(0.7)
        default:
            return Color.white.opacity(0.7)
        }
    }
}

struct ActivityGraphView_Previews: PreviewProvider {
    static var previews: some View {
        ActivityGraphView()
    }
}

struct ActivityData {
    let date: Date
    let clickCounter: Int
}
