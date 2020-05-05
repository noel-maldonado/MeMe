//
//  ViewController.swift
//  MeMe
//
//  Created by Noel Maldonado on 5/4/20.
//  Copyright © 2020 Noel Maldonado. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var topToolbar: UIToolbar!
    @IBOutlet weak var bottomToolbar: UIToolbar!
    @IBOutlet weak var topText: UITextField!
    @IBOutlet weak var bottomText: UITextField!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        enableCameraButton(cameraButton)
        memeTextFieldSetUp(topText, "Top")
        memeTextFieldSetUp(bottomText, "Bottom")
        shareButton.isEnabled = false
    }

    
    
    
    //Check if device has a camera
    func enableCameraButton(_ button: UIBarButtonItem) {
        button.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
    }
    
    //Set up textField attributes, center align, delegate, set text and background
    func memeTextFieldSetUp(_ textField: UITextField, _ textInput: String) {
        let memeTextAttributes: [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.strokeColor: UIColor.black,
            NSAttributedString.Key.foregroundColor: UIColor.white,
            NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
            NSAttributedString.Key.strokeWidth: -2.0
        ]
        //adds teh UITextFieldDelegate
        textField.delegate = self
        //adds the attributes created above
        textField.defaultTextAttributes = memeTextAttributes
        //centers the texts
        textField.textAlignment = .center
        //adds the textInput String as the text for the textfield
        textField.text = textInput
        //makes the background clear/transparent
        textField.backgroundColor = UIColor.clear
    }
    
    
    
     @IBAction func pickAnImage(_ sender: Any) {
        //creates the image picker controller
        let imagePicker = UIImagePickerController()
        //sets the source type to photo library
        imagePicker.sourceType = .photoLibrary
        //adds the delegate
        imagePicker.delegate = self
        //presents the image picekr
        present(imagePicker, animated: true, completion: nil)
    }
        //delegate function to dismiss impagepicker when cancel is pressed
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            dismiss(animated: true, completion: nil)
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[.originalImage] as? UIImage {
                self.image.contentMode = .scaleAspectFit
                self.image.image = image
                //Enables share button if Image was picked
                shareButton.isEnabled = true
            }
            //hides the gallery and show the view
            dismiss(animated: true, completion: nil)
        }
    
    
    @IBAction func pickAnImageFromCamera(_ sender: Any) {
            let imagePicker = UIImagePickerController()
            imagePicker.sourceType = .camera
            imagePicker.delegate = self
            present(imagePicker, animated: true, completion: nil)
        }
    //checks to see if user started editing and if the default text is still there
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == topText && topText.text == "Top" {
            textField.text = ""
        }
        if textField == bottomText && bottomText.text == "Bottom" {
            textField.text = ""
        }
    }
    //when return is pressed the keyboard disappears
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
       return true
    }
    //edits the view to allow text to be seen while typing
    @objc func keyboardWillShow(_ notification: Notification) {
        if bottomText.isFirstResponder {
            view.frame.origin.y = -getKeyboardHeight(notification)
        }
    }
    
    //sets the view back in its orginal place
    @objc func keyboardWillHide(_ notification: Notification) {
        view.frame.origin.y = 0
    }
    
    func getKeyboardHeight(_ notification: Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }
    
    //creates observers for the keyboard
    func subscribeToKeyboardNotifications() {
        //adds observer associated with keyboardWillShow
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    //removes observers associated with the keyboard
    func unsubscribeFromKeyboardNotifications() {
        //removes observer associated with keyboardWillShow
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    func save() {
        //Create the meme
        let image = generateMemedImage()
        // save the meme image in a meme object
        let meme = MeMe(topText: topText.text!, bottomText: bottomText.text!, image: self.image.image!, meme: image)
        //Meme object can be saved to an array, core data
    }
    
    func generateMemedImage() -> UIImage {
        
        // Hide toolbar and navbar
        topToolbar.isHidden = true
        bottomToolbar.isHidden = true
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()

        //Show toolbar and navbar
        topToolbar.isHidden = false
        bottomToolbar.isHidden = false
        // returns the image generated
        return memedImage
    }
    // Action associated with share image on left side of top toolbar
    @IBAction func shareMeme(_ sender: Any) {
        //creates the meme Image
        let meme = generateMemedImage()
        //sets up activitiy vie controller with the generated meme as a item
        let controller = UIActivityViewController(activityItems: [meme], applicationActivities: nil)
        //adds a completion handler to the controller
        controller.completionWithItemsHandler = { (type, completed, items, error) in
            //if controller was completed successfully, the save() is called
            if completed {
                self.save()
            }
        }
        //presents the activity view controller
        present(controller, animated: true, completion: nil)
    }
    
    
}

