import SwiftUI
import FirebaseAuth
import FirebaseFirestore
import Combine

struct Journal: View {
    @State private var selectedDate: Date = Date()
    @State private var note: String = ""
    @State private var isNoteSaved: Bool = false
    @State private var datesWithNotes: [String] = [] // Keep track of dates with notes
    @State private var keyboardHeight: CGFloat = 0
    @State private var cancellable: AnyCancellable?

    var body: some View {
        ScrollViewReader { proxy in
            ScrollView {
                VStack {
                    Text("Journal") // Title label
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .padding(.top, 10)
                        .padding(.horizontal)

                    DatePicker("Select a date", selection: $selectedDate, displayedComponents: .date)
                        .datePickerStyle(GraphicalDatePickerStyle())
                        .frame(height: 400) // Ensure enough height for DatePicker
                        .padding(.horizontal, 20) // Add horizontal padding
                        .onChange(of: selectedDate) { _ in
                            // Load the note for the selected date
                            loadNote()
                        }

                    TextEditor(text: $note)
                        .frame(
                            width: UIScreen.main.bounds.width - 65,
                            height: 140
                        )
                        .background(Color(UIColor.secondarySystemBackground)) // This only changes the background of the TextEditor frame
                        .cornerRadius(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.blue, lineWidth: 2)
                        )
                        .padding()
                        .padding(.horizontal, 15)
                        .id("editor") // Adding an ID to the TextEditor

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
                    .id("button") // Adding an ID to the button
                }
                .padding(.top, 30)
                .padding(.bottom, keyboardHeight + 30) // Adjust padding based on keyboard height
                .onChange(of: keyboardHeight) { _ in
                    withAnimation {
                        proxy.scrollTo("button", anchor: .bottom)
                    }
                }
            }
            .background(Color(UIColor.secondarySystemBackground)).edgesIgnoringSafeArea(.all)
            .onAppear {
                // Load the note for the initially selected date
                loadNote()
                startKeyboardObserving() // Start observing the keyboard
            }
            .onDisappear {
                // Perform any additional actions before the view disappears
                stopKeyboardObserving() // Stop observing the keyboard
            }
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

    // Keyboard Observing Methods
    func startKeyboardObserving() {
        cancellable = NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification)
            .merge(with: NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification))
            .compactMap { notification in
                if notification.name == UIResponder.keyboardWillShowNotification {
                    return (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect)?.height
                } else {
                    return 0
                }
            }
            .assign(to: \.keyboardHeight, on: self)
    }

    func stopKeyboardObserving() {
        cancellable?.cancel()
    }
}

struct Journal_Previews: PreviewProvider {
    static var previews: some View {
        Journal()
    }
}
