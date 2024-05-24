import SwiftUI

struct MainPageView: View {
    @State private var habits: [Habit] = []
    @State private var showingAddHabit = false
    @State private var showingSettings = false
    
    let username: String
    let backgroundColor = Color(red: 11 / 255, green: 37 / 255, blue: 64 / 255)
    let progressTrackColor = Color.white.opacity(0.3)
    let progressColor = Color.green

    @Environment(\.presentationMode) var presentationMode

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
                            presentationMode.wrappedValue.dismiss()
                        }
                        .foregroundColor(.white)
                        .padding(10)
                        .background(Color.red)
                        .cornerRadius(10)
                    }

                    List {
                        ForEach(habits) { habit in
                            HabitRow(habit: habit, habits: $habits, username: username)
                                .listRowBackground(backgroundColor)
                        }
                        .onDelete(perform: deleteHabits)
                    }
                    .listStyle(PlainListStyle())
                    .background(backgroundColor)

                    HStack {
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
                        .background(Color.blue)
                        .cornerRadius(10)
                        .sheet(isPresented: $showingSettings) {
                            SettingsView()
                        }

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
                        .background(Color.green)
                        .cornerRadius(10)
                        .sheet(isPresented: $showingAddHabit) {
                            if let currentUser = UserManager.shared.getUserByUsername(username) {
                                AddHabitView(habits: $habits, user: currentUser)
                            }
                        }
                    }
                    .padding(.horizontal)
                }
            }
            .navigationBarHidden(true)
        }
        .onAppear {
            loadHabits()
        }
    }

    func loadHabits() {
        if let currentUser = UserManager.shared.getUserByUsername(username) {
            habits = currentUser.habits
        }
    }

    func deleteHabits(at offsets: IndexSet) {
        if let currentUser = UserManager.shared.getUserByUsername(username) {
            for index in offsets {
                UserManager.shared.removeHabit(for: currentUser, habit: habits[index])
            }
            habits.remove(atOffsets: offsets)
        }
    }
}

struct HabitRow: View {
    var habit: Habit
    @Binding var habits: [Habit]
    var username: String

    @State private var showingDetail = false
    @State private var showingNotificationSettings = false

    var body: some View {
        HStack(spacing: 8) {
            Button(action: {
                if let index = habits.firstIndex(where: { $0.id == habit.id }) {
                    habits[index].isCompleted.toggle()
                    if habits[index].isCompleted {
                        habits[index].streakCount = habits[index].totalDuration
                        if !habits[index].completionDates.contains(where: { Calendar.current.isDate($0, inSameDayAs: Date()) }) {
                            habits[index].completionDates.append(Date()) // Track completion date
                        }
                    } else {
                        habits[index].streakCount = 0  // Reset streak count
                        habits[index].completionDates.removeAll(where: { Calendar.current.isDate($0, inSameDayAs: Date()) }) // Remove today's completion date
                    }
                }
                if let currentUser = UserManager.shared.getUserByUsername(username) {
                    UserManager.shared.addHabit(for: currentUser, habit: habits.first { $0.id == habit.id }!)
                }
            }) {
                Image(systemName: habit.isCompleted ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(habit.isCompleted ? .green : .gray)
                    .imageScale(.large)
            }

            VStack(alignment: .leading) {
                Text(habit.name)
                    .foregroundColor(.white)
                    .strikethrough(habit.isCompleted, color: .white)

                ZStack(alignment: .leading) {
                    Capsule().fill(Color.white.opacity(0.3))
                        .frame(width: 140, height: 8)
                    Capsule().fill(Color.green)
                        .frame(width: CGFloat(habit.progress) * 140, height: 8)

                    Text(habit.isCompleted ? "Completed" : "\(Int(habit.progressPercentage))%")
                        .foregroundColor(.white)
                        .font(.caption)
                        .fontWeight(.bold)
                        .position(x: 70, y: 4)
                }
                .frame(width: 140, height: 8)
                .cornerRadius(4)
            }
            .onTapGesture {
                showingDetail = true
            }
            .background(
                NavigationLink(
                    destination: HabitDetailView(habit: habit, habits: $habits, username: username),
                    isActive: $showingDetail,
                    label: { EmptyView() }
                )
                .hidden()
            )

            Spacer()

            Button(action: {
                if let index = habits.firstIndex(where: { $0.id == habit.id }) {
                    if !habits[index].isCompleted && habits[index].streakCount < habits[index].totalDuration {
                        habits[index].streakCount += 1
                        if habits[index].streakCount == habits[index].totalDuration {
                            habits[index].isCompleted = true
                            if !habits[index].completionDates.contains(where: { Calendar.current.isDate($0, inSameDayAs: Date()) }) {
                                habits[index].completionDates.append(Date()) // Track completion date
                            }
                        }
                    }
                }
                if let currentUser = UserManager.shared.getUserByUsername(username) {
                    UserManager.shared.addHabit(for: currentUser, habit: habits.first { $0.id == habit.id }!)
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

            Button(action: {
                showingNotificationSettings = true
            }) {
                Image(systemName: "bell.fill")
                    .resizable()
                    .frame(width: 24, height: 24)
                    .foregroundColor(.blue)
            }
            .buttonStyle(PlainButtonStyle())
            .sheet(isPresented: $showingNotificationSettings) {
                if let currentUser = UserManager.shared.getUserByUsername(username),
                   let habitIndex = currentUser.habits.firstIndex(where: { $0.id == habit.id }) {
                    NotificationSettingsView(habit: $habits[habitIndex])
                }
            }

            Button(action: {
                if let index = habits.firstIndex(where: { $0.id == habit.id }) {
                    habits.remove(at: index)
                    if let currentUser = UserManager.shared.getUserByUsername(username) {
                        UserManager.shared.removeHabit(for: currentUser, habit: habit)
                    }
                }
            }) {
                Image(systemName: "minus.circle.fill")
                    .resizable()
                    .frame(width: 24, height: 24)
                    .foregroundColor(.red)
            }
            .buttonStyle(PlainButtonStyle())
        }
        .padding(.vertical, 8)
        .background(Color(red: 11 / 255, green: 37 / 255, blue: 64 / 255))
        .cornerRadius(10)
    }
}

struct HabitDetailView: View {
    var habit: Habit
    @Binding var habits: [Habit]
    var username: String

    @State private var showingEditHabit = false
    @State private var showingHistory = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text(habit.name)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.top)

                Text("Streak: \(habit.streakCount) / \(habit.totalDuration)")
                    .font(.title2)

                ProgressView(value: habit.progress)
                    .progressViewStyle(LinearProgressViewStyle(tint: Color.green))
                    .padding(.vertical)

                Text("Start Date: \(habit.startDateFormatted)")
                    .font(.body)
                Text("End Date: \(habit.endDateFormatted)")
                    .font(.body)

                Text("Description")
                    .font(.title3)
                    .fontWeight(.semibold)
                Text(habit.description)
                    .font(.body)

                Text("Motivational Quote")
                    .font(.title3)
                    .fontWeight(.semibold)
                Text("“The journey of a thousand miles begins with one step.” - Lao Tzu")
                    .font(.body)
                    .italic()

                VStack(spacing: 10) {
                    Button(action: {
                        showingEditHabit = true
                    }) {
                        Text("Edit Habit")
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.blue)
                            .cornerRadius(10)
                    }
                    .background(
                        NavigationLink(
                            destination: EditHabitView(habit: habit, habits: $habits),
                            isActive: $showingEditHabit,
                            label: { EmptyView() }
                        )
                        .hidden()
                    )

                    Button(action: {
                        showingHistory = true
                    }) {
                        Text("View History")
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.gray)
                            .cornerRadius(10)
                    }
                    .background(
                        NavigationLink(
                            destination: HistoryView(completionDates: habit.formattedCompletionDates),
                            isActive: $showingHistory,
                            label: { EmptyView() }
                        )
                        .hidden()
                    )

                    Button(action: {
                        if let index = habits.firstIndex(where: { $0.id == habit.id }) {
                            habits.remove(at: index)
                            if let currentUser = UserManager.shared.getUserByUsername(username) {
                                UserManager.shared.removeHabit(for: currentUser, habit: habit)
                            }
                        }
                    }) {
                        Text("Delete Habit")
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.red)
                            .cornerRadius(10)
                    }
                }
                .padding(.top)
            }
            .padding()
            .background(Color(red: 11 / 255, green: 37 / 255, blue: 64 / 255))
            .foregroundColor(.white)
        }
        .background(Color(red: 11 / 255, green: 37 / 255, blue: 64 / 255).edgesIgnoringSafeArea(.all))
    }
}
