import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct CalendarView: View {
    @State private var selectedDate: Date = Date()
    @State private var moodColor: Color = .blue // Default color

    var body: some View {
        NavigationView {
            ZStack {
                // Grey box behind the elements
                Rectangle()
                    .foregroundColor(Color.white) // Adjust opacity and color as needed
                    .cornerRadius(10) // Adjust corner radius as needed
                    .frame(height: 430)
                    .frame(width: 350)
                    .shadow(radius: 5)
                
                VStack {
                    Text("Mood Tracker ")
                        .font(.title)
                        .fontWeight(.semibold)
                        
                    
                    DatePicker("Select a date", selection: $selectedDate, displayedComponents: .date)
                        .datePickerStyle(GraphicalDatePickerStyle())
                    
                    Text("Selected Date: \(selectedDate, formatter: dateFormatter)")
                        .font(.subheadline)
                }
                .padding()
            }
            .navigationBarTitle("", displayMode: .inline) // Hide default navigation title
        }
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
