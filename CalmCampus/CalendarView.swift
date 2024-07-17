import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct CalendarView: View {
    @State private var currentDate: Date = Date()
    @State private var selectedDate: Date = Date()
    @Environment(\.horizontalSizeClass) var horizontalSizeClass

    var body: some View {
        let isRegularSizeClass = horizontalSizeClass == .regular
        let scaleFactor: CGFloat = isRegularSizeClass ? 1.5 : 1.0

        ZStack {
            VStack {
                Spacer() // Add spacer above the VStack

                Text("Mood Tracker ")
                    .font(.system(size: 24 * scaleFactor))
                    .fontWeight(.semibold)

                // Display the selected date
                Text("Selected Date: \(selectedDate, formatter: dateFormatter)")
                    .font(.system(size: 14 * scaleFactor))
                    .padding(.top, 10 * scaleFactor)
                    .padding(.bottom, 1 * scaleFactor)

                // Navigation buttons for month and year
                HStack {
                    Button(action: {
                        currentDate = Calendar.current.date(byAdding: .month, value: -1, to: currentDate)!
                    }) {
                        Image(systemName: "chevron.left.circle")
                            .font(.system(size: 24 * scaleFactor))
                    }
                    Text("\(currentDate, formatter: monthYearFormatter)")
                        .font(.system(size: 24 * scaleFactor))
                        .fontWeight(.medium)
                    Button(action: {
                        currentDate = Calendar.current.date(byAdding: .month, value: 1, to: currentDate)!
                    }) {
                        Image(systemName: "chevron.right.circle")
                            .font(.system(size: 24 * scaleFactor))
                    }
                }
                .padding(.horizontal)
                .padding(.bottom, 40)

                // Calendar grid
                CalendarGridView(currentDate: $currentDate, selectedDate: $selectedDate, scaleFactor: scaleFactor)

                Spacer() // Add spacer below the VStack
            }
            .padding()
        }
    }
}

struct CalendarGridView: View {
    @Binding var currentDate: Date
    @Binding var selectedDate: Date
    let scaleFactor: CGFloat

    var body: some View {
        VStack {
            // Header with abbreviated days of the week
            HStack {
                ForEach(["S", "M", "T", "W", "T", "F", "S"], id: \.self) { day in
                    Spacer()
                    Text(day)
                        .font(.system(size: 14 * scaleFactor))
                        .fontWeight(.bold)
                        .frame(width: 30 * scaleFactor, height: 30 * scaleFactor)
                        .background(Color.blue.opacity(0.7))
                        .clipShape(Circle())
                        .foregroundColor(.white)
                }
                Spacer()
            }

            // Calendar grid
            VStack(spacing: 5 * scaleFactor) {
                ForEach(getCalendarMatrix(), id: \.self) { week in
                    HStack {
                        ForEach(week, id: \.self) { date in
                            Spacer()
                            DateCell(date: date, selectedDate: $selectedDate, scaleFactor: scaleFactor)
                        }
                        Spacer()
                    }
                }
            }
        }
    }

    // Generate a matrix representing the calendar
    private func getCalendarMatrix() -> [[Date?]] {
        let calendar = Calendar.current
        var matrix: [[Date?]] = []

        var dateComponents = calendar.dateComponents([.year, .month, .day], from: currentDate)
        dateComponents.day = 1
        let firstDayOfMonth = calendar.date(from: dateComponents)!

        let startOfWeekday = calendar.component(.weekday, from: firstDayOfMonth)
        let daysInMonth = calendar.range(of: .day, in: .month, for: firstDayOfMonth)!.count

        var week: [Date?] = Array(repeating: nil, count: startOfWeekday - 1)

        for day in 1...daysInMonth {
            dateComponents.day = day
            let date = calendar.date(from: dateComponents)
            week.append(date)

            if week.count == 7 {
                matrix.append(week)
                week = []
            }
        }

        if !week.isEmpty {
            if week.count < 7 {
                let remainingDays = 7 - week.count
                for _ in 0..<remainingDays {
                    week.append(nil)
                }
            }
            matrix.append(week)
        }

        return matrix
    }
}

struct DateCell: View {
    let date: Date?
    @Binding var selectedDate: Date
    @State private var moodColor: Color = .clear
    let scaleFactor: CGFloat

    var body: some View {
        Button(action: {
            if let date = date {
                selectedDate = date
            }
        }) {
            Text(date.map { "\(Calendar.current.component(.day, from: $0))" } ?? "")
                .frame(width: 30 * scaleFactor, height: 30 * scaleFactor)
                .background(moodColor)
                .clipShape(Circle())
                .foregroundColor(.primary)
        }
        .onAppear {
            loadMood(for: date)
        }
    }

    func loadMood(for date: Date?) {
        guard let date = date, date < Date() else { return } // Only consider past dates
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let dateString = formatter.string(from: date)

        if let uid = Auth.auth().currentUser?.uid {
            let db = Firestore.firestore()
            let moodRef = db.collection("users").document(uid).collection("moods").document(dateString)

            moodRef.getDocument { document, error in
                if let error = error {
                    print("Failed to fetch mood: \(error)")
                } else if let document = document, document.exists {
                    if let mood = document.data()?["mood"] as? String {
                        DispatchQueue.main.async {
                            updateMoodColor(mood)
                        }
                    }
                } else {
                    DispatchQueue.main.async {
                        if dateString == formatter.string(from: Date()) {
                            moodColor = Color.blue.opacity(0.7) // Set the current date to blue if no mood is detected
                        } else {
                            moodColor = Color.gray.opacity(0.2) // Set a lighter shade of grey for past days with no recorded mood
                        }
                    }
                }
            }
        }
    }

    func updateMoodColor(_ mood: String) {
        switch mood {
        case "Happy":
            moodColor = Color.green.opacity(0.8)
        case "Neutral":
            moodColor = Color.yellow.opacity(0.7)
        case "Sad":
            moodColor = Color.red.opacity(0.8)
        default:
            moodColor = Color.blue.opacity(0.7)
        }
    }
}

extension Date {
    func isEqual(to otherDate: Date) -> Bool {
        let calendar = Calendar.current
        return calendar.isDate(self, inSameDayAs: otherDate)
    }
}

// DateFormatter for displaying the selected date
private let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    formatter.timeStyle = .none
    return formatter
}()

// DateFormatter for displaying month and year
private let monthYearFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "MMMM yyyy"
    return formatter
}()

struct CalendarView_Previews: PreviewProvider {
    static var previews: some View {
        CalendarView()
    }
}
