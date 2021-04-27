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
    
    var logs: [Log]? {
        return self.rawLogs?.array as? [Log]
    }
    
    convenience init?(title: String) {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        
        guard let context = appDelegate?.persistentContainer.viewContext
        else {
            return nil
        }
        
        self.init(entity: Trip.entity(), insertInto: context)
        
        self.name = title
    }
}
