import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct landing: View {
    @State private var isSignedIn = false

    var body: some View {
        NavigationStack {
            VStack {
                Image("logo")
                    .resizable()
                    .frame(width: 250, height: 250)
                    .clipped()

                Text("Welcome to CalmCampus!")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                    .padding(.bottom, 1)

                Text("Let's get started with your sign-up.")
                    .font(.headline)
                    .foregroundColor(.secondary)
                    .padding()
                Spacer()
                NavigationLink(destination: NameInputView(isSignedIn: $isSignedIn)) {
                    Text("Next")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue.opacity(0.7))
                        .cornerRadius(10)
                        .padding(.horizontal, 20)
                }

                HStack {
                    Text("Have an Account?")
                        .padding(.top, 10)
                        .font(.headline)
                        .foregroundColor(.secondary)

                    NavigationLink(destination: LoginView(isSignedIn: $isSignedIn)) {
                        Text("Log In")
                            .padding(.top, 10)
                            .font(.headline)
                            .foregroundColor(.blue.opacity(0.7))
                    }
                }
                .padding(.bottom, 20)
            }
            .padding()
        }
        .fullScreenCover(isPresented: $isSignedIn) {
            ContentView()
        }
        .onAppear {
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                windowScene.windows.first?.overrideUserInterfaceStyle = .light
            }
        }
    }
}

struct NameInputView: View {
    @State private var name = ""
    @Binding var isSignedIn: Bool

    var body: some View {
        VStack {
            if #available(iOS 16.0, *) {
                Text("It's great to see you! What would you like to be called?")
                    .multilineTextAlignment(.center)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding()
            } else {
                Text("It's great to see you! What would you like to be called?")
                    .multilineTextAlignment(.center)
                    .font(.system(size: 34, weight: .bold, design: .default))
                    .padding()
            }

            TextField("Your nickname", text: $name)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            NavigationLink(destination: EmailInputView(name: name, isSignedIn: $isSignedIn)) {
                Text("Next")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue.opacity(0.7))
                    .cornerRadius(10)
                    .padding(.horizontal, 20)
            }
        }
        .padding()
    }
}

struct EmailInputView: View {
    @State private var email = ""
    let name: String
    @Binding var isSignedIn: Bool

    var body: some View {
        VStack {
            if #available(iOS 16.0, *) {
                Text("What email do you want to use to sign in?")
                    .multilineTextAlignment(.center)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding()
            } else {
                Text("What email do you want to use to sign in?")
                    .multilineTextAlignment(.center)
                    .font(.largeTitle)
                    .font(.system(size: 34, weight: .bold, design: .default))
                    .padding()
            }

            TextField("Email", text: $email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            NavigationLink(destination: PasswordSetupView(name: name, email: email, isSignedIn: $isSignedIn)) {
                Text("Next")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue.opacity(0.7))
                    .cornerRadius(10)
                    .padding(.horizontal, 20)
            }
        }
        .padding()
    }
}

struct PasswordSetupView: View {
    @State private var password = ""
    @State private var confirmPassword = ""
    let name: String
    let email: String
    @Binding var isSignedIn: Bool

    @State private var isPasswordValid = true
    @State private var isPasswordsMatching = true

    var body: some View {
        VStack {
            Text("Create a password")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding()

            SecureField("Password", text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)
                .padding(.top, 30)

            SecureField("Confirm Password", text: $confirmPassword)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.bottom, 25)
                .padding(.horizontal)
                .padding(.top, 5)
            
            if !isPasswordValid {
                Text("Password should be at least 6 characters long")
                    .foregroundColor(.red)
            }

            if !isPasswordsMatching {
                Text("Passwords don't match")
                    .foregroundColor(.red)
            }

            Button(action: {
                if password.count < 6 {
                    isPasswordValid = false
                    isPasswordsMatching = true
                } else if password != confirmPassword {
                    isPasswordValid = true
                    isPasswordsMatching = false
                } else {
                    isPasswordValid = true
                    isPasswordsMatching = true

                    Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                        if let error = error {
                            print("Sign-up error: \(error.localizedDescription)")
                        } else {
                            if let uid = Auth.auth().currentUser?.uid {
                                let db = Firestore.firestore()
                                let userRef = db.collection("users").document(uid)

                                userRef.setData(["nickname": name, "isDarkMode": false]) { error in
                                    if let error = error {
                                        print("Error storing user data in Firestore: \(error.localizedDescription)")
                                    } else {
                                        print("User data successfully stored in Firestore")
                                    }
                                }
                            } else {
                                print("Unable to obtain the user's UID")
                            }

                            isSignedIn = true
                        }
                    }
                }
            }) {
                Text("Sign Up")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.green.opacity(0.7))
                    .cornerRadius(10)
                    .padding(.horizontal, 20)
            }
        }
        .padding()
    }
}

struct LoginView: View {
    @State private var email = ""
    @State private var password = ""
    @Binding var isSignedIn: Bool

    @State private var isInvalidEmail = false
    @State private var isInvalidPassword = false
    @State private var loginErrors: [String] = []

    var body: some View {
        VStack {
            if #available(iOS 16.0, *) {
                Text("Log in to CalmCampus")
                    .multilineTextAlignment(.center)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding()
            } else {
                Text("Log in to CalmCampus")
                    .multilineTextAlignment(.center)
                    .font(.largeTitle)
                    .font(.system(size: 34, weight: .bold, design: .default))
                    .padding()
            }

            TextField("Email", text: $email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)
                .padding(.top, 30)

            SecureField("Password", text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.bottom, 25)
                .padding(.horizontal)
                .padding(.top, 5)

            Button(action: {
                isInvalidEmail = false
                isInvalidPassword = false
                loginErrors.removeAll()

                Auth.auth().signIn(withEmail: email, password: password) { authResult, loginError in
                    if let loginError = loginError as NSError? {
                        let errorMessage = "Login error: \(loginError.localizedDescription)"
                        print(errorMessage)
                        loginErrors.append(errorMessage)

                        DispatchQueue.main.async {
                            isInvalidEmail = true
                        }
                    } else {
                        if let uid = Auth.auth().currentUser?.uid {
                            let db = Firestore.firestore()
                            let userRef = db.collection("users").document(uid)

                            userRef.getDocument { document, error in
                                if let document = document, document.exists {
                                    if let isDarkMode = document.data()?["isDarkMode"] as? Bool {
                                        UserDefaults.standard.set(isDarkMode, forKey: "isDarkMode")
                                        
                                        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                                            windowScene.windows.first?.overrideUserInterfaceStyle = isDarkMode ? .dark : .light
                                        }
                                    }
                                } else {
                                    print("Document does not exist")
                                }
                            }
                        }
                        isSignedIn = true
                    }
                }
            }) {
                Text("Log In")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.green.opacity(0.7))
                    .cornerRadius(10)
                    .padding(.horizontal, 20)
            }

            if isInvalidPassword {
                Text("Incorrect password")
                    .foregroundColor(.red)
                    .padding(.top, 10)
            }
        }
        .padding()
        .alert(isPresented: $isInvalidEmail) {
            Alert(
                title: Text("Sorry, Incorrect Information!"),
                message: Text(loginErrors.joined(separator: "\n")),
                dismissButton: .default(Text("OK"))
            )
        }
    }
}

struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        landing()
    }
}
