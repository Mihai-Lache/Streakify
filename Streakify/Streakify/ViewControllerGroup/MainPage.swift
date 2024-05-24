import SwiftUI

struct MainPageView: View {
    @StateObject private var userDatabase: Database
    @State private var showAddHabitView = false
    
    var username: String
    
    init(username: String) {
        // Assuming UserManager provides a method to fetch user database
        let database = UserManager.shared.fetchUserDatabase(username: username)
        self._userDatabase = StateObject(wrappedValue: database)
        self.username = username
    }
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Welcome, \(userDatabase.name)!")
                    .font(.largeTitle)
                    .padding()
                
                List {
                    ForEach(userDatabase.habits) { habit in
                        HabitRow(habit: habit)
                    }
                    .onDelete { indexSet in
                        indexSet.forEach { index in
                            userDatabase.removeHabit(userDatabase.habits[index])
                        }
                    }
                }
                
                Button(action: {
                    showAddHabitView = true
                }) {
                    Text("Add Habit")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .sheet(isPresented: $showAddHabitView) {
                    AddHabitView(database: userDatabase)
                }
            }
        }
    }
}

struct HabitRow: View {
    var habit: Habit
    
    var body: some View {
        Text(habit.name)
    }
}

struct MainPageView_Previews: PreviewProvider {
    static var previews: some View {
        MainPageView(username: "testuser")
    }
}
