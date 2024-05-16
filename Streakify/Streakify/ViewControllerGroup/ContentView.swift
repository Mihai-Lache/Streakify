import SwiftUI

struct RootView: View {
    @State private var showLogin = true
    
    var body: some View {
        NavigationView {
            LoginView(showLogin: $showLogin)
        }
    }
}

// For previewing in SwiftUI Canvas

// For previewing in SwiftUI Canvas
struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView()
    }
}
