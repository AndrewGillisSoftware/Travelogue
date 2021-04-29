//
//  Trip+CoreDataClass.swift
//  Travelogue
//
//  Created by Andrew on 4/27/21.
//
//

import UIKit
import CoreData

@objc(Trip)
public class Trip: NSManagedObject {
    
    //Easy accessor for Log Array. DO NOT access rawLogs directly as it is a set type.
    var logs: [Log]? {
        return self.rawLogs?.array as? [Log]
    }
    
    //Failable initilizer for Trip. Makes it easier to create a trip
    convenience init?(title: String) {
        
        //Get App Delegate to extract the persistant container context (Core Data) easier
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        
        //Check the context is not nil
        guard let context = appDelegate?.persistentContainer.viewContext
        else {
            return nil
        }
        
        //Create trip entity
        self.init(entity: Trip.entity(), insertInto: context)
        
        //Set its properties
        self.name = title
    }
}
