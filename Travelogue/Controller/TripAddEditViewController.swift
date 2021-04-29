//
//  TripAddEditViewController.swift
//  Travelogue
//
//  Created by Andrew on 4/27/21.
//

import UIKit
import CoreData

class TripAddEditViewController: UIViewController, UITextFieldDelegate{
    
    var coreDataContext: NSManagedObjectContext?
    
    @IBOutlet var nav: UINavigationItem!
    
    var trip:Trip?
    
    @IBOutlet var tripNameField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tripNameField.delegate = self
        
        //Trip Set
        if let safeTrip = trip
        {
            //Set Properties
            nav.title = safeTrip.name
            tripNameField.text = safeTrip.name
        }
    }

    //Simple Core Data function to save trip
    @IBAction func save(_ sender: Any)
    {
        var newTrip:Trip?
        
        //Trip Present
        if let safeTrip = trip
        {
            newTrip = safeTrip
            newTrip?.name = tripNameField.text ?? ""
        }
        else
        {
            //Use failable initilizer to generate new trip
            newTrip = Trip(title: tripNameField.text ?? "")
        }
        
        do{
            try newTrip?.managedObjectContext?.save()
        }
        catch
        {
            print("Could Not Save Trip")
        }
            
        //Reset trip so that it does try to save the last trip selected.
        trip = nil
        self.navigationController?.popViewController(animated: true)
    }
    
    //Allows keyboard to close on tounch out.
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        tripNameField.resignFirstResponder()
    }
    
    //Update the navigation title on trip name field change
    @IBAction func changeTripName(_ sender: Any)
    {
        if let text = tripNameField.text
        {
            nav.title = text
        }
    }
    
}
