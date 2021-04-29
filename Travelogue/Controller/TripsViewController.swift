//
//  ViewController.swift
//  Travelogue
//
//  Created by Andrew on 4/16/21.
//

import UIKit
import CoreData

class TripsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var tripsTableView: UITableView!
    
    @IBOutlet var EditNavButton: UIBarButtonItem!
    
    var trips:[Trip] = []
    
    //Edit is shown = false. Note does not show current action on nav button
    var isEdit:Bool = false
    
    var coreDataContext: NSManagedObjectContext?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tripsTableView.delegate = self
        
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        //Get Appdelegate to aquire persistant container context. We will not have to do this elsewhere as this context will be passed during view transition.
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate
        else {
            return
        }
        let context = appDelegate.persistentContainer.viewContext
        coreDataContext = context
        
        //Fetch all trips from the core data context and set the trips array to it.
        let fetchRequest: NSFetchRequest<Trip> = Trip.fetchRequest()
        do{
            //Get full list of trips from core data
            trips = try context.fetch(fetchRequest)
        }
        catch
        {
            print("Could Not Fetch")
        }
        
        tripsTableView.reloadData()
    }
    
    //When edit button is pushed adjust the UI to opposite of current action
    @IBAction func editTrip(_ sender: Any) {
        isEdit.toggle()
        if !isEdit
        {
            EditNavButton.title = "Edit"
        }
        else
        {
            EditNavButton.title = "Done"
        }
    }
    
    //Set entries in the tableview to number of trips
    func tableView(_ tableView: UITableView, numberOfRowsInSection: Int) -> Int {
        return trips.count
    }
    
    //Fill cells based on trip data
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath)-> UITableViewCell
    {
        //Although it was not required to use a custom tableview cell. I used one for expandablity.
        let cell = tripsTableView.dequeueReusableCell(withIdentifier: "tripCell", for: indexPath)
        if let castedCell = cell as? TripTableViewCell
        {
            castedCell.tripLabel?.text = trips[indexPath.row].name
        }
        return cell
    }
    
    //On selection of a trip cell determine seque based on if in edit mode or not.
    func tableView(_ tableView: UITableView,
             didSelectRowAt indexPath: IndexPath) {
        //is the current view in trip edit mode
        if isEdit {
            performSegue(withIdentifier: "editTrip", sender: nil)
        } else {
            performSegue(withIdentifier: "viewTripLogs", sender: nil)
        }
    }
    
    //Core data delete trip. Due to trip deletion being dangerous a function is required because there are two cases a trip can be deleted. One it has no logs. Two user accepted the prompt. This function makes it easier to do that logic in the following method.
    func deleteTrip(index:Int)
    {
        //Simply deletes trip given the index
        let delTrip = self.trips[index]
        
        self.trips.remove(at: index)
        
        self.coreDataContext?.delete(delTrip)
        
        do
        {
            try self.coreDataContext?.save()
        }
        catch
        {
            print("Could Not Delete")
        }
        
        self.tripsTableView.reloadData()
    }
    
    //Handles trip cell deletion and prompts users if there are logs within the trip.
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath:IndexPath){
        if(editingStyle == .delete)
        {
            //if no logs or it doesnt exist dont run alert
            if !(self.trips[indexPath.row].logs?.isEmpty ?? true)
            {
                //PROMPT USER with ALERT
                let refreshAlert = UIAlertController(title: "Trip Deletion", message: "All data will be lost inside Trip.\nDo you wish to proceed?", preferredStyle: UIAlertController.Style.alert)

                refreshAlert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action: UIAlertAction!) in
                    //handle delete
                    self.deleteTrip(index: indexPath.row)
                }))

                refreshAlert.addAction(UIAlertAction(title: "No", style: .cancel, handler: { (action: UIAlertAction!) in
                      
                }))

                present(refreshAlert, animated: true, completion: nil)
            }
            //No logs in Trip just delete Trip
            else
            {
                self.deleteTrip(index: indexPath.row)
            }
        }
    }
    
    //Force the height of cells in the table programatically.
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    //Send data to the next view on segue.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        //Where are we transitioning too?
        switch(segue.identifier)
        {
            case "newTrip":
                //Cast the view controller variable to the next view
                guard let vC = segue.destination as? TripAddEditViewController else{return}
                
                //Set the context so it doesnt need to get it again.
                vC.coreDataContext = coreDataContext
                
                //Reset edit button. Feels weird not to.
                isEdit = false
                EditNavButton.title = "Edit"
                
            case "editTrip":
                //Cast the view controller variable to the next view
                guard let vC = segue.destination as? TripAddEditViewController else{return}
                
                //Find selected trip
                if  let index = tripsTableView.indexPathForSelectedRow?.row
                {
                    //Set properties
                    let trip = trips[index]
                    vC.trip = trip
                    vC.coreDataContext = coreDataContext
                }
                //Incorrect row selected don't set the context and the other properties. Prevent saving.
        
            case "viewTripLogs":
                //Cast the view controller variable to the next view
                guard let vC = segue.destination as? LogsViewController else{return}
                
                //Find selected trip
                if  let index = tripsTableView.indexPathForSelectedRow?.row
                {
                    //Set properties
                    let trip = trips[index]
                    vC.nav.title = trip.name
                    vC.trip = trip
                    vC.coreDataContext = coreDataContext
                }
            default:
                print("Segue Error")
        }
    }
}

