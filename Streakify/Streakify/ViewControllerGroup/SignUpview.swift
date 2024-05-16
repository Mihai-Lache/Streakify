import SwiftUI
import SwiftData

struct SignUpView: View {
    @Environment(\.presentationMode) var presentationMode  // Environment property to manage view dismissal
    @Environment(\.modelContext) private var context
    @State private var name: String = ""
    @State private var username: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var confirmed_password: String = ""

    let backgroundColor = Color(red: 11 / 255, green: 37 / 255, blue: 64 / 255)
    let darkTealColor = Color(red: 5 / 255, green: 102 / 255, blue: 141 / 255)

    var body: some View {
        ZStack {
            backgroundColor.edgesIgnoringSafeArea(.all)
            VStack {
                Image("Image")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 200, height: 200)
                    .clipped()
                    .padding(.bottom, 20)

                Text("Create Your Account")
                    .font(.title) // Optional: Adjust the font size/style as needed
                    .bold()
                    .foregroundColor(.white) // Set the text color to black for better contrast
                    .padding(.bottom, 20) // Adds space below the text
                
                TextField("Name", text: $name)
                    .padding()
                    .background(Color.white.opacity(1))
                    .cornerRadius(5.0)
                    .padding(.bottom, 15)

                TextField("Username", text: $username)
                    .padding()
                    .background(Color.white.opacity(1))
                    .cornerRadius(5.0)
                    .padding(.bottom, 15)

                TextField("Email", text: $email)
                    .padding()
                    .background(Color.white.opacity(1))
                    .cornerRadius(5.0)
                    .padding(.bottom, 15)

                SecureField("Password", text: $password)
                    .padding()
                    .background(Color.white.opacity(1))
                    .cornerRadius(5.0)
                    .padding(.bottom, 15)

                SecureField("Confirm Password", text: $confirmed_password)
                    .padding()
                    .background(Color.white.opacity(1))
                    .cornerRadius(5.0)
                    .padding(.bottom, 20)

                Button("Sign Up") {
                    let namedb = $name.wrappedValue
                    let usernamedb = $username.wrappedValue
                    let emaildb = $email.wrappedValue
                    let passworddb = $password.wrappedValue
                    
                    if $name.wrappedValue == "" || $username.wrappedValue == "" || $email.wrappedValue == "" || $password.wrappedValue == "" {
                        
                    }
                    else{
                        registerUser(name: namedb, username: usernamedb, email: emaildb, password: passworddb)
                    }
                    print("Sign Up attempt...")
                }
                .foregroundColor(.white)
                .padding()
                .background(darkTealColor) // A darker teal for the button background
                .cornerRadius(5.0)
                .padding(.bottom, 10)

                Button("Already have an account? Log in") {
                    // This button will dismiss the sign-up view and pop back to the login view
                    presentationMode.wrappedValue.dismiss()
                }
                .foregroundColor(.white)

                Spacer()
            }
            .padding()
        }
        .navigationBarHidden(true) // Optional: if you want to hide the navigation bar
    }
    
    func registerUser(name: String, username: String, email: String, password: String){
        //handle registering a user
    }
    
    func valid() -> Bool {

            if name.isEmpty || username.isEmpty || email.isEmpty || password.isEmpty || confirmed_password.isEmpty {
                return false
            }
            
            if password != confirmed_password {
                return false
            }
            
            return true
        }
}

// Preview for SignUpView
struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
}
