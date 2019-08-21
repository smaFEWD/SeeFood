//
//  ViewController.swift
//  SeeFoodWatson
//
//  Created by Sandi Ma on 8/20/19.
//  Copyright © 2019 Sandi Ma. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    
    let imagePicker = UIImagePickerController()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        imagePicker.delegate = self
    }

    // the user has picked an image
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // send the picture to IBM BlueMix
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imageView.image = image
            // dismiss the image picker once it has picked an image
            imagePicker.dismiss(animated: true, completion: nil)
        } else {
            print("There was an error picking the image")
        }
        
    }

    @IBAction func cameraTapped(_ sender: UIBarButtonItem) {
//        imagePicker.sourceType = .savedPhotosAlbum // allows us to test on the simulator
        imagePicker.sourceType = .camera // allows us to test using our camera on our phone
        imagePicker.allowsEditing = false
        
        present(imagePicker, animated: true, completion: nil)
        
    }
}

