//
//  ViewController.swift
//  MeMe
//
//  Created by Noel Maldonado on 5/4/20.
//  Copyright © 2020 Noel Maldonado. All rights reserved.
//

import UIKit

class MemeEditorViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var topToolbar: UIToolbar!
    @IBOutlet weak var bottomToolbar: UIToolbar!
    @IBOutlet weak var topText: UITextField!
    @IBOutlet weak var bottomText: UITextField!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var albumButton: UIBarButtonItem!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        enableCameraButton(cameraButton)
        memeTextFieldSetUp(topText, "Top")
        memeTextFieldSetUp(bottomText, "Bottom")
        shareButton.isEnabled = false
        navigationController?.isNavigationBarHidden = true
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.isNavigationBarHidden = true
        unsubscribeFromKeyboardNotifications()
    }
    
    //Checks if the device has a camera
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
        //adds the attributes created above
        textField.defaultTextAttributes = memeTextAttributes
        //centers the text
        textField.textAlignment = .center
        //adds the textInput String as the text for the textfield
        textField.text = textInput
        //makes the background clear/transparent
        textField.backgroundColor = UIColor.clear
    }
    
    
    
     @IBAction func pickAnImage(_ sender: UIBarButtonItem) {
        //creates the image picker controller
        let imagePicker = UIImagePickerController()
        //sets the source type; Camera button has a tag of 1 & Album button a tag of 2
        if sender.tag == 1 {
            imagePicker.sourceType = .camera
        } else if sender.tag == 2 {
            imagePicker.sourceType = .photoLibrary
        }
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
    }

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
        dismiss(animated: true, completion: nil)
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
    
    //sets the view back to its orginal place
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
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    //removes observers associated with the keyboard
    func unsubscribeFromKeyboardNotifications() {

        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    func save(_ memedImage: UIImage) {
        //Create the meme
        let image = memedImage
        // save the meme image in a meme struct
        let meme = MeMe(topText: topText.text!, bottomText: bottomText.text!, image: self.image.image!, meme: image)
        //Meme object can be saved to an array, core data
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        appDelegate.memes.append(meme)
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
    
    @IBAction func shareMeme(_ sender: Any) {
        //creates the meme Image
        let meme = generateMemedImage()
        //sets up activity view controller with the generated meme as an item
        let controller = UIActivityViewController(activityItems: [meme], applicationActivities: nil)
        //adds a completion handler to the controller
        controller.completionWithItemsHandler = { (type, completed, items, error) in
            //if controller was completed successfully, the save() is called
            if completed {
                self.save(meme)
                self.dismiss(animated: true, completion: nil)
            }
        }
        present(controller, animated: true, completion: nil)
    }
    
    
    
    @IBAction func cancelButtonAction(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    
    
    
    
}

