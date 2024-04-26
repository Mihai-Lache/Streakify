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


import Foundation


struct Habit: Identifiable {
    let id = UUID()
    var name: String
    var progress: CGFloat

    init(name: String, progress: CGFloat = 0.0) { // Default value for progress
        self.name = name
        self.progress = progress
    }
}


struct AddHabitView: View {
    @Binding var habits: [Habit] // Make sure the Habit struct is defined and accessible
    @Environment(\.presentationMode) var presentationMode
    @State private var habitName: String = ""

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Add New Habit")
                .font(.title)
                .fontWeight(.bold)
                .padding(.top)

            TextField("Habit name", text: $habitName)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            Button("Save Habit") {
                saveHabit()
            }
            .buttonStyle(FilledButton())
            .disabled(habitName.isEmpty)

            Spacer()
        }
        .padding()
        .background(Color(red: 11 / 255, green: 37 / 255, blue: 64 / 255).edgesIgnoringSafeArea(.all))
        .navigationBarItems(leading: Button("Cancel") {
            self.presentationMode.wrappedValue.dismiss()
        })
        .navigationBarBackButtonHidden(true)
    }

    private func saveHabit() {
        let newHabit = Habit(name: habitName, progress: 0.0) // Include progress when creating a new habit
        habits.append(newHabit)
        presentationMode.wrappedValue.dismiss()
    }

}

struct FilledButton: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .padding()
            .background(Color.green)
            .foregroundColor(.white)
            .cornerRadius(8)
            .scaleEffect(configuration.isPressed ? 0.95 : 1)
    }
}


