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
}


struct AddHabitView: View {
    @Environment(\.presentationMode) var presentationMode
    @Binding var habits: [Habit] // The habits list from the parent view
    @State private var habitName: String = ""
    @State private var habitProgress: CGFloat = 0.5 // Default progress

    var body: some View {
        NavigationView {
            VStack {
                TextField("Habit Name", text: $habitName)
                    .padding()

                Slider(value: $habitProgress, in: 0...1, step: 0.1) {
                    Text("Progress")
                } minimumValueLabel: {
                    Text("0%")
                } maximumValueLabel: {
                    Text("100%")
                }
                .padding()

                Button("Add Habit") {
                    let newHabit = Habit(name: habitName, progress: habitProgress)
                    habits.append(newHabit)
                    presentationMode.wrappedValue.dismiss()
                }
                .padding()
                .disabled(habitName.isEmpty) // Disable button if habit name is empty
            }
            .navigationBarTitle("Add New Habit", displayMode: .inline)
            .navigationBarItems(leading: Button(action: {
                presentationMode.wrappedValue.dismiss()
            }) {
                Image(systemName: "arrow.left")
                Text("Back")
            })
        }
    }
}


