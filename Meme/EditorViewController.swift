//
//  EditorViewController.swift
//  Meme
//
//  Created by Alexandre Gonzalo on 1/11/2015.
//  Copyright © 2015 Agito Cloud. All rights reserved.
//

import Foundation
import UIKit

class EditorViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    enum textFieldLabel: String {
        case Top = "TOP"
        case Bottom = "BOTTOM"
    }

    @IBOutlet weak var pickedImageView: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var toolbar: UIToolbar!
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    
    let topTextFieldDelegate = MemeTextFieldDelegate()
    let bottomTextFieldDelegate = MemeTextFieldDelegate()
    
    var meme: Meme!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Define the delegate of the top and bottom text fields
        topTextField.delegate = topTextFieldDelegate
        bottomTextField.delegate = bottomTextFieldDelegate
        
        // Set the default attributes of the top and bottom text fields
        loadEditor()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        // Display the navigation bar and toolbar again
        navigationBar.hidden = false
        toolbar.hidden = false
        
        // Enable the camera button if the device has a camera
        cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
        
        // Subscribe to keyboard notifications (ie. be notified when the keyboard appears or not)
        subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        // Unsubscribe to keyboard notifications when the view disappears
        unsubscribeFromKeyboardNotifications()
    }
    
    // Initialise the meme editor: empty the image view, initialise the text fields and disable the navigation buttons
    func loadEditor() {
        view.endEditing(true)
        
        // Set the default attributes of the top and bottom text fields
        setDefaultTextAttributes(topTextField)
        setDefaultTextAttributes(bottomTextField)
        
        if let existingMeme = meme {
            // If the editor edits an existing meme: initalize the image and text fields with the meme data
            enableNavigationButtons()
            topTextField.text = existingMeme.topText
            bottomTextField.text = existingMeme.bottomText
            pickedImageView.image = existingMeme.image
            pickedImageView.contentMode = .ScaleAspectFit
        } else {
            // If the editor creates a new meme: initialize an empty image view and text fields with TOP and BOTTOM
            initMeme()
        }
    }
    
    func initMeme() {
        disableNavigationButtons()
        topTextField.text = textFieldLabel.Top.rawValue
        bottomTextField.text = textFieldLabel.Bottom.rawValue
        pickedImageView.image = nil
    }
    
    @IBAction func cancel(sender: UIBarButtonItem) {
        // Reinitialize the meme
        loadEditor()
    }
    
    func setDefaultTextAttributes(textField: UITextField) {
        textField.defaultTextAttributes = getMemeTextAttributes(40.0)
        textField.textAlignment = .Center
    }
    
    // Action to pick an image from the photo library
    @IBAction func pickAnImage(sender: AnyObject) {
        // Innvoke the UIImagePickerController with Photo Library as Source
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        
        // Present the UIImagePickerController
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    // Function implementing the UIImagePickerControllerDelegate protocal
    // Retrieve the image picked by the user and display in the UI View
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        // Get the original picked image and assign it to the imageView component in Storyboard
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            pickedImageView.image = image
            pickedImageView.contentMode = .ScaleAspectFit
            enableNavigationButtons()
        }
        // Dismiss the Image Picker View Controller
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // Action to take a picture with the camera
    @IBAction func TakeAPictureWithCamera(sender: AnyObject) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    // Enable navigation buttons
    func enableNavigationButtons() -> Void {
        shareButton.enabled = true
        cancelButton.enabled = true
    }
    
    // Disable navigations buttons
    func disableNavigationButtons() -> Void {
        shareButton.enabled = false
        cancelButton.enabled = false
    }
    
    @IBAction func shareImage(sender: AnyObject) {
        let activityViewController = UIActivityViewController(activityItems: [generateMemedImage()], applicationActivities: nil)
        activityViewController.completionWithItemsHandler = sharingCompletionHandler
        presentViewController(activityViewController, animated: true, completion: nil)
    }
    
    func sharingCompletionHandler(activityType: String?, completed: Bool, returnedItems: [AnyObject]?, activityError: NSError?) -> Void {
        save()
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func generateMemedImage() -> UIImage
    {
        // Dismiss keyboard
        view.endEditing(true)
        
        // Hide the navigation bar and toolbar
        navigationBar.hidden = true
        toolbar.hidden = true
        
        // Render view to an image
        UIGraphicsBeginImageContextWithOptions(view.frame.size, true, 0.0)
        view.drawViewHierarchyInRect(view.frame, afterScreenUpdates: true)
        let memedImage : UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        // Display the navigation bar and toolbar again
        navigationBar.hidden = false
        toolbar.hidden = false
        
        return memedImage
    }
    
    func save() {
        //Create the meme
        meme = Meme(topText: topTextField.text!, bottomText: bottomTextField.text!, image: pickedImageView.image!, memedImage: generateMemedImage())
        
        // Add it to the memes array in the Application Delegate
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as! AppDelegate
        appDelegate.memes.append(meme)
     }
    
    func keyboardWillShow(notification: NSNotification) {
        // if the bottom text field displays the keyboard, move the frame up so the bottom can be seen while being edited
        if bottomTextField.isFirstResponder() {
            view.frame.origin.y = -getKeyboardHeight(notification)
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        // When keyboard hides, bring the frame back to its orginal place
        if bottomTextField.isFirstResponder() {
            view.frame.origin.y = 0
        }
    }
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.CGRectValue().height
    }
    
    func subscribeToKeyboardNotifications() {
        // Subscribe to Keyboard duisplay and dismiss
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        // Unsubscribe to Keyboard duisplay and dismiss
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
    
}

