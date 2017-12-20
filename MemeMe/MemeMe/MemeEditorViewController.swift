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
    @IBOutlet weak var buttonShare: UIBarButtonItem!
    @IBOutlet weak var buttonCancel: UIBarButtonItem!
    @IBOutlet weak var buttonCamera: UIBarButtonItem!
    @IBOutlet weak var buttonAlbum: UIBarButtonItem!
    
    // Meme Editor Controls
    @IBOutlet weak var textfieldUp: UITextField!
    @IBOutlet weak var texfieldBottom: UITextField!
    @IBOutlet weak var imageViewMeme: UIImageView!
    
    // IBActions
    @IBAction func onTapShare(_ sender: UIBarButtonItem) {
    }
    
    @IBAction func onTapCancel(_ sender: UIBarButtonItem) {
    }
    
    @IBAction func onTapCamera(_ sender: UIBarButtonItem) {
    }
    
    @IBAction func onTapAlbum(_ sender: UIBarButtonItem) {
    }
}
