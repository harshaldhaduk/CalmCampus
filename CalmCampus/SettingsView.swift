import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct SettingsView: View {
    @State private var showChangeNickname: Bool = false
    @State private var newNickname = ""
    @State private var showChangeEmail = false
    @State private var newEmail = ""
    @State private var showChangePassword = false
    @State private var newPassword = ""
    @State private var confirmPassword = ""
    @State private var showAlert: Bool = false
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    @State private var showAbout = false
    @State private var isDarkMode = UserDefaults.standard.bool(forKey: "isDarkMode")
    @State private var passwordMismatch = false
    @State private var showDeleteAccountConfirmation: Bool = false
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("User Settings")) {
                    Button(action: {
                        showChangeNickname = true
                    }) {
                        Text("Change Nickname")
                    }
                    
                    Button(action: {
                        showChangeEmail = true
                    }) {
                        Text("Change Email")
                    }

                    Button(action: {
                        showChangePassword = true
                    }) {
                        Text("Change Password")
                    }
                }
                
                Section(header: Text("Information")) {
                    Button(action: {
                        showAbout = true
                    }) {
                        Text("About CalmCampus")
                    }
                }
                
                Section(header: Text("App Preferences")) {
                    Toggle(isOn: $isDarkMode) {
                        Text("Dark Mode")
                    }
                    .onChange(of: isDarkMode) { value in
                        UserDefaults.standard.set(value, forKey: "isDarkMode")
                        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                            windowScene.windows.first?.overrideUserInterfaceStyle = value ? .dark : .light
                        }
                        saveDarkModePreference(value)
                    }
                }
                
                Section {
                    Button(action: logout) {
                        Text("Logout")
                            .foregroundColor(.red)
                    }
                }

                Section {
                    Button(action: {
                        showDeleteAccountConfirmation = true
                    }) {
                        Text("Delete Account")
                            .foregroundColor(.red)
                    }
                }
            }
            .navigationBarTitle("Settings")
            .onAppear {
                if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                    windowScene.windows.first?.overrideUserInterfaceStyle = isDarkMode ? .dark : .light
                }
            }
            .sheet(isPresented: $showChangeNickname) {
                NavigationView {
                    Form {
                        Section(header: Text("New Nickname")) {
                            TextField("Enter new nickname", text: $newNickname)
                        }
                        
                        Section {
                            Button("Save") {
                                saveNickname()
                            }
                        }
                    }
                    .navigationBarTitle("Change Nickname", displayMode: .inline)
                    .navigationBarItems(trailing: Button("Cancel") {
                        showChangeNickname = false
                    })
                }
            }
            .sheet(isPresented: $showChangeEmail) {
                NavigationView {
                    Form {
                        Section(header: Text("New Email")) {
                            TextField("Enter new email", text: $newEmail)
                                .keyboardType(.emailAddress)
                                .autocapitalization(.none)
                        }
                        
                        Section {
                            Button("Save") {
                                saveEmail()
                            }
                        }
                    }
                    .navigationBarTitle("Change Email", displayMode: .inline)
                    .navigationBarItems(trailing: Button("Cancel") {
                        showChangeEmail = false
                    })
                }
            }
            .sheet(isPresented: $showChangePassword) {
                NavigationView {
                    Form {
                        Section(header: Text("New Password")) {
                            SecureField("Enter new password", text: $newPassword)
                            SecureField("Confirm new password", text: $confirmPassword)
                        }
                        
                        Button("Save") {
                            if newPassword != confirmPassword {
                                passwordMismatch = true
                            } else {
                                passwordMismatch = false
                                savePassword()
                            }
                        }
                        
                        if passwordMismatch {
                            HStack {
                                Spacer ()
                                Text("Passwords do not match")
                                .foregroundColor(.red)
                                .font(.caption)
                                Spacer()
                            }
                            .listRowBackground(Color.clear)
                        }
                    }
                    .navigationBarTitle("Change Password", displayMode: .inline)
                    .navigationBarItems(trailing: Button("Cancel") {
                        showChangePassword = false
                    })
                }
            }
            .sheet(isPresented: $showAbout) {
                NavigationView {
                    Form {
                        Section(header: Text("About CalmCampus")) {
                            Text("CalmCampus is an app designed to promote wellness and mindfulness in campus life. Here you can track your activities, set goals, and learn more about how to maintain a healthy and balanced lifestyle.\n\nIf you like the app, please leave a 5 star review on the App Store! And if you've got any questions or concerns, please visit www.calmcampus.org to contact the developer!\n\nCreated by Harshal Dhaduk")
                                .padding()
                        
                            HStack {
                                Spacer ()
                                Text("Copyright © 2024 Calm Campus - All Rights Reserved.")
                                .foregroundColor(.gray)
                                .font(.caption)
                                Spacer()
                            }
                            .listRowBackground(Color.clear)
                            .padding(.top)
                        }
                    }
                    .navigationBarTitle("About CalmCampus", displayMode: .inline)
                    .navigationBarItems(trailing: Button("Done") {
                        showAbout = false
                    })
                }
            }
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text(alertTitle),
                    message: Text(alertMessage),
                    dismissButton: .default(Text("OK"))
                )
            }
            .alert(isPresented: $showDeleteAccountConfirmation) {
                Alert(
                    title: Text("Delete Account"),
                    message: Text("Are you sure you want to delete your account? This action cannot be undone."),
                    primaryButton: .destructive(Text("Yes")) {
                        deleteAccount()
                    },
                    secondaryButton: .cancel()
                )
            }
        }
    }
    
    func logout() {
        do {
            try Auth.auth().signOut()
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                if let window = windowScene.windows.first {
                    let rootView = UIHostingController(rootView: landing())
                    window.rootViewController = rootView
                    UIView.transition(with: window, duration: 0.5, options: .transitionCrossDissolve, animations: nil, completion: nil)
                    window.overrideUserInterfaceStyle = .light
                }
            }
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
    }

    func saveNickname() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let db = Firestore.firestore()
        db.collection("users").document(uid).updateData(["nickname": newNickname]) { error in
            if let error = error {
                print("Error updating nickname: \(error)")
                self.alertTitle = "Error"
                self.alertMessage = "Failed to update nickname: \(error.localizedDescription)"
            } else {
                self.alertTitle = "Name Changed Successfully!"
                self.alertMessage = "Your name has been updated. Please wait for changes to take effect."
                self.showChangeNickname = false
            }
            DispatchQueue.main.async {
                self.showAlert = true
            }
        }
    }

    func saveEmail() {
        Auth.auth().currentUser?.sendEmailVerification(beforeUpdatingEmail: newEmail) { error in
            if let error = error {
                print("Error updating email: \(error)")
                self.alertTitle = "Error"
                self.alertMessage = "Failed to update email: \(error.localizedDescription)"
            } else {
                self.alertTitle = "Email Verification Sent!"
                self.alertMessage = "Please verify your new email address. Your email will be updated after verification."
                self.showChangeEmail = false
            }
            DispatchQueue.main.async {
                self.showAlert = true
            }
        }
    }

    func savePassword() {
        Auth.auth().currentUser?.updatePassword(to: newPassword) { error in
            if let error = error {
                print("Error updating password: \(error)")
                self.alertTitle = "Error"
                self.alertMessage = "Failed to update password: \(error.localizedDescription)"
            } else {
                self.alertTitle = "Password Changed Successfully!"
                self.alertMessage = "Your password has been updated. Please wait for changes to take effect."
                self.showChangePassword = false
            }
            DispatchQueue.main.async {
                self.showAlert = true
            }
        }
    }

    func saveDarkModePreference(_ isDarkMode: Bool) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let db = Firestore.firestore()
        db.collection("users").document(uid).updateData(["isDarkMode": isDarkMode]) { error in
        }
    }

    func deleteAccount() {
        guard let user = Auth.auth().currentUser else { return }
        
        let uid = user.uid
        let db = Firestore.firestore()
        
        // Delete Firestore user data
        db.collection("users").document(uid).delete { error in
            if let error = error {
                print("Error deleting user data: \(error)")
                self.alertTitle = "Error"
                self.alertMessage = "Failed to delete user data: \(error.localizedDescription)"
                DispatchQueue.main.async {
                    self.showAlert = true
                }
                return
            }

            // Delete Firebase Auth account
            user.delete { error in
                if let error = error {
                    print("Error deleting user account: \(error)")
                    self.alertTitle = "Error"
                    self.alertMessage = "Failed to delete account: \(error.localizedDescription)"
                } else {
                    self.alertTitle = "Account Deleted"
                    self.alertMessage = "Your account has been deleted successfully."
                    self.logout()
                }
                DispatchQueue.main.async {
                    self.showAlert = true
                }
            }
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
