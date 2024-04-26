import SwiftUI




struct MainPageView: View {
    @State private var habits: [Habit] = []
    @State private var showingAddHabit = false
    let username: String = "User"
    let backgroundColor = Color(red: 11 / 255, green: 37 / 255, blue: 64 / 255)

    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        NavigationView {
            ZStack {
                backgroundColor.edgesIgnoringSafeArea(.all)
                VStack {
                    greetingHeader
                    if habits.isEmpty {
                        EmptyStateView()
                    } else {
                        habitList
                    }
                    addHabitButton
                }
            }
            .navigationBarHidden(true)
        }
    }

    var greetingHeader: some View {
        Group {
            if habits.isEmpty {
                HStack {
                    Text("Hey \(username),")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(.top)
                    Spacer()
                    Button("Sign Out") {
                        presentationMode.wrappedValue.dismiss()
                    }
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.red)
                    .cornerRadius(10)
                }
                .padding([.horizontal, .top])
            }
        }
    }

    
    struct HabitDetailView: View {
        var habit: Habit

        var body: some View {
            VStack {
                Text(habit.name)
                    .font(.title)
                    .padding()
                Text("Progress: \(habit.progress * 100, specifier: "%.1f")%")
                    .padding()
            }
            .navigationBarTitle("Habit Details", displayMode: .inline)
        }
    }


    var habitList: some View {
        List {
            ForEach($habits) { $habit in  // Use $ to pass a binding to HabitRow
                HabitRow(habit: $habit, deleteAction: {
                    if let index = habits.firstIndex(where: { $0.id == habit.id }) {
                        habits.remove(at: index)
                    }
                })
            }
            .onDelete(perform: deleteHabits)
        }
        .listStyle(PlainListStyle())
    }



    var addHabitButton: some View {
        Button(action: {
            showingAddHabit.toggle()
        }) {
            Text("Add New Habit")
                .bold()
                .frame(minWidth: 0, maxWidth: .infinity)
                .padding()
                .foregroundColor(.white)
                .background(Color.green)
                .cornerRadius(20)
        }
        .padding()
        .sheet(isPresented: $showingAddHabit) {
            AddHabitView(habits: $habits)
        }
    }

    func deleteHabits(at offsets: IndexSet) {
        habits.remove(atOffsets: offsets)
    }
}



struct EmptyStateView: View {
    var body: some View {
        VStack {
            Spacer()
            Text("Tap + to add your first habit")
                .foregroundColor(.white.opacity(0.7))
                .font(.headline)
            Spacer()
        }
    }
}

struct HabitRow: View {
    @Binding var habit: Habit
    var deleteAction: () -> Void

    var body: some View {
        HStack {
            Button(action: {
                habit.progress = habit.progress == 1.0 ? 0.0 : 1.0  // Toggle completion
            }) {
                Image(systemName: habit.progress == 1.0 ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(habit.progress == 1.0 ? .green : .gray)
                    .imageScale(.large)
            }
            .buttonStyle(PlainButtonStyle())

            Text(habit.name)
                .foregroundColor(.white)
                .strikethrough(habit.progress == 1.0, color: .white)

            Spacer()

            Button(action: deleteAction) {
                Image(systemName: "trash.fill")
                    .foregroundColor(.red)
            }
            .buttonStyle(PlainButtonStyle())
        }
        .padding()
        .background(Color(red: 11 / 255, green: 37 / 255, blue: 64 / 255))
        .cornerRadius(10)
        .padding(.horizontal)
    }
}



struct MainPageView_Previews: PreviewProvider {
    static var previews: some View {
        MainPageView()
    }
}
