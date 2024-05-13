import SwiftUI

struct MainPageView: View {
    @State private var habits: [Habit] = []
    @State private var showingAddHabit = false
    @State private var showingSettings = false  // State to control navigation to the SettingsView
    let username: String = "User"
    let backgroundColor = Color(red: 11 / 255, green: 37 / 255, blue: 64 / 255)
    let progressTrackColor = Color.white.opacity(0.3)
    let progressColor = Color.green

    @Environment(\.presentationMode) var presentationMode  // For dismissing the view

    var body: some View {
        NavigationView {
            ZStack {
                backgroundColor.edgesIgnoringSafeArea(.all)

                VStack(alignment: .leading) {
                    HStack {
                        Text("Hey \(username)")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .padding([.top, .leading])

                        Spacer()

                        Button("Sign Out") {
                            presentationMode.wrappedValue.dismiss()  // Dismisses the current view, simulating "sign out"
                        }
                        .foregroundColor(.white)
                        .padding(10)
                        .background(Color.red)
                        .cornerRadius(10)
                    }

                    List {
                        ForEach(habits) { habit in
                            HabitRow(habit: habit, habits: $habits)
                        }
                        .onDelete(perform: deleteHabits)
                    }
                    .listStyle(PlainListStyle())

                    HStack {
                        // Settings Button
                        Button(action: {
                            showingSettings.toggle()
                        }) {
                            HStack {
                                Image(systemName: "gearshape.fill")
                                    .resizable()
                                    .frame(width: 24, height: 24)
                                Text("Settings")
                            }
                            .foregroundColor(.white)
                        }
                        .padding()
                        .sheet(isPresented: $showingSettings) {
                            SettingsView()
                        }

                        Spacer()

                        // Add Habit Button
                        Button(action: {
                            showingAddHabit.toggle()
                        }) {
                            HStack {
                                Image(systemName: "plus.circle.fill")
                                    .resizable()
                                    .frame(width: 24, height: 24)
                                Text("Add Habit")
                            }
                            .foregroundColor(.white)
                        }
                        .padding()
                        .sheet(isPresented: $showingAddHabit) {
                            AddHabitView(habits: $habits)
                        }
                    }
                }
            }
            .navigationBarHidden(true)
        }
    }

    func deleteHabits(at offsets: IndexSet) {
        habits.remove(atOffsets: offsets)
    }
}

struct HabitRow: View {
    var habit: Habit
    @Binding var habits: [Habit]

    var body: some View {
        HStack(spacing: 8) { // Decreased spacing between buttons
            // Completion Toggle Button
            Button(action: {
                if let index = habits.firstIndex(where: { $0.id == habit.id }) {
                    habits[index].isCompleted.toggle()  // Toggle completion status
                    if habits[index].isCompleted {
                        habits[index].streakCount = habits[index].totalDuration  // Ensure progress reaches 100%
                    }
                }

            }) {
                Image(systemName: habit.isCompleted ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(habit.isCompleted ? .green : .gray)
                    .imageScale(.large)
            }

            Text(habit.name)
                .foregroundColor(.white)
                .strikethrough(habit.isCompleted, color: .white)  // Apply strikethrough if completed

            // Visual progress representation
            ZStack(alignment: .leading) {
                Capsule().fill(Color.white.opacity(0.3))
                    .frame(width: 140, height: 8)
                Capsule().fill(Color.green)
                    .frame(width: CGFloat(habit.progress) * 140, height: 8)
                
                // Display "Completed" or percentage in the middle of the bar
                Text(habit.isCompleted ? "Completed" : "\(Int(habit.progressPercentage))%")
                    .foregroundColor(.white)
                    .font(.caption)
                    .fontWeight(.bold)
                    .position(x: 70, y: 4) // Centered position for the percentage text
            }
            .frame(width: 140, height: 8)
            .cornerRadius(4)

            Spacer()

            // Flame button with counter to signify streaks
            // Flame button with counter to signify streaks
            Button(action: {
                if let index = habits.firstIndex(where: { $0.id == habit.id }) {
                    if !habits[index].isCompleted && habits[index].streakCount < habits[index].totalDuration {
                        habits[index].streakCount += 1  // Increment streak count
                        if habits[index].streakCount == habits[index].totalDuration {
                            habits[index].isCompleted = true  // Automatically mark as completed if the total duration is reached
                        }
                    }
                }
            }) {
                ZStack {
                    Image(systemName: "flame.fill")
                        .resizable()
                        .frame(width: 24, height: 24)
                        .foregroundColor(habit.isCompleted ? .gray : .orange)
                    Text("\(habit.streakCount)")
                        .foregroundColor(.white)
                        .font(.caption)
                        .fontWeight(.bold)
                }
            }

            .buttonStyle(PlainButtonStyle())

            // Notification button
            Button(action: {
                // Implement notification action
            }) {
                Image(systemName: "bell.fill")
                    .resizable()
                    .frame(width: 24, height: 24)
                    .foregroundColor(.blue)
            }
            .buttonStyle(PlainButtonStyle())

            // Delete button
            Button(action: {
                if let index = habits.firstIndex(where: { $0.id == habit.id }) {
                    habits.remove(at: index)
                }
            }) {
                Image(systemName: "minus.circle.fill")
                    .resizable()
                    .frame(width: 24, height: 24)
                    .foregroundColor(.red)
            }
            .buttonStyle(PlainButtonStyle())
        }
        .listRowBackground(Color(red: 11 / 255, green: 37 / 255, blue: 64 / 255))
    }
}

struct MainPageView_Previews: PreviewProvider {
    static var previews: some View {
        MainPageView()
    }
}
