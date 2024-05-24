import SwiftUI

struct ContentView: View {
    @State private var showLogin = true
    
    var body: some View {
        NavigationView {
            if showLogin {
                LoginView(showLogin: $showLogin)
            } else {
                // Placeholder for MainPageView if not showing login
                Text("Main Page")
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
