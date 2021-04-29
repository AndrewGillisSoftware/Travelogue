//
//  LogViewController.swift
//  Travelogue
//
//  Created by Andrew on 4/27/21.
//

import UIKit
import CoreData

class LogAddEditViewController: UIViewController, UITextFieldDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate{

    var trip:Trip?
    
    var log:Log?
    
    var coreDataContext: NSManagedObjectContext?
    
    @IBOutlet var logNameField: UITextField!
    
    @IBOutlet var logDatePicker: UIDatePicker!
    
    @IBOutlet var logDiscriptionTextView: UITextView!
    
    @IBOutlet var logImageView: UIImageView!
    
    let imagePicker = UIImagePickerController()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        logNameField.delegate = self
        
        //Populate View
        if let safeLog = log
        {
            logNameField.text = safeLog.name
            logDatePicker.date = safeLog.date ?? Date()
            logDiscriptionTextView.text = safeLog.descriptionText
            logImageView.image = safeLog.image
        }
    }
    
    //save log in core data
    @IBAction func save(_ sender: Any)
    {
        //If safe save
        if let nameSafe = logNameField.text,
           let disSafe = logDiscriptionTextView.text,
           let imageSafe = logImageView.image
        {
            //Run Save
            if let context = self.coreDataContext,
               let safeTrip = self.trip
            {
                let newLog = Log(name: nameSafe, date: logDatePicker.date, discriptionText: disSafe, photo: imageSafe, trip: safeTrip)
                newLog?.trip = safeTrip
                
                //save the data
                do
                {
                    try context.save()
                    
                }
                catch
                {
                    print("Could Not Save")
                }
                do
                {
                    try trip = context.existingObject(with: safeTrip.objectID) as? Trip
                }
                catch
                {
                    print("Could Not Update Trip")
                }
            }
        }
        
        navigationController?.popViewController(animated: true)
    }
    
    //When folder button is clicked. Choose photo for log
    @IBAction func choosePhoto(_ sender: Any)
    {
        //verify photo library can be opened.
        guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary)
        else
        {
            print("can't open photo library")
            return
        }
        
        //Set the source of the image to be selected to the library.
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self

        //Show the photo library to the user
        present(imagePicker, animated: true)
    }
    
    @IBAction func takePhoto(_ sender: Any)
    {
        //veriy camera can be opened
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else
        {
            print("camera not supported by this device")
            return
        }
        
        //Set the source of the image to be from the camera.
        imagePicker.sourceType = .camera
        imagePicker.delegate = self
        
        //Show the camera application so user can take photo
        present(imagePicker, animated: true)
    }
    
    //Hide keyboard on tap outside
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        logNameField.resignFirstResponder()
        logDiscriptionTextView.resignFirstResponder()
    }
    
    //quit library/camera on cancel
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        defer {
            picker.dismiss(animated: true)
        }

        print("did cancel")
    }
    
    //Got Photo from camera or library
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
            picker.dismiss(animated: true)
            
            //Set image of the log to the selected or snapped photo
            if let image = info[.originalImage] as? UIImage
            {
                logImageView.image = image
            }
        
    }
    
}
