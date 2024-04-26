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
        ScrollView {
            LazyVStack {
                ForEach($habits) { $habit in
                    HabitRow(habit: $habit, deleteAction: {
                        if let index = habits.firstIndex(where: { $0.id == habit.id }) {
                            habits.remove(at: index)
                        }
                    })
                    .listRowBackground(Color(red: 11 / 255, green: 37 / 255, blue: 64 / 255))
                    Divider().background(Color.white.opacity(0.2))
                }
                .onDelete(perform: deleteHabits)
            }
        }
        .background(VisualEffectBlur(blurStyle: .dark)) // Apply blur effect to the background
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
                habit.progress = habit.progress == 1.0 ? 0.0 : 1.0
            }) {
                Image(systemName: habit.progress == 1.0 ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(habit.progress == 1.0 ? .green : .gray)
                    .imageScale(.large)
            }
            .buttonStyle(PlainButtonStyle())

            VStack(alignment: .leading) {
                Text(habit.name)
                    .font(.headline)
                    .foregroundColor(.white)
                Text("Progress: \(habit.progress * 100, specifier: "%.0f")%")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
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
        .shadow(radius: 5)
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














///ADD NEW HABIT



struct AddHabitView: View {
    @Binding var habits: [Habit]
    @Environment(\.presentationMode) var presentationMode
    @State private var habitName: String = ""
    @State private var isAnimatingButton: Bool = false

    // Using the specific color as a constant
    let backgroundColor = Color(red: 11 / 255, green: 37 / 255, blue: 64 / 255)
    var body: some View {
        ZStack {
            // Background with the specific color
            backgroundColor.edgesIgnoringSafeArea(.all)
            
            // Content
            VStack(spacing: 20) {
                Spacer()
                // Habit Text Field
                TextField("What's the habit?", text: $habitName)
                    .padding()
                    .background(VisualEffectBlur(blurStyle: .dark)) // Use VisualEffectBlur for modern blur effect
                    .cornerRadius(16)
                    .foregroundColor(.white) //this is the cursor of typing a habit
                    .padding(.horizontal, 20)
                
                // Save Button
                Button(action: {
                    saveHabit()
                }) {
                    Text("Let's do this!")
                        .bold()
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 16).fill(isAnimatingButton ? Color.green.opacity(0.7) : Color.green))
                        .scaleEffect(isAnimatingButton ? 0.95 : 1)
                        .foregroundColor(.white)
                }
                .disabled(habitName.isEmpty)
                .padding(.horizontal, 20)
                
                Spacer()
                
                // Cancel button
                Button("Cancel") {
                    presentationMode.wrappedValue.dismiss()
                }
                .foregroundColor(.white)
                .padding()
            }
        }
        .onAppear {
            // Start with a slightly delayed animation to draw attention to the text field
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                withAnimation(.easeOut(duration: 0.7)) {
                    isAnimatingButton = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                        withAnimation(.easeIn(duration: 0.3)) {
                            isAnimatingButton = false
                        }
                    }
                }
            }
        }
    }

    private func saveHabit() {
        let newHabit = Habit(name: habitName, progress: 0.0)
        habits.append(newHabit)
        presentationMode.wrappedValue.dismiss()
    }
}


// Since VisualEffectBlur is not a default SwiftUI view, we need to create it
struct VisualEffectBlur: UIViewRepresentable {
    var blurStyle: UIBlurEffect.Style
    
    func makeUIView(context: Context) -> UIVisualEffectView {
        return UIVisualEffectView(effect: UIBlurEffect(style: blurStyle))
    }
    
    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {}
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


