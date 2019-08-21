//
//  ViewController.swift
//  SeeFood
//
//  Created by Sandi Ma on 8/19/19.
//  Copyright © 2019 Sandi Ma. All rights reserved.
//

import UIKit
import CoreML
import Vision

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var imageView: UIImageView!
    
    let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        imagePicker.delegate = self
        imagePicker.sourceType = .camera // implementing camera functionality in app
        imagePicker.allowsEditing = false
        
    }
    // this tells the delegate that the user has picked an image or movie
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // this key will yield the image picked by the user
        if let userPickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imageView.image = userPickedImage
            
            // converting userimage to ci image
            guard let ciimage = CIImage(image: userPickedImage) else {
                fatalError("Could not convert to UIImage to CIImage")
    
            }
            detect(image: ciimage)
    }
        imagePicker.dismiss(animated: true, completion: nil)
        
    }
    // need to creat a method to process that CI image
    
    func detect(image: CIImage){
        //VNCoreModel (from the Vision Framework) is used as a container
        
        guard let model = try? VNCoreMLModel(for: Inceptionv3().model) else {
            fatalError("Loading COREML Model Failed.")
        }
        // if the above "model" doesn't come back as "nil" then this code below will run the below completion handler
        
        // after the model has been processed, VNClassificationObservation will hold the array items--and the array is of this type
        let request = VNCoreMLRequest(model: model){(request, error) in
            guard let results = request.results as? [VNClassificationObservation] else {
                fatalError("Model failed to process image." )
            }
//            print(results)
            if let firstResult = results.first {
                if firstResult.identifier.contains("hotdog") {
                    self.navigationItem.title = "Hotdog!"
                } else {
                    self.navigationItem.title = "Not a Hotdog!"
                }
            }
        }
        // performing the request with this handler
        let handler = VNImageRequestHandler(ciImage: image)
        do {
            try handler.perform([request])
        }
        catch {
            print(error)
        }
        
    }
    
    @IBAction func cameraTapped(_ sender: UIBarButtonItem) {
        present(imagePicker, animated: true, completion: nil)
    }
    
}

