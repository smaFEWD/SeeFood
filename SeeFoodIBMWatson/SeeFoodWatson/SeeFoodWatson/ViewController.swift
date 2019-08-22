//
//  ViewController.swift
//  SeeFoodWatson
//
//  Created by Sandi Ma on 8/20/19.
//  Copyright © 2019 Sandi Ma. All rights reserved.
//

import UIKit
import VisualRecognition //When importing the frameworks in source files, exclude the IBMWatson prefix and the version suffix per docs: https://github.com/watson-developer-cloud/swift-sdk
import SVProgressHUD

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    let apiKey = "S74apXkBpxxAAsdPA12PqFVSRBA_ytLgMtN18FLbMu4N"
    let version = "2019-08-21"
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    
    let imagePicker = UIImagePickerController()
    var classificationResults : [String] = []
    
    
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
            let visualRecognition = VisualRecognition(version: version, apiKey: apiKey)
            
            let imageData = image.jpegData(compressionQuality: 0.01)
            let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            
            let fileURL = documentsURL.appendingPathComponent("tempImage.jpg")
        
            try? imageData?.write(to: fileURL, options: [])
            
            visualRecognition.classify(imagesFilename: fileURL) {(classifiedImages) in
                let classes = classifiedImages.images.first!.classifiers.first!.classes
                self.classificationResults = []
                
                for index in 0..<classes.count {
                    self.classificationResults.append(classes[index].classification)
                }
                print(self.classificationResults)
                
                if self.classificationResults.contains("hotdog"){
                    DispatchQueue.main.async {
                        self.navigationItem.title = "It's a Hotdog!"
                    }
                    
                } else {
                    DispatchQueue.main.async {
                        self.navigationItem.title = "Not a Hotdog!"
                    }
                    
                }
            }
        
        } else {
            print("There was an error picking the image")
        }
        
    }

    @IBAction func cameraTapped(_ sender: UIBarButtonItem) {
        imagePicker.sourceType = .savedPhotosAlbum // allows us to test on the simulator
//        imagePicker.sourceType = .camera // allows us to test using our camera on our phone
        imagePicker.allowsEditing = false
        
        present(imagePicker, animated: true, completion: nil)
        
    }
}

