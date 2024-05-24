//  Habit.swift
//  Streakify
//
//  Created by Arya on 4/25/24.
//

import Foundation
import SwiftData
class Habit: Identifiable, Codable {
    var id: String
    var name: String
    var description: String
    var totalDuration: Int
    var completionDates: [Date]
    var notificationFrequency: String
    var notificationTime: Date?
    var notificationDays: [String]

    init(name: String, description: String, totalDuration: Int) {
        self.id = UUID().uuidString
        self.name = name
        self.description = description
        self.totalDuration = totalDuration
        self.completionDates = []
        self.notificationFrequency = "None"
        self.notificationTime = nil
        self.notificationDays = []
    }
}
