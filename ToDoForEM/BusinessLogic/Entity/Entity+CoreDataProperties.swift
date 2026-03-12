//
//  Entity+CoreDataProperties.swift
//  ToDoForEM
//
//  Created by Aleksandr Pashin on 12.03.2026.
//
//

import Foundation
import CoreData


extension Entity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Entity> {
        return NSFetchRequest<Entity>(entityName: "Entity")
    }

    @NSManaged public var complited: Bool
    @NSManaged public var date: Date?
    @NSManaged public var id: Int64
    @NSManaged public var title: String?
    @NSManaged public var todo: String?
    @NSManaged public var userid: Int64

}

extension Entity : Identifiable {

}
