//
//  Database.swift
//  Streakify
//
//  Created by Arya on 4/25/24.
//

//This DataBase is used to store User LogIn information, including 
import Foundation
import SwiftData

@Model
class Database:Identifiable {
    var id: String
    var name: String
    var username: String
    var email: String
    var password: String
    var habbits: [String]
    
    init(name: String, username: String, email: String, password: String){
        self.id = UUID().uuidString
        self.name = name
        self.username = username
        self.email = email
        self.password = password
        self.habbits = []
    }
    
}
