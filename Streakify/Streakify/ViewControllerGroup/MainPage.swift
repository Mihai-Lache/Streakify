import SwiftUI

struct MainPageView: View {
    @State private var habits: [Habit] = []
    @State private var showingAddHabit = false
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
                        Spacer()

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
        HStack {
            // Completion Toggle Button
            Button(action: {
                if let index = habits.firstIndex(where: { $0.id == habit.id }) {
                    habits[index].isCompleted.toggle()  // Toggle completion status
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
                    .frame(width: 100, height: 20)
                Capsule().fill(Color.green)
                    .frame(width: 100 * habit.progress, height: 20)
            }
            .cornerRadius(10)

            // Streak Counter Button
            Button(action: {
                if let index = habits.firstIndex(where: { $0.id == habit.id }) {
                    habits[index].streakCount += 1  // Increment streak count
                }
            }) {
                ZStack {
                    Image(systemName: "flame.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 24, height: 24)
                        .foregroundColor(.orange)

                    Text("\(habit.streakCount)")
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .shadow(color: .black, radius: 1, x: 0, y: 0)  // Shadow for better readability
                }
            }
            .buttonStyle(PlainButtonStyle())

            // Notification button
            Button(action: {
                NotificationManager.instance.scheduleNotification(title: "Reminder for \(habit.name)", subtitle: "Time to check your progress!", hour: 10, minute: 0)
            }) {
                Image(systemName: "bell.fill")
                    .resizable()
                    .scaledToFit()
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
                    .scaledToFit()
                    .frame(width: 24, height: 24)
                    .foregroundColor(.red)
            }
            .buttonStyle(PlainButtonStyle())
        }
        .padding(.horizontal)
        .listRowBackground(Color(red: 11 / 255, green: 37 / 255, blue: 64 / 255))
    }
}

struct MainPageView_Previews: PreviewProvider {
    static var previews: some View {
        MainPageView()
    }
}
