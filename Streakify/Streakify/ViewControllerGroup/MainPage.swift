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
            Text(habit.name)
                .foregroundColor(.white)
            
            ZStack(alignment: .leading) {
                Capsule().fill(Color.white.opacity(0.3))
                    .frame(width: 200, height: 20)
                Capsule().fill(Color.green)
                    .frame(width: 200 * habit.progress, height: 20)
            }
            .frame(width: 200, height: 20)
            .cornerRadius(10)

            Spacer()

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
        }
        .listRowBackground(Color(red: 11 / 255, green: 37 / 255, blue: 64 / 255))
    }
}

struct MainPageView_Previews: PreviewProvider {
    static var previews: some View {
        MainPageView()
    }
}
