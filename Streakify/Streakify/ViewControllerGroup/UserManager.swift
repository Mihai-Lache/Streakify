//  UserManager.swift
//  Streakify
//
//  Created by Srikar Rani on 5/16/24.
//

import Foundation
import CryptoKit
import SwiftData

class UserManager {
    static let shared = UserManager()
    
    private var users: [Database] = []
    
    private init() {}
    
    func createUser(name: String, username: String, email: String, password: String, completion: @escaping (Bool) -> Void) {
        // Check if the user already exists
        if let _ = getUserByEmail(email) {
            completion(false)
            return
        }
        
        // Create a new user
        let hashedPassword = hashPassword(password)
        let newUser = Database(name: name, username: username, email: email, password: hashedPassword)
        
        // Save the user to the database
        if saveUser(newUser) {
            completion(true)
        } else {
            completion(false)
        }
    }
    
    func loginUser(username: String, password: String, completion: @escaping (Bool, Database?) -> Void) {
        // Retrieve the user from the database
        guard let user = getUserByUsername(username) else {
            completion(false, nil)
            return
        }
        
        // Verify the password
        if verifyPassword(password, hashedPassword: user.password) {
            completion(true, user)
        } else {
            completion(false, nil)
        }
    }

    
    private func getUserByEmail(_ email: String) -> Database? {
        return users.first(where: { $0.email == email })
    }

    private func getUserByUsername(_ username: String) -> Database? {
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
