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
                            HabitRow(habit: habit, habits: $habits)
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
                            AddHabitView(habits: $habits)
                        }
                    }
                    .padding(.horizontal)
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
                    destination: HabitDetailView(habit: habit, habits: $habits),
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
                NotificationSettingsView(habit: $habits[habits.firstIndex(where: { $0.id == habit.id })!])
            }

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
        .padding(.vertical, 8)
        .background(Color(red: 11 / 255, green: 37 / 255, blue: 64 / 255))
        .cornerRadius(10)
    }
}

struct MainPageView_Previews: PreviewProvider {
    static var previews: some View {
        MainPageView(username: "User")
    }
}

struct HabitDetailView: View {
    var habit: Habit
    @Binding var habits: [Habit]

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

struct HistoryView: View {
    var completionDates: [String]

    var body: some View {
        VStack(alignment: .leading) {
            Text("Completion History")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.bottom)

            if completionDates.isEmpty {
                Text("No completion history available.")
                    .foregroundColor(.white)
                    .padding()
            } else {
                List {
                    ForEach(completionDates, id: \.self) { date in
                        Text(date)
                            .padding()
                            .background(Color(red: 11 / 255, green: 37 / 255, blue: 64 / 255))
                            .cornerRadius(10)
                            .foregroundColor(.white)
                            .listRowBackground(Color.clear)
                    }
                }
                .listStyle(PlainListStyle())
                .background(Color(red: 11 / 255, green: 37 / 255, blue: 64 / 255))
            }

            Spacer()
        }
        .padding()
        .background(Color(red: 11 / 255, green: 37 / 255, blue: 64 / 255).edgesIgnoringSafeArea(.all))
        .foregroundColor(.white)
    }
}

struct NotificationSettingsView: View {
    @Binding var habit: Habit
    @Environment(\.presentationMode) var presentationMode

    let frequencies = ["None", "Daily", "Weekly", "Monthly"]
    let daysOfWeek = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]

    @State private var enableNotifications: Bool
    @State private var selectedFrequency: String
    @State private var selectedTime: Date
    @State private var selectedDays: Set<String>

    init(habit: Binding<Habit>) {
        self._habit = habit
        self._enableNotifications = State(initialValue: habit.wrappedValue.notificationFrequency != "None")
        self._selectedFrequency = State(initialValue: habit.wrappedValue.notificationFrequency)
        self._selectedTime = State(initialValue: habit.wrappedValue.notificationTime ?? Date())
        self._selectedDays = State(initialValue: Set(habit.wrappedValue.notificationDays))
    }

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Notification Settings")) {
                    Toggle(isOn: $enableNotifications) {
                        Text("Enable Notifications")
                    }

                    if enableNotifications {
                        Picker("Frequency", selection: $selectedFrequency) {
                            ForEach(frequencies, id: \.self) { frequency in
                                Text(frequency).tag(frequency)
                            }
                        }
                        .pickerStyle(SegmentedPickerStyle())

                        DatePicker("Time", selection: $selectedTime, displayedComponents: .hourAndMinute)

                        if selectedFrequency == "Weekly" {
                            VStack(alignment: .leading) {
                                Text("Days")
                                ForEach(daysOfWeek, id: \.self) { day in
                                    Button(action: {
                                        if selectedDays.contains(day) {
                                            selectedDays.remove(day)
                                        } else {
                                            selectedDays.insert(day)
                                        }
                                    }) {
                                        HStack {
                                            Text(day)
                                            Spacer()
                                            if selectedDays.contains(day) {
                                                Image(systemName: "checkmark")
                                                    .foregroundColor(.blue)
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
            .navigationBarTitle("Notification Settings", displayMode: .inline)
            .navigationBarItems(
                leading: Button("Cancel") {
                    presentationMode.wrappedValue.dismiss()
                },
                trailing: Button("Save") {
                    habit.notificationFrequency = enableNotifications ? selectedFrequency : "None"
                    habit.notificationTime = enableNotifications ? selectedTime : nil
                    habit.notificationDays = enableNotifications && selectedFrequency == "Weekly" ? Array(selectedDays) : []
                    presentationMode.wrappedValue.dismiss()
                }
            )
        }
    }
}

struct NotificationSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        NotificationSettingsView(habit: .constant(Habit(name: "Sample Habit", description: "Sample Description", totalDuration: 30)))
    }
}
