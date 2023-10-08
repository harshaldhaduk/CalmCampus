import SwiftUI

struct welcome: View {
    var body: some View {
        NavigationView { // Wrap the entire welcome view in a NavigationView
            VStack {
                Text("CalmCampus")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.top, 40)
                
                Spacer()

                VStack {
                    Text("Have an Account?")
                        .font(.headline)
                        .padding()
                    
                    NavigationLink(destination: LoginView()) {
                        Text("Login")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.blue)
                            .cornerRadius(10)
                            .padding(.horizontal, 20)
                    }
                }

                VStack {
                    Text("New to CalmCampus?")
                        .font(.headline)
                        .padding()
                    
                    NavigationLink(destination: SignupView()) {
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
                Spacer().frame(height: 30)
            }
            .padding()
        }
    }
}

struct LoginView: View {
    @State private var username = ""
    @State private var password = ""
    @State private var isShowingAlert = false

    var body: some View {
        VStack {
            Text("Login")
                .padding(.top, 10)
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.bottom, 40)

            TextField("Username", text: $username)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            SecureField("Password", text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            Button(action: {
                // Add your login logic here
                if username.isEmpty || password.isEmpty {
                    isShowingAlert = true
                } else {
                    // Perform login action
                }
            }) {
                Text("Login")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .cornerRadius(10)
                    .padding(.horizontal, 20)
            }
            .alert(isPresented: $isShowingAlert) {
                Alert(
                    title: Text("Login Error"),
                    message: Text("Please enter both username and password."),
                    dismissButton: .default(Text("OK"))
                )
            }

            Spacer()
        }
        .padding()
    }
}

struct SignupView: View {
    @State private var username = ""
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var isShowingAlert = false
    @State private var errorMessage = ""

    var body: some View {
        VStack {
            Text("Sign Up")
                .padding(.top, 40)
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.bottom, 20)

            TextField("Username", text: $username)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            TextField("Email", text: $email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            SecureField("Password", text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            SecureField("Confirm Password", text: $confirmPassword)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            Button(action: {
                // Add your signup logic here
                if username.isEmpty || email.isEmpty || password.isEmpty || confirmPassword.isEmpty {
                    isShowingAlert = true
                    errorMessage = "Please fill in all fields."
                } else if password != confirmPassword {
                    isShowingAlert = true
                    errorMessage = "Passwords do not match."
                } else {
                    // Perform signup action
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
            .alert(isPresented: $isShowingAlert) {
                Alert(
                    title: Text("Signup Error"),
                    message: Text(errorMessage),
                    dismissButton: .default(Text("OK"))
                )
            }

            Spacer()
        }
        .padding()
    }
}


struct welcome_Previews: PreviewProvider {
    static var previews: some View {
        welcome()
    }
}


