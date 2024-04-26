import SwiftUI

struct RootView: View {
    var body: some View {
        NavigationView {
            LoginView()
        }
    }
}

// For previewing in SwiftUI Canvas
struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView()
    }
}
