//
//  LogsViewController.swift
//  Travelogue
//
//  Created by Andrew on 4/27/21.
//

import UIKit
import CoreData

class LogsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var logsTableView: UITableView!
    
    var trip:Trip?

    var logs:[Log]
    {
        get
        {
            return trip?.logs ?? []
        }
    }
    
    let dateFormatter = DateFormatter()
    
    var coreDataContext: NSManagedObjectContext?
    
    @IBOutlet var nav: UINavigationItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        logsTableView.delegate = self
        // Do any additional setup after loading the view.
        dateFormatter.dateFormat = "MMM d, yyyy"
    }

    override func viewWillAppear(_ animated: Bool)
    {
        //reload list
        self.logsTableView.reloadData()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return logs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = logsTableView.dequeueReusableCell(withIdentifier: "logCell", for: indexPath)
        
        //Set cell to model data
        if let cellCasted = cell as? LogTableViewCell
        {
            //Fill Custom Cell
            let cellLog = logs[indexPath.row]
            
            cellCasted.logNameLabel.text = cellLog.name
            cellCasted.logImage.image = cellLog.image
            //There is a date
            if let safeDate = cellLog.date
            {
                cellCasted.logDateLabel.text = dateFormatter.string(from: safeDate)
            }
            else
            {
                cellCasted.logDateLabel.text = ""
            }
            
        }
        
        return cell
    }
    
     func tableView(_ tableView: UITableView, canEditRowAt indexPath:IndexPath)->Bool
    {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath:IndexPath){
        if(editingStyle == .delete)
        {
            //handle delete
            let delLog = self.logs[indexPath.row]
            
            self.coreDataContext?.delete(delLog)
            
            do
            {
                try self.coreDataContext?.save()
            }
            catch
            {
                print("Could Not Delete")
            }
            
            self.logsTableView.reloadData()
        }
    }
    
    //Segue to edit view
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        switch(segue.identifier)
        {
            //Set Log and tru
            case "addLog":
                guard let vC = segue.destination as? LogAddEditViewController else{return}
                vC.trip = trip
            //Populate Fields on edit log and set trip
            case "editLog":
                guard let vC = segue.destination as? LogAddEditViewController else{return}
                if let index = logsTableView.indexPathForSelectedRow?.row
                {
                    vC.log = logs[index]
                    vC.trip = trip
                }
            default:
                print("Critical Error")
        }
    }
}
