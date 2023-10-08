import SwiftUI
import FirebaseAuth

struct landing: View {
    var body: some View {
        NavigationView {
            VStack {
                Text("Welcome to CalmCampus!")
                    .padding(.top,50)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                    .padding()
                
                Text("Let's get started with your sign-up.")
                    .font(.headline)
                    .foregroundColor(.secondary)
                    .padding()
                Spacer()
                NavigationLink(destination: NameInputView()) {
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
                    
                    NavigationLink(destination: LoginView()) {
                        Text("Log In")
                            .padding(.top, 10)
                            .font(.headline)
                            .foregroundColor(.blue) // Use a less prominent color for the login button
                    }
                }
                .padding(.bottom, 20)
            }
            .padding()
        }
    }
}


struct NameInputView: View {
    @State private var name = ""
    
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
            
            NavigationLink(destination: EmailInputView(name: name)) {
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
            
            NavigationLink(destination: PasswordSetupView(name: name, email: email)) {
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
    let name: String
    let email: String
    
    var body: some View {
        VStack {
            Text("Create a password")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding()
            
            SecureField("Password", text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            Button(action: {
                Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                    if let error = error {
                        // Handle sign-up error
                        print("Sign-up error: \(error.localizedDescription)")
                    } else {
                        // Sign-up successful, navigate to the next screen or log the user in
                        // You can use NavigationLink or other navigation techniques here
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
                Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
                    if let error = error {
                        // Handle login error
                        print("Login error: \(error.localizedDescription)")
                    } else {
                        // Login successful, navigate to the next screen
                        // You can use NavigationLink or other navigation techniques here
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

        }
        .padding()
    }
}

struct welcomeview_Previews: PreviewProvider {
    static var previews: some View {
        landing()
    }
}
