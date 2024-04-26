import SwiftUI




struct MainPageView: View {
    @State private var habits: [Habit] = []
    //@State private var showingAddHabit = false
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

    @State private var animateGreenBackground = false
    @State private var showingAddHabit = false

//
    
    
    
    
    /////
    ///
    ///
    ///
    ///
    ///

    var addHabitButton: some View {
        RippleButton(isAnimating: $animateGreenBackground) {
            showingAddHabit.toggle()
        }
        .sheet(isPresented: $showingAddHabit, onDismiss: { animateGreenBackground = false }) {
            AddHabitView(habits: $habits)
        }
    }



/////
    ///
    ///
    ///
    ///
    ///
    ///
    ///ripple button here
    struct RippleButton: View {
        @Binding var isAnimating: Bool
        let action: () -> Void
        
        var body: some View {
            Button(action: {
                withAnimation(.easeOut(duration: 0.5)) {
                    isAnimating = true
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    action()
                }
            }) {
                Text("Add New Habit")
                    .bold()
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .padding()
                    .foregroundColor(.white)
                    .background(Color.green)
                    .cornerRadius(20)
                    .overlay(
                        ZStack {
                            if isAnimating {
                                Circle()
                                    .fill(Color.green)
                                    .scaleEffect(isAnimating ? 5 : 1)
                                    .opacity(isAnimating ? 0 : 1)
                                    .animation(.easeOut(duration: 0.5), value: isAnimating)
                            }
                        }, alignment: .center
                    )
            }
            .padding()
        }
    }

    ///
    ///
    ///
    ///
    
    
    
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







///this is from the other file
///
///FROM CONTENT VIEW
///
///

import Foundation


struct Habit: Identifiable {
    let id = UUID()
    var name: String
    var progress: CGFloat

    init(name: String, progress: CGFloat = 0.0) { // Default value for progress
        self.name = name
        self.progress = progress
    }
}




struct AddHabitView: View {
    @Binding var habits: [Habit]
    @Environment(\.presentationMode) var presentationMode
    @State private var habitName: String = ""
    @State private var isAnimatingButton: Bool = false

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Add New Habit")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .padding(.top)
            
            TextField("Habit name", text: $habitName)
                .padding()
                .background(Color.white.opacity(0.1))
                .cornerRadius(10)
                .foregroundColor(.white)
                .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.white, lineWidth: 1))
                .padding(.horizontal)
            
            Button(action: {
                withAnimation {
                    isAnimatingButton = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        isAnimatingButton = false
                        saveHabit()
                    }
                }
            }) {
                Text("Save Habit")
                    .bold()
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .padding()
                    .background(isAnimatingButton ? Color.green.opacity(0.5) : Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .padding(.horizontal)
                    .scaleEffect(isAnimatingButton ? 0.9 : 1.0)
            }
            .disabled(habitName.isEmpty)
            
            Spacer()
        }
        .padding()
        .background(LinearGradient(gradient: Gradient(colors: [Color(red: 11 / 255, green: 37 / 255, blue: 64 / 255), Color(red: 21 / 255, green: 67 / 255, blue: 96 / 255)]), startPoint: .top, endPoint: .bottom).edgesIgnoringSafeArea(.all))
        .navigationBarItems(leading: Button("Cancel") {
            presentationMode.wrappedValue.dismiss()
        })
        .navigationBarBackButtonHidden(true)
        
    }

    private func saveHabit() {
        let newHabit = Habit(name: habitName, progress: 0.0)
        habits.append(newHabit)
        presentationMode.wrappedValue.dismiss()
    }
}









struct FilledButton: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .padding()
            .background(Color.green)
            .foregroundColor(.white)
            .cornerRadius(8)
            .scaleEffect(configuration.isPressed ? 0.95 : 1)
    }
}



