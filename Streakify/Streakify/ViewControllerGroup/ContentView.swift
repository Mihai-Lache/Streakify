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
    var description: String = "Default description"  // New description property
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
    @State private var habitDescription: String = "" // Track habit description

    let backgroundColor = Color(red: 11 / 255, green: 37 / 255, blue: 64 / 255) // Hex #0b2540
    let darkTealColor = Color(red: 5 / 255, green: 102 / 255, blue: 141 / 255) // Hex #05668d

    var body: some View {
        NavigationView {
            ZStack {
                backgroundColor.edgesIgnoringSafeArea(.all)
                VStack(spacing: 20) {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Habit Name")
                            .foregroundColor(.white)
                            .font(.headline)
                        
                        TextField("Enter habit name", text: $habitName)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(10.0)
                    }
                    .padding(.horizontal)
                    
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Description")
                            .foregroundColor(.white)
                            .font(.headline)
                        
                        TextField("Enter habit description", text: $habitDescription)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(10.0)
                    }
                    .padding(.horizontal)

                    VStack(alignment: .leading, spacing: 10) {
                        Text("Total Days")
                            .foregroundColor(.white)
                            .font(.headline)
                        
                        TextField("Enter number of days", text: $habitDuration)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(10.0)
                            .keyboardType(.numberPad)
                    }
                    .padding(.horizontal)

                    Button(action: {
                        if let totalDays = Int(habitDuration), !habitName.isEmpty {
                            let newHabit = Habit(name: habitName, description: habitDescription, streakCount: 0, isCompleted: false, totalDuration: totalDays)
                            habits.append(newHabit)
                            presentationMode.wrappedValue.dismiss()
                        }
                    }) {
                        Text("Add Habit")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(habitName.isEmpty || Int(habitDuration) == nil ? Color.gray : darkTealColor)
                            .cornerRadius(10)
                            .padding(.horizontal)
                    }
                    .disabled(habitName.isEmpty || Int(habitDuration) == nil)
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


struct EditHabitView: View {
    @Environment(\.presentationMode) var presentationMode
    var habit: Habit
    @Binding var habits: [Habit]
    
    @State private var habitName: String
    @State private var habitDescription: String
    @State private var habitDuration: String
    
    init(habit: Habit, habits: Binding<[Habit]>) {
        self.habit = habit
        self._habits = habits
        self._habitName = State(initialValue: habit.name)
        self._habitDescription = State(initialValue: habit.description)
        self._habitDuration = State(initialValue: String(habit.totalDuration))
    }

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

                    TextField("Description", text: $habitDescription)
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

                    Button("Save Changes") {
                        if let totalDays = Int(habitDuration), !habitName.isEmpty {
                            if let index = habits.firstIndex(where: { $0.id == habit.id }) {
                                habits[index].name = habitName
                                habits[index].description = habitDescription
                                habits[index].totalDuration = totalDays
                            }
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
                    Text("Edit Habit")
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
struct EditHabitView_Previews: PreviewProvider {
    static var previews: some View {
        EditHabitView(habit: Habit(name: "Sample Habit", description: "Sample Description", totalDuration: 30), habits: .constant([]))
    }
}


