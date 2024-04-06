import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct Journal: View {
    @State private var selectedDate: Date = Date()
    @State private var note: String = ""
    @State private var isNoteSaved: Bool = false
    @State private var datesWithNotes: [String] = [] // Keep track of dates with notes

    var body: some View {
        VStack {
            Spacer()
                

            Text("Journal") // Title label
                .font(.largeTitle) // Reduce font size
                .fontWeight(.bold)
                .padding(.top, 10)
                .padding(.horizontal)

            DatePicker("Select a date", selection: $selectedDate, displayedComponents: .date)
                .datePickerStyle(GraphicalDatePickerStyle())
                .padding(.horizontal, 20) // Add horizontal padding
                .onChange(of: selectedDate) { _ in
                    // Load the note for the selected date
                    loadNote()
                }

            TextEditor(text: $note)
                .frame(
                    width: UIScreen.main.bounds.width - 80, // Reduce width
                    height: 140 // Reduce height
                )
                .padding()
                .background(Color.white)
                .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.blue, lineWidth: 2)
                )
                .padding()
                .padding(.horizontal, 15)

            Button(action: {
                saveNote()
            }) {
                Text("Save Note")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            .padding()
            .alert(isPresented: $isNoteSaved) {
                Alert(
                    title: Text("Note Saved Successfully!"),
                    message: Text("Your note has been saved."),
                    dismissButton: .default(Text("OK"))
                )
            }
            
        }
        .padding()
        .onAppear {
            // Load the note for the initially selected date
            loadNote()
        }
        .onDisappear {
            // Perform any additional actions before the view disappears
        }
    }

    func saveNote() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let db = Firestore.firestore()

        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let dateString = formatter.string(from: selectedDate)

        db.collection("users").document(uid).collection("notes").document(dateString).setData([
            "note": note
        ]) { error in
            if let error = error {
                print("Failed to save note: \(error)")
            } else {
                print("Note saved successfully!")
                isNoteSaved = true // Show the success popup
                // Update the list of dates with notes
                if !datesWithNotes.contains(dateString) {
                    datesWithNotes.append(dateString)
                }
            }
        }
    }

    func loadNote() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let db = Firestore.firestore()

        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let dateString = formatter.string(from: selectedDate)

        db.collection("users").document(uid).collection("notes").document(dateString).getDocument { document, error in
            if let error = error {
                print("Failed to fetch note: \(error)")
            } else if let document = document, document.exists {
                if let noteData = document.data()?["note"] as? String {
                    note = noteData
                }
            } else {
                // If there is no note for the selected date, clear the note field
                note = ""
            }
        }
    }
}

struct Journal_Previews: PreviewProvider {
    static var previews: some View {
        Journal()
    }
}
