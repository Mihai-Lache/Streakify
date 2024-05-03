import SwiftUI

struct ForgotPasswordView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var username: String = ""
    @State private var email: String = ""

    let backgroundColor = Color(red: 11 / 255, green: 37 / 255, blue: 64 / 255) // Hex #0b2540
    let darkTealColor = Color(red: 5 / 255, green: 102 / 255, blue: 141 / 255) // Hex #05668d

    var body: some View {
        ZStack {
            backgroundColor.edgesIgnoringSafeArea(.all)
            VStack {
                Text("Reset Your Password")
                    .font(.title)
                    .bold()
                    .foregroundColor(.white)
                    .padding(.bottom, 20)

                TextField("Username", text: $username)
                    .padding()
                    .background(Color.white.opacity(1))
                    .cornerRadius(5.0)
                    .padding(.bottom, 15)

                TextField("Email", text: $email)
                    .padding()
                    .background(Color.white.opacity(1))
                    .cornerRadius(5.0)
                    .padding(.bottom, 20)

                Button("Send Reset Link") {
                    // Logic to handle password reset
                }
                .foregroundColor(.white)
                .padding()
                .background(darkTealColor)
                .cornerRadius(5.0)
                .padding(.bottom, 30)

                Button("Back to Login") {
                    presentationMode.wrappedValue.dismiss()
                }
                .foregroundColor(.white)

                Spacer()
            }
            .padding()
        }
    }
}

// Preview for ForgotPasswordView
struct ForgotPasswordView_Previews: PreviewProvider {
    static var previews: some View {
        ForgotPasswordView()
    }
}
