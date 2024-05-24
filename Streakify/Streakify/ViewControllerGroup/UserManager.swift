import Foundation

class UserManager {
    static let shared = UserManager()
    private var users: [String: Database] = [:]
    
    private init() {}
    
    func loginUser(username: String, password: String, completion: @escaping (Bool, Database?) -> Void) {
        if let user = users[username], user.password == password {
            completion(true, user)
        } else {
            completion(false, nil)
        }
    }
    
    func fetchUserDatabase(username: String) -> Database {
        return users[username] ?? Database(name: "", username: "", email: "", password: "")
    }
    
    func registerUser(name: String, username: String, email: String, password: String) {
        let newUser = Database(name: name, username: username, email: email, password: password)
        users[username] = newUser
    }
}
