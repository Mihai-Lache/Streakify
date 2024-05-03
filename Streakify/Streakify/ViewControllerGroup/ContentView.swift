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

struct Habit: Identifiable {
    let id = UUID()
    var name: String
    var progress: CGFloat
    var streakCount: Int = 0
    var isCompleted: Bool = false // Track completion status
    var goalDays: Int = 100
        var totalDuration: Int = 100
        var progressPercentage: Double {
            let percentage = Double(streakCount) / Double(totalDuration) * 100
            return min(percentage, 100)  // Ensure progress doesn't exceed 100%
           }
       }

struct AddHabitView: View {
    @Environment(\.presentationMode) var presentationMode
    @Binding var habits: [Habit] // The habits list from the parent view
    @State private var habitName: String = ""
    @State private var habitProgress: CGFloat = 0.5 // Default progress
    @State private var habitDuration: String = "" // Track habit duration

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

                HStack {
                    Text("Days the goal is being tracked")
                        .foregroundColor(.primary)
                        .padding(.trailing, 10)

                    TextField("", text: $habitDuration)
                        .padding(10)
                        .background(Color(UIColor.systemGray6))
                        .cornerRadius(5)
                        .frame(width: 80)
                        .keyboardType(.numberPad) // Set keyboard type to number pad
                }
                .padding(.horizontal)
                .padding(.bottom, 10)

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
