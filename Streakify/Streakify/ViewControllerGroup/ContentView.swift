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

    let backgroundColor = Color(red: 11 / 255, green: 37 / 255, blue: 64 / 255) // Hex #0b2540
    let darkTealColor = Color(red: 5 / 255, green: 102 / 255, blue: 141 / 255) // Hex #05668d

    var body: some View {
        NavigationView {
            ZStack {
                backgroundColor.edgesIgnoringSafeArea(.all)
                VStack {
                    TextField("Habit Name", text: $habitName)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(5.0)
                        .padding(.bottom, 20)

                    Slider(value: $habitProgress, in: 0...1, step: 0.1) {
                        Text("Progress")
                    } minimumValueLabel: {
                        Text("0%").foregroundColor(.white)
                    } maximumValueLabel: {
                        Text("100%").foregroundColor(.white)
                    }
                    .padding()

                    HStack {
                        Text("Days the goal is being tracked")
                            .foregroundColor(.white)
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
                    .background(darkTealColor)
                    .foregroundColor(.white)
                    .cornerRadius(5.0)
                    .disabled(habitName.isEmpty) // Disable button if habit name is empty
                }
                .padding()
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Add New Habit")
                        .font(.system(size: 28, weight: .bold)) // Custom larger font size
                        .foregroundColor(.white)
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        HStack {
                            Image(systemName: "arrow.left")
                            Text("Back")
                        }
                        .foregroundColor(.white)
                    }
                }
            }
        }
    }
}

// Preview provider
struct AddHabitView_Previews: PreviewProvider {
    static var previews: some View {
        AddHabitView(habits: .constant([]))
    }
}
