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
    //Easy accessor for image. DO NOT access rawPhoto directly.
    var image: UIImage?
    {
        if let safeData = rawPhoto
        {
            return UIImage(data: safeData)
        }
        return nil
    }
    
    //Failable initilizer for Log. Makes log creation much easier.
    convenience init?(name: String, date: Date, discriptionText: String, photo: UIImage, trip: Trip)
    {
        //Get App Delegate to extract the persistant container context (Core Data) easier
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        
        //Check the context is not nil
        guard let context = appDelegate?.persistentContainer.viewContext
        else {
            return nil
        }
        
        //Create a Log entity
        self.init(entity: Log.entity(), insertInto: context)
        
        //Set its properties
        self.name = name
        self.date = date
        self.descriptionText = discriptionText
        //Used Jpeg because there is a weird bug with pngData not storing orentation of the image. Set to 1 for max quality
        self.rawPhoto = photo.jpegData(compressionQuality: 1.0)
        self.trip = trip
    }
}
