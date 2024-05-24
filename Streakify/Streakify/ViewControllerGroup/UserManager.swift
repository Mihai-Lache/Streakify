import Foundation
import CryptoKit
import SwiftData

class UserManager {
    static let shared = UserManager()
    
    private var users: [Database] = []
    
    private init() {}
    
    func createUser(name: String, username: String, email: String, password: String, completion: @escaping (Bool) -> Void) {
        if let _ = getUserByEmail(email) {
            completion(false)
            return
        }
        
        let hashedPassword = hashPassword(password)
        let newUser = Database(name: name, username: username, email: email, password: hashedPassword)
        
        if saveUser(newUser) {
            completion(true)
        } else {
            completion(false)
        }
    }
    
    func loginUser(username: String, password: String, completion: @escaping (Bool, Database?) -> Void) {
        guard let user = getUserByUsername(username) else {
            completion(false, nil)
            return
        }
        
        if verifyPassword(password, hashedPassword: user.password) {
            completion(true, user)
        } else {
            completion(false, nil)
        }
    }
    
    func addHabit(for user: Database, habit: Habit) {
        if let index = users.firstIndex(where: { $0.id == user.id }) {
            users[index].addHabit(habit)
        }
    }
    
    func removeHabit(for user: Database, habit: Habit) {
        if let index = users.firstIndex(where: { $0.id == user.id }) {
            users[index].removeHabit(habit)
        }
    }
    
    private func getUserByEmail(_ email: String) -> Database? {
        return users.first(where: { $0.email == email })
    }

    func getUserByUsername(_ username: String) -> Database? {
        return users.first(where: { $0.username == username })
    }
    
    private func saveUser(_ user: Database) -> Bool {
        users.append(user)
        return true
    }
    
    private func hashPassword(_ password: String) -> String {
        let data = Data(password.utf8)
        let hashed = SHA256.hash(data: data)
        return hashed.compactMap { String(format: "%02x", $0) }.joined()
    }
    
    private func verifyPassword(_ password: String, hashedPassword: String) -> Bool {
        let hashedInputPassword = hashPassword(password)
        return hashedInputPassword == hashedPassword
    }
}
