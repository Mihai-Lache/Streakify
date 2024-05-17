import SwiftUI

struct LoginView: View {
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var navigatingToMainPage = false
    @State private var navigatingToSignUp = false
    @State private var navigatingToForgotPassword = false
    @State private var showLoginError = false
    @State private var navigateToSignUp = false
    
    @Binding var showLogin: Bool
    
    let backgroundColor = Color(red: 11 / 255, green: 37 / 255, blue: 64 / 255)
    let darkTealColor = Color(red: 5 / 255, green: 102 / 255, blue: 141 / 255)
    
    var body: some View {
        NavigationStack {
            ZStack {
                backgroundColor.ignoresSafeArea()
                
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
                    
                    if showLoginError {
                        Text("Invalid email or password")
                            .foregroundColor(.red)
                            .padding(.bottom, 10)
                    }
                    
                    Button("Forgot password?") {
                        navigatingToForgotPassword = true
                    }
                    .foregroundColor(.white)
                    .padding(.bottom, 30)
                    
                    Button("Login") {
                        showLoginError = false // Reset the error state
                        UserManager.shared.loginUser(email: username, password: password) { success in
                            if success {
                                navigatingToMainPage = true
                            } else {
                                showLoginError = true
                            }
                        }
                    }
                    .foregroundColor(.white)
                    .padding()
                    .background(darkTealColor)
                    .cornerRadius(5.0)
                    .padding(.bottom, 15)
                    
                    Button("Need an account? Sign Up Here!") {
                        navigateToSignUp = true
                    }
                    .foregroundColor(.white)
                    
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
            .navigationDestination(isPresented: $navigatingToForgotPassword) {
                ForgotPasswordView()
            }
            .navigationDestination(isPresented: $navigatingToMainPage) {
                MainPageView()
            }
            .background(
                NavigationLink(
                    destination: SignUpView(showLogin: $showLogin),
                    isActive: $navigateToSignUp,
                    label: { EmptyView() }
                )
            )
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(showLogin: .constant(true))
    }
}
