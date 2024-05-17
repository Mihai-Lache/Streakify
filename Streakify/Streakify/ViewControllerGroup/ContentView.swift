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
struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView()
    }
}

struct Habit: Identifiable {
    let id = UUID()
    var name: String
    var streakCount: Int = 0
    var isCompleted: Bool = false
    var totalDuration: Int

    var progress: CGFloat {
        return CGFloat(streakCount) / CGFloat(totalDuration)
    }

    var progressPercentage: Int {
        return min(Int((progress * 100).rounded()), 100)
    }
}

struct AddHabitView: View {
    @Environment(\.presentationMode) var presentationMode
    @Binding var habits: [Habit] // The habits list from the parent view
    @State private var habitName: String = ""
    @State private var habitDuration: String = "" // Track habit duration as string for TextField input

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

                    HStack {
                        Text("Total Days:")
                            .foregroundColor(.white)
                            .padding(.trailing, 10)

                        TextField("Number of days", text: $habitDuration)
                            .padding(10)
                            .background(Color(UIColor.systemGray6))
                            .cornerRadius(5)
                            .frame(width: 80)
                            .keyboardType(.numberPad) // Set keyboard type to number pad
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 20)

                    Button("Add Habit") {
                        if let totalDays = Int(habitDuration), !habitName.isEmpty {
                            let newHabit = Habit(name: habitName, streakCount: 0, isCompleted: false, totalDuration: totalDays)
                            habits.append(newHabit)
                        }
                        presentationMode.wrappedValue.dismiss()
                    }
                    .padding()
                    .background(habitName.isEmpty || Int(habitDuration) == nil ? Color.gray : darkTealColor)
                    .foregroundColor(.white)
                    .cornerRadius(5.0)
                    .disabled(habitName.isEmpty || Int(habitDuration) == nil) // Disable button if habit name or duration is empty
                }
                .padding()
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Add New Habit")
                        .font(.system(size: 28, weight: .bold))
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
