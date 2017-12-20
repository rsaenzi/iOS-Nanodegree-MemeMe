//
//  MemeEditorViewController.swift
//  MemeMe
//
//  Created by Rigoberto Sáenz Imbacuán on 12/19/17.
//  Copyright © 2017 Rigoberto Sáenz Imbacuán. All rights reserved.
//

import UIKit

class MemeEditorViewController: UIViewController {
    
    // Toolbars
    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var toolBar: UIToolbar!
    @IBOutlet weak var systemBar: UIView!
    
    // Toolbar buttons
    @IBOutlet weak var buttonCamera: UIBarButtonItem!
    @IBOutlet weak var buttonAlbum: UIBarButtonItem!
    @IBOutlet weak var buttonShare: UIBarButtonItem!
    @IBOutlet weak var buttonCancel: UIBarButtonItem!
    
    // Meme Editor Controls
    @IBOutlet weak var textfieldTop: UITextField!
    @IBOutlet weak var textfieldBottom: UITextField!
    @IBOutlet weak var imageViewMeme: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Init UI State
        setInitUIState()
        load(image: nil)
        
        // Sets the delegate of the textfields
        textfieldTop.delegate = self
        textfieldBottom.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        subscribeToKeyboardEvents()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeToKeyboardEvents()
    }
    
    // IBActions
    @IBAction func onTapCamera(_ sender: UIBarButtonItem) {
        getImage(from: .camera)
    }
    
    @IBAction func onTapAlbum(_ sender: UIBarButtonItem) {
        getImage(from: .photoLibrary)
    }
    
    @IBAction func onTapShare(_ sender: UIBarButtonItem) {
        shareMeme()
    }
    
    @IBAction func onTapCancel(_ sender: UIBarButtonItem) {
        load(image: nil)
    }
    
    private func getImage(from source: UIImagePickerControllerSourceType) {
        
        // To check if device has a camera or a photo library to read the image from
        if UIImagePickerController.isSourceTypeAvailable(source) {
        
            // Creates the camer/image picker
            let picker = UIImagePickerController()
            picker.delegate = self
            picker.allowsEditing = false
            picker.sourceType = source
            
            // Shows the picker
            present(picker, animated: true)
        }
    }
    
    private func setInitUIState() {
        
        // Set the font properties
        let style = NSMutableParagraphStyle()
        style.alignment = .center
        
        let fontAttributes: [String: Any] = [
            NSAttributedStringKey.strokeColor.rawValue: UIColor.white,
            NSAttributedStringKey.foregroundColor.rawValue: UIColor.black,
            NSAttributedStringKey.strokeWidth.rawValue: 4,
            NSAttributedStringKey.paragraphStyle.rawValue: style,
        ]
        textfieldTop.defaultTextAttributes = fontAttributes
        textfieldBottom.defaultTextAttributes = fontAttributes
        
        // Checks if device has camera/library capabilities
        buttonCamera.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        buttonAlbum.isEnabled = UIImagePickerController.isSourceTypeAvailable(.photoLibrary)
    }
    
    private func load(image: UIImage?) {
        
        if let image = image {
            
            // Shows the selected image
            imageViewMeme.image = image
            
            // Set the right UI state
            buttonShare.isEnabled = true
            buttonCancel.isEnabled = true
            
            textfieldTop.isEnabled = true
            textfieldBottom.isEnabled = true
            
        } else {
            
            // Clear the image
            imageViewMeme.image = nil
            
            // Disable the button and textfields
            buttonShare.isEnabled = false
            buttonCancel.isEnabled = false
            
            textfieldTop.isEnabled = false
            textfieldBottom.isEnabled = false
            
            textfieldTop.text = "TOP"
            textfieldBottom.text = "BOTTOM"
        }
    }
    
    private func shareMeme() {
        
        // Takes a screenshot of the screen
        let memeImage = generateMemedImage()
        
        // Creates the screen to share the meme
        let screen = UIActivityViewController(activityItems: [memeImage], applicationActivities: nil)
        
        // Function called when sharing is done or cancel
        screen.completionWithItemsHandler = { activityType, completed, returnedItems, activityError in
            
            // If sharing was successful
            if completed {
            
                // Create the meme model
                let meme = Meme(
                    textTop: self.textfieldTop.text!,
                    textBottom: self.textfieldBottom.text!,
                    imageOriginal: self.imageViewMeme.image!,
                    imageMeme: memeImage)
                
                // Shows a success alert
                let actionOk = UIAlertAction(title: "OK", style: .default)
                let alert = UIAlertController(title: "Meme Sharing", message: "Your meme was shared successfully!", preferredStyle: .alert)
                alert.addAction(actionOk)
                self.present(alert, animated: true)
            }
        }
        
        present(screen, animated: true)
    }
    
    private func generateMemedImage() -> UIImage {
        
        // Hide toolbar and navbar
        navBar.isHidden = true
        toolBar.isHidden = true
        systemBar.isHidden = true
        
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)

        let memedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()

        // Show toolbar and navbar
        navBar.isHidden = false
        toolBar.isHidden = false
        systemBar.isHidden = false
        
        return memedImage
    }

    private func subscribeToKeyboardEvents() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    private func unsubscribeToKeyboardEvents() {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if textfieldBottom.isFirstResponder {
            self.view.frame.origin.y -= getKeyboardHeight(notification)
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        self.view.frame.origin.y = 0
    }
    
    private func getKeyboardHeight(_ notification: NSNotification) -> CGFloat {
        guard let userInfo = notification.userInfo else {
            return 0
        }
        guard let keyboardSize = userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue else {
            return 0
        }
        return keyboardSize.cgRectValue.height
    }
}

extension MemeEditorViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        // Get the selected image
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            load(image: image)
        }
        
        // Close the image picker
        picker.dismiss(animated: true)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        // Close the image picker
        picker.dismiss(animated: true)
    }
}

extension MemeEditorViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textfieldTop.resignFirstResponder()
        textfieldBottom.resignFirstResponder()
        return true
    }
}
