//
//  HabitItem+CoreDataProperties.swift
//  Streakify
//
//  Created by Shaveta on 5/2/24.
//
//

import Foundation
import CoreData


extension HabitItem {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<HabitItem> {
        return NSFetchRequest<HabitItem>(entityName: "HabitItem")
    }

    @NSManaged public var name: String?
    @NSManaged public var createdAt: Date?

}

extension HabitItem : Identifiable {

}
