//
//  MealViewController.swift
//  FoodTracker1
//
//  Created by Hussam Alshudukhi on 2017-01-23.
//  Copyright © 2017 Hussam Alshudukhi. All rights reserved.
//

import UIKit
import os.log


class MealViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate  {
    //MARK: Properties
    
    
    // Outlets for a meal entry/edition/deletion process + an outlet for the Save bar button item.
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var ratingControl: RatingControl!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    
    var meal: Meal?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // nameTextField here is controlled via the .delegate property and is assigned to this MealViewController class so it sets itself to be the delegate for nameTextField.
       
        nameTextField.delegate = self
        
        
        // Bring up the selected meal information for editing mode
        
        if let meal = meal {
            navigationItem.title = meal.name
            nameTextField.text = meal.name
            photoImageView.image = meal.photo
            ratingControl.rating = meal.rating
        }
        
        // The Save button state switches to enabled if the meal has a valid name
        
        updateSaveButtonState()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: UITextFieldDelegate
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        // The Save button is disabled until the user finishes editing and hits return/Done
        
        saveButton.isEnabled = false
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Make the keyboard invisible
        textField.resignFirstResponder()
        return true
    }
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        updateSaveButtonState()
        navigationItem.title = textField.text
    }
    
    
    
    //MARK: UIImagePickerControllerDelegate
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
       
        // Forfeit process once photo selection is cancelled
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
       
        // Use the original image selected by the user to prevent experiencing different view of the image
        
        guard let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        
        // photoImageView outlet is assigned to view the photo selected by the user
        
        photoImageView.image = selectedImage
        
        // Forfeit image selection
        
        dismiss(animated: true, completion: nil)
    }
    
    
    //MARK: Navigation 
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        
        // Dimiss if presentaion is modal or push
        
        let isPresentingInAddMealMode = presentingViewController is UINavigationController
        
        if isPresentingInAddMealMode {
        dismiss(animated: true, completion: nil)
        }
            
        
        else if let owningNavigationController = navigationController {
            owningNavigationController.popViewController(animated: true)
        }
        
        else {
            fatalError("The MealViewController is not inside a navigation controller.")
        }
    }
    
    
    
    // Prepare a scene before it is displayed
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        super.prepare(for: segue, sender: sender)
        
        // Set the view controller when the user hits the Save button
        
        guard let button = sender as? UIBarButtonItem, button === saveButton else {
            os_log("The save button was not pressed, cancelling", log: OSLog.default, type: .debug)
            return
        }
        
        let name = nameTextField.text ?? ""
        let photo = photoImageView.image
        let rating = ratingControl.rating
        
        // After the Save button is pressed and the unwind segue, the meal is saved
        
        meal = Meal(name: name, photo: photo, rating: rating)
        
    }
    
    
    
    
    //MARK: Actions

            
    @IBAction func selectImageFromPhotoLibrary(_ sender: UITapGestureRecognizer) {
        
        // Make the keyboard invisible
        
        nameTextField.resignFirstResponder()
        
        // Allow users to select a photo from their own photo library using the view controller UIImagePickerController()
        
        let imagePickerController = UIImagePickerController()
        
        // Disallow users from taking photos directly from the camera. It is resticted to select form the phone photo library
        
        imagePickerController.sourceType = .photoLibrary
        
        // Once a user picked a photo, the class is notified in accordance with the action taken by the user
        
        imagePickerController.delegate = self
        
        //This present method asks MealViewController to display the view controller created by imagePickerController object
        
        present(imagePickerController, animated: true, completion: nil)
    }

    //MARK: Private Methods
    
    private func updateSaveButtonState() {
        
        // The Save button is disabled until the user enters a meal name
        
        let text = nameTextField.text ?? ""
        saveButton.isEnabled = !text.isEmpty
    }
    
}

