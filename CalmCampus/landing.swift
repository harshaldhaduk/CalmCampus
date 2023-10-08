import SwiftUI
import FirebaseAuth

struct landing: View {
    // Add an @State variable to track whether the user is signed in
    @State private var isSignedIn = false

    var body: some View {
        NavigationView {
            VStack {
                Text("Welcome to CalmCampus!")
                    .padding(.top, 50)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                    .padding()

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
                        .background(Color.blue)
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
                            .foregroundColor(.blue) // Use a less prominent color for the login button
                    }
                }
                .padding(.bottom, 20)
            }
            .padding()
            .fullScreenCover(isPresented: $isSignedIn, content: {
                ContentView()
            })
        }
    }
}

struct NameInputView: View {
    @State private var name = ""
    @Binding var isSignedIn: Bool // Pass the binding to track sign-in state

    var body: some View {
        VStack {
            Text("It's great to see you! What do your friends call you?")
                .multilineTextAlignment(.center)
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding()

            TextField("Your nickname", text: $name)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            NavigationLink(destination: EmailInputView(name: name, isSignedIn: $isSignedIn)) {
                Text("Next")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
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
    @Binding var isSignedIn: Bool // Pass the binding to track sign-in state

    var body: some View {
        VStack {
            Text("What email do you want to use to sign in?")
                .multilineTextAlignment(.center)
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding()

            TextField("Email", text: $email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            NavigationLink(destination: PasswordSetupView(name: name, email: email, isSignedIn: $isSignedIn)) {
                Text("Next")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
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
    @Binding var isSignedIn: Bool // Pass the binding to track sign-in state

    // Add state variables to track password validation
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
                .padding()

            SecureField("Confirm Password", text: $confirmPassword)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            // Password validation messages
            if !isPasswordValid {
                Text("Password should be at least 6 characters long")
                    .foregroundColor(.red)
            }

            if !isPasswordsMatching {
                Text("Passwords don't match")
                    .foregroundColor(.red)
            }

            Button(action: {
                // Validate password length
                if password.count < 6 {
                    isPasswordValid = false
                    isPasswordsMatching = true
                }
                // Validate password match
                else if password != confirmPassword {
                    isPasswordValid = true
                    isPasswordsMatching = false
                } else {
                    isPasswordValid = true
                    isPasswordsMatching = true

                    // Proceed with sign-up
                    Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                        if let error = error {
                            // Handle sign-up error
                            print("Sign-up error: \(error.localizedDescription)")
                        } else {
                            // Sign-up successful, set isSignedIn to true to navigate to the home page
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
                    .background(Color.green)
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
    @Binding var isSignedIn: Bool // Pass the binding to track sign-in state

    // Add state variables for error messages
    @State private var isInvalidEmail = false
    @State private var isInvalidPassword = false
    @State private var loginErrors: [String] = []

    var body: some View {
        VStack {
            Text("Log in to CalmCampus")
                .multilineTextAlignment(.center)
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding()

            TextField("Email", text: $email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            SecureField("Password", text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            Button(action: {
                // Reset error flags
                isInvalidEmail = false
                isInvalidPassword = false
                loginErrors.removeAll()

                Auth.auth().signIn(withEmail: email, password: password) { authResult, loginError in
                    if let loginError = loginError as NSError? {
                        // Handle login error and collect error messages
                        let errorMessage = "Login error: \(loginError.localizedDescription)"
                        print(errorMessage)
                        loginErrors.append(errorMessage)

                        // Present the alert on the main thread
                        DispatchQueue.main.async {
                            isInvalidEmail = true
                        }
                    } else {
                        // Login successful, set isSignedIn to true to navigate to the home page
                        isSignedIn = true
                    }
                }
            }) {
                Text("Log In")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.green)
                    .cornerRadius(10)
                    .padding(.horizontal, 20)
            }

            // Display invalid email or password error message
            if isInvalidPassword {
                Text("Incorrect password")
                    .foregroundColor(.red)
                    .padding(.top, 10) // Adjust the top padding to position the message
            }
        }
        .padding()
        .alert(isPresented: $isInvalidEmail) {
            Alert(
                title: Text("Oops!"),
                message: Text(loginErrors.joined(separator: "\n")),
                dismissButton: .default(Text("OK"))
            )

        }
    }
}

struct welcomeview_Previews: PreviewProvider {
    static var previews: some View {
        landing()
    }
}
