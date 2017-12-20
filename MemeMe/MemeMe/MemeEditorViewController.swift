//
//  MemeEditorViewController.swift
//  MemeMe
//
//  Created by Rigoberto Sáenz Imbacuán on 12/19/17.
//  Copyright © 2017 Rigoberto Sáenz Imbacuán. All rights reserved.
//

import UIKit

class MemeEditorViewController: UIViewController {
    
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
        setInitUIState()
    }
    
    // IBActions
    @IBAction func onTapCamera(_ sender: UIBarButtonItem) {
        getImage(from: .camera)
    }
    
    @IBAction func onTapAlbum(_ sender: UIBarButtonItem) {
        getImage(from: .photoLibrary)
    }
    
    @IBAction func onTapShare(_ sender: UIBarButtonItem) {
    }
    
    @IBAction func onTapCancel(_ sender: UIBarButtonItem) {
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
        buttonShare.isEnabled = false
        buttonCancel.isEnabled = false
        textfieldTop.isEnabled = false
        textfieldBottom.isEnabled = false
    }
    
    private func load(image: UIImage) {
        
        // Shows the selected image
        imageViewMeme.image = image
        
        // Set the right UI state
        buttonShare.isEnabled = true
        buttonCancel.isEnabled = true
        textfieldTop.isEnabled = true
        textfieldBottom.isEnabled = true
    }
}

extension MemeEditorViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
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
