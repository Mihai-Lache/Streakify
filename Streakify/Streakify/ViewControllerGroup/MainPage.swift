import SwiftUI

struct MainPageView: View {
    @State private var habits: [Habit] = []
    @State private var showingAddHabit = false
    @State private var showingSettings = false
    let username: String = "User"
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

    var body: some View {
        HStack(spacing: 8) {
            Button(action: {
                if let index = habits.firstIndex(where: { $0.id == habit.id }) {
                    habits[index].isCompleted.toggle()
                    if habits[index].isCompleted {
                        habits[index].streakCount = habits[index].totalDuration
                    } else {
                        habits[index].streakCount = 0  // Reset streak count
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
                    destination: HabitDetailView(habit: habit),
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
                // Implement notification action
            }) {
                Image(systemName: "bell.fill")
                    .resizable()
                    .frame(width: 24, height: 24)
                    .foregroundColor(.blue)
            }
            .buttonStyle(PlainButtonStyle())

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
        MainPageView()
    }
}



struct HabitDetailView: View {
    var habit: Habit

    var body: some View {
        VStack(alignment: .leading) {
            Text(habit.name)
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding()

            Text("Streak: \(habit.streakCount) / \(habit.totalDuration)")
                .font(.title2)
                .padding([.leading, .bottom])

            ProgressView(value: habit.progress)
                .progressViewStyle(LinearProgressViewStyle(tint: Color.green))
                .padding([.leading, .trailing, .bottom])

            Spacer()

            Button(action: {
                // Additional actions for the habit
            }) {
                Text("Additional Options")
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            .padding()
        }
        .background(Color(red: 11 / 255, green: 37 / 255, blue: 64 / 255))
        .foregroundColor(.white)
        .edgesIgnoringSafeArea(.all)
    }
}
