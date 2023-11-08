import SwiftUI

struct CalendarView: View {
    @State private var selectedDate: Date = Date()

    var body: some View {
        VStack {
            DatePicker("Select a date", selection: $selectedDate, displayedComponents: .date)
                .datePickerStyle(GraphicalDatePickerStyle())
               
            
            Text("Selected Date: \(selectedDate, formatter: dateFormatter)")
                .font(.subheadline)
                
        }
        .padding()
    }
}

// DateFormatter for displaying the selected date
private let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    formatter.timeStyle = .none
    return formatter
}()

struct CalendarDatePickerView_Previews: PreviewProvider {
    static var previews: some View {
        CalendarView()
    }
}
