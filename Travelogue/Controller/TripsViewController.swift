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
    
    var isEdit:Bool = false
    
    var coreDataContext: NSManagedObjectContext?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tripsTableView.delegate = self
        
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate
        else {
            return
        }
        let context = appDelegate.persistentContainer.viewContext
        coreDataContext = context
        
        let fetchRequest: NSFetchRequest<Trip> = Trip.fetchRequest()
        do{
            //Get full list of categories from core data
            trips = try context.fetch(fetchRequest)
        }
        catch
        {
            print("Could Not Fetch")
        }
        
        tripsTableView.reloadData()
    }
    
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection: Int) -> Int {
        return trips.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath)-> UITableViewCell
    {
        let cell = tripsTableView.dequeueReusableCell(withIdentifier: "tripCell", for: indexPath)
        if let castedCell = cell as? TripTableViewCell
        {
            castedCell.tripLabel?.text = trips[indexPath.row].name
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView,
             didSelectRowAt indexPath: IndexPath) {
        //is the current view in trip edit mode
        if isEdit {
            performSegue(withIdentifier: "editTrip", sender: nil)
        } else {
            performSegue(withIdentifier: "viewTripLogs", sender: nil)
        }
    }
    
    func deleteCategory(index:Int)
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
                    self.deleteCategory(index: indexPath.row)
                }))

                refreshAlert.addAction(UIAlertAction(title: "No", style: .cancel, handler: { (action: UIAlertAction!) in
                      
                }))

                present(refreshAlert, animated: true, completion: nil)
            }
            //No logs in Trip just delete Trip
            else
            {
                self.deleteCategory(index: indexPath.row)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        switch(segue.identifier)
        {
            case "newTrip":
                guard let vC = segue.destination as? TripAddEditViewController else{return}
                
                vC.coreDataContext = coreDataContext
                
                isEdit = false
                EditNavButton.title = "Edit"
                
            case "editTrip":
                guard let vC = segue.destination as? TripAddEditViewController else{return}
                if  let index = tripsTableView.indexPathForSelectedRow?.row
                {
                    let trip = trips[index]
                    vC.trip = trip
                    vC.coreDataContext = coreDataContext
                }
            case "viewTripLogs":
                guard let vC = segue.destination as? LogsViewController else{return}
                if  let index = tripsTableView.indexPathForSelectedRow?.row
                {
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

