//
//  Trip+CoreDataProperties.swift
//  Travelogue
//
//  Created by Andrew on 4/27/21.
//
//

import Foundation
import CoreData


extension Trip {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Trip> {
        return NSFetchRequest<Trip>(entityName: "Trip")
    }

    @NSManaged public var name: String?
    @NSManaged public var rawLogs: NSOrderedSet?

}

// MARK: Generated accessors for rawLogs
extension Trip {

    @objc(insertObject:inRawLogsAtIndex:)
    @NSManaged public func insertIntoRawLogs(_ value: Log, at idx: Int)

    @objc(removeObjectFromRawLogsAtIndex:)
    @NSManaged public func removeFromRawLogs(at idx: Int)

    @objc(insertRawLogs:atIndexes:)
    @NSManaged public func insertIntoRawLogs(_ values: [Log], at indexes: NSIndexSet)

    @objc(removeRawLogsAtIndexes:)
    @NSManaged public func removeFromRawLogs(at indexes: NSIndexSet)

    @objc(replaceObjectInRawLogsAtIndex:withObject:)
    @NSManaged public func replaceRawLogs(at idx: Int, with value: Log)

    @objc(replaceRawLogsAtIndexes:withRawLogs:)
    @NSManaged public func replaceRawLogs(at indexes: NSIndexSet, with values: [Log])

    @objc(addRawLogsObject:)
    @NSManaged public func addToRawLogs(_ value: Log)

    @objc(removeRawLogsObject:)
    @NSManaged public func removeFromRawLogs(_ value: Log)

    @objc(addRawLogs:)
    @NSManaged public func addToRawLogs(_ values: NSOrderedSet)

    @objc(removeRawLogs:)
    @NSManaged public func removeFromRawLogs(_ values: NSOrderedSet)

}

extension Trip : Identifiable {

}
