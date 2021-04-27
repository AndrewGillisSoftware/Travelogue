//
//  Log+CoreDataProperties.swift
//  Travelogue
//
//  Created by Andrew on 4/27/21.
//
//

import Foundation
import CoreData


extension Log {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Log> {
        return NSFetchRequest<Log>(entityName: "Log")
    }

    @NSManaged public var name: String?
    @NSManaged public var date: Date?
    @NSManaged public var descriptionText: String?
    @NSManaged public var rawPhoto: Data?
    @NSManaged public var trip: Trip?

}

extension Log : Identifiable {

}
