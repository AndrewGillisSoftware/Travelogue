//
//  Log+CoreDataClass.swift
//  Travelogue
//
//  Created by Andrew on 4/27/21.
//
//

import UIKit
import CoreData

@objc(Log)
public class Log: NSManagedObject
{
    var image: UIImage?
    {
        if let safeData = rawPhoto
        {
            return UIImage(data: safeData)
        }
        return nil
    }
    
    convenience init?(name: String, date: Date, discriptionText: String, photo: UIImage, trip: Trip)
    {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        
        guard let context = appDelegate?.persistentContainer.viewContext
        else {
            return nil
        }
        
        self.init(entity: Log.entity(), insertInto: context)
        
        self.name = name
        self.date = date
        self.descriptionText = discriptionText
        self.rawPhoto = photo.pngData()
        self.trip = trip
    }
}
