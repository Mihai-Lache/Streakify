import SwiftUI

struct LoginView: View {
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var navigatingToMainPage = false  // State to control navigation to the MainPage
    @State private var navigatingToSignUp = false  // State to control navigation to the SignUpView
    @State private var navigatingToForgotPassword = false  // State to control navigation to the ForgotPasswordView

    let backgroundColor = Color(red: 11 / 255, green: 37 / 255, blue: 64 / 255) // Hex #0b2540
    let darkTealColor = Color(red: 5 / 255, green: 102 / 255, blue: 141 / 255) // Hex #05668d

    var body: some View {
        NavigationView {
            ZStack {
                backgroundColor.edgesIgnoringSafeArea(.all)
                VStack {
                    Image("Image")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 200, height: 200)
                        .clipped()
                        .padding(.bottom, 20)

                    Text("Welcome To Streakify!")
                        .font(.title)
                        .bold()
                        .foregroundColor(.white)
                        .padding(.bottom, 10)

                    Text("Building Better Habits Daily")
                        .font(.title)
                        .foregroundColor(.white)
                        .padding(.bottom, 25)

                    TextField("Username", text: $username)
                        .padding()
                        .background(Color.white.opacity(1))
                        .cornerRadius(5.0)
                        .padding(.bottom, 20)

                    SecureField("Password", text: $password)
                        .padding()
                        .background(Color.white.opacity(1))
                        .cornerRadius(5.0)
                        .padding(.bottom, 5)

                    Button("Forgot password?") {
                        navigatingToForgotPassword = true
                    }
                    .foregroundColor(.white)
                    .padding(.bottom, 30)

                    NavigationLink(destination: ForgotPasswordView(), isActive: $navigatingToForgotPassword) {
                        EmptyView()
                    }

                    Button("Login") {
                        navigatingToMainPage = true
                    }
                    .foregroundColor(.white)
                    .padding()
                    .background(darkTealColor)
                    .cornerRadius(5.0)
                    .padding(.bottom, 15)

                    NavigationLink(destination: MainPageView(), isActive: $navigatingToMainPage) {
                        EmptyView()
                    }

                    Button("Need an account? Sign Up Here!") {
                        navigatingToSignUp = true
                    }
                    .foregroundColor(.white)
                    
                    NavigationLink(destination: SignUpView(), isActive: $navigatingToSignUp) {
                        EmptyView()
                    }

                    Spacer()
                }
                .padding()
            }
            .navigationBarHidden(true)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.white)
                }
            }
            .accentColor(.white)
        }
    }
}

// Preview provider
struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
