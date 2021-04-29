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
    
    override func viewWillAppear(_ animated: Bool)
    {
        
    }
    
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
    
    @IBAction func choosePhoto(_ sender: Any)
    {
        guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary)
        else
        {
            print("can't open photo library")
            return
        }

        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self

        present(imagePicker, animated: true)
    }
    
    @IBAction func takePhoto(_ sender: Any)
    {
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else
        {
            print("camera not supported by this device")
            return
        }
        
        imagePicker.sourceType = .camera
        imagePicker.delegate = self
        present(imagePicker, animated: true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        logNameField.resignFirstResponder()
        logDiscriptionTextView.resignFirstResponder()
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        defer {
            picker.dismiss(animated: true)
        }

        print("did cancel")
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
            picker.dismiss(animated: true)
            
            if let image = info[.originalImage] as? UIImage
            {
                logImageView.image = image
            }
        
    }
    
}
