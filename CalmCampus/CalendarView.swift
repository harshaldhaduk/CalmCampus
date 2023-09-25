import SwiftUI

struct CalendarView: View {
    @State private var currentDate: Date = Date()
    @State private var selectedDate: Date = Date()

    var body: some View {
        VStack {
            Text("Calendar")
                .font(.title)
                .padding(.top, 20)

            // Display the selected date
            Text("Selected Date: \(selectedDate, formatter: dateFormatter)")
                .font(.subheadline)
                .padding(.top, 10)

            // Navigation buttons for month and year
            HStack {
                Button(action: {
                    currentDate = Calendar.current.date(byAdding: .month, value: -1, to: currentDate)!
                }) {
                    Image(systemName: "chevron.left.circle")
                        .font(.title)
                }

                Text("\(currentDate, formatter: monthYearFormatter)")
                    .font(.title)

                Button(action: {
                    currentDate = Calendar.current.date(byAdding: .month, value: 1, to: currentDate)!
                }) {
                    Image(systemName: "chevron.right.circle")
                        .font(.title)
                }
            }
            .padding(.horizontal)

            // Calendar grid
            CalendarGridView(currentDate: $currentDate, selectedDate: $selectedDate)
            Spacer()
        }
        .padding()
    }
}

struct CalendarGridView: View {
    @Binding var currentDate: Date
    @Binding var selectedDate: Date

    var body: some View {
        VStack {
            // Header with abbreviated days of the week
            HStack {
                ForEach(["S", "M", "T", "W", "T", "F", "S"], id: \.self) { day in
                    Spacer()
                    Text(day)
                        .font(.headline)
                        .fontWeight(.bold)
                        .frame(width: 30, height: 30)
                        .background(Color.blue)
                        .clipShape(Circle())
                        .foregroundColor(.white)
                }
                Spacer()
            }

            // Calendar grid
            VStack(spacing: 5) {
                ForEach(getCalendarMatrix(), id: \.self) { week in
                    HStack {
                        ForEach(week, id: \.self) { date in
                            Spacer()
                            DateCell(date: date, selectedDate: $selectedDate)
                        }
                        Spacer()
                    }
                }
            }
        }
    }

    // Generate a matrix representing the calendar
    private func getCalendarMatrix() -> [[Date]] {
        let calendar = Calendar.current
        var matrix: [[Date]] = []

        var dateComponents = calendar.dateComponents([.year, .month, .day], from: currentDate)
        dateComponents.day = 1
        let firstDayOfMonth = calendar.date(from: dateComponents)!

        let startOfWeekday = calendar.component(.weekday, from: firstDayOfMonth)
        let daysInMonth = calendar.range(of: .day, in: .month, for: firstDayOfMonth)!.count

        var week: [Date] = Array(repeating: Date(), count: startOfWeekday - 1)

        for day in 1...daysInMonth {
            dateComponents.day = day
            let date = calendar.date(from: dateComponents)!
            week.append(date)

            if week.count == 7 {
                matrix.append(week)
                week = []
            }
        }

        if !week.isEmpty {
            if week.count < 7 {
                let remainingDays = 7 - week.count
                let lastDay = week.last!
                for _ in 0..<remainingDays {
                    let nextDay = calendar.date(byAdding: .day, value: 1, to: lastDay)!
                    week.append(nextDay)
                }
            }
            matrix.append(week)
        }

        return matrix
    }
}

struct DateCell: View {
    let date: Date
    @Binding var selectedDate: Date

    var body: some View {
        Button(action: {
            selectedDate = date
        }) {
            Text("\(Calendar.current.component(.day, from: date))")
                .frame(width: 30, height: 30)
                .background(date.isEqual(to: selectedDate) ? Color.blue : Color.clear)
                .clipShape(Circle())
                .foregroundColor(date.isEqual(to: selectedDate) ? .white : .primary)
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
