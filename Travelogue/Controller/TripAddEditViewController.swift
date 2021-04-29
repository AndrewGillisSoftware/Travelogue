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
        if let safeTrip = trip
        {
            nav.title = safeTrip.name
            tripNameField.text = safeTrip.name
        }
    }

    @IBAction func save(_ sender: Any)
    {
        var newTrip:Trip?
        
        if let safeTrip = trip
        {
            newTrip = safeTrip
            newTrip?.name = tripNameField.text ?? ""
        }
        else
        {
            newTrip = Trip(title: tripNameField.text ?? "")
        }
        
        do{
            try newTrip?.managedObjectContext?.save()
        }
        catch
        {
            print("Could Not Save Category")
        }
            
        
        trip = nil
        self.navigationController?.popViewController(animated: true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        tripNameField.resignFirstResponder()
    }
    
    @IBAction func changeTripName(_ sender: Any)
    {
        if let text = tripNameField.text
        {
            nav.title = text
        }
    }
    
}
