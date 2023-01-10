//
//  EditProfileViewController.swift
//  Ashland QuaranTeam
//
//  Created by Elijah Retzlaff on 4/19/20.
//  Copyright © 2020 Ashland QuaranTeam. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase
import FirebaseFirestore
import FirebaseStorage

class EditProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet var doneButton: UIButton!
    @IBOutlet var uploadPhoto: UIButton!
    @IBOutlet var editDescription: UIButton!
    @IBOutlet var editPhoneNumber: UIButton!
    @IBOutlet var editAdress: UIButton!
    @IBOutlet var addPayPal: UIButton!
    @IBOutlet var addNewItem: UIButton!
    @IBOutlet var businessImage: UIImageView!
    @IBOutlet var errorLable: UILabel!
    @IBOutlet var descriptionTextField: UITextField!
    @IBOutlet var phoneNumberTextField: UITextField!
    @IBOutlet var adressTextField: UITextField!
    @IBOutlet var editPickUp: UIButton!
    
    
    
    var imagePicker:UIImagePickerController!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        
        setUpDoneButton()
        setUpElements()
        
    }
    
    
    func setUpDoneButton () {
        
        self.descriptionTextField.addDoneButton(title: "Done", target: self, selector: #selector(tapDone(sender:)))
        
        self.phoneNumberTextField.addDoneButton(title: "Done", target: self, selector: #selector(tapDone(sender:)))
        
        self.adressTextField.addDoneButton(title: "Done", target: self, selector: #selector(tapDone(sender:)))
        
    }
    
    @objc func tapDone(sender: Any) {
        self.view.endEditing(true)
    }
    
    //set up elements
    func setUpElements () {
        
        //makes error label invisable
        errorLable.alpha = 0
        
        //buttons
        Utilities.styleHollowButtonSmall(doneButton)
        Utilities.styleHollowButtonSmall(uploadPhoto)
        Utilities.styleHollowButtonSmall(editAdress)
        Utilities.styleHollowButtonSmall(editPhoneNumber)
        Utilities.styleHollowButtonSmall(editDescription)
        Utilities.styleHollowButtonSmall(addPayPal)
        Utilities.styleHollowButtonSmall(addNewItem)
        Utilities.styleHollowButtonSmall(editPickUp)

        
    }
    
    //error message dislplaying fucntion
    func showError(_ message:String) {
        
        errorLable.text = message
        errorLable.alpha = 1
        
    }
    
    //image picker
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let pickedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            self.businessImage.image = pickedImage
        }
        
        picker.dismiss(animated: true, completion: nil)
        
        
        guard let image = businessImage.image else {return}
        
        self.uploadBusinessImage(image) { (url) in
            
            if url != nil {
                
                let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
                changeRequest?.photoURL = url
                
                self.saveBusinessImage(businessImageURL: url!) { success in
                    
                    
                }
                
            } else {
                
                self.showError("Unable to upload photo")
            }
            
        }
        
    }
    
    
    //upload image
    func uploadBusinessImage(_ image:UIImage, completion: @escaping ((_ url:URL?)->())) {
        
        guard let uid = Auth.auth().currentUser?.uid else {return}
        let storageRef = Storage.storage().reference().child("Businesses/\(uid)")
        guard let imageData = image.jpegData(compressionQuality: 0.75) else {return}
        
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpg"
        
        storageRef.putData(imageData, metadata: metaData) { (metaData, error) in
            
            if error == nil, metaData != nil {
                
                storageRef.downloadURL(completion: { (url, error) in
                    if error == nil {
                        
                        completion(url)
                        print("URL downloaded")
                        
                    } else {
                        print("Failed to fetch downloadURL")
                        completion(nil)
                        self.showError("Failed to fetch downloadURL")
                        return
                    }
                    
                })
                
                
            } else {
                completion(nil)
                print("upload failed")
                self.showError("Failed to upload photo")
            }
            
        }
        
    }
    
    
    
    
    func saveBusinessImage(businessImageURL:URL, completion: @escaping ((_ success:Bool)->())) {
        
        guard let uid = Auth.auth().currentUser?.uid else {return}
        
        let userObject = ["photo url":businessImageURL.absoluteString] as [String:Any]
        
        //store the url in firestore
        let db = Firestore.firestore()
        
        db.collection("Businesses").document(uid).setData(userObject, merge: true) { (error) in
            
            if error != nil {
                self.showError("Error saving photo url")
            }
            
        }
        
        
    }
    
    
    
    
    
    @IBAction func uploadButtonPress(_ sender: Any) {
        
        self.present(imagePicker, animated: true, completion: nil)
        
    }
    
    
    @IBAction func editDescriptionPressed(_ sender: Any) {
        
        if descriptionTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            
            self.showError("Please fill in field")
            return
            
        }
        
        guard let uid = Auth.auth().currentUser?.uid else {return}
        
        let userObject = ["Description":descriptionTextField.text!] as [String:Any]
        
        let db = Firestore.firestore()
        
        db.collection("Businesses").document(uid).setData(userObject, merge: true) { (error) in
            
            if error != nil {
                self.showError("Error description upload failed")
            }
            
            self.descriptionTextField.text = ""
            
        }
                    
    }
    
    

    @IBAction func editPhoneNumPressed(_ sender: Any) {
        
        if phoneNumberTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            
            self.showError("Please fill in field")
            return
            
        }
        
        guard let uid = Auth.auth().currentUser?.uid else {return}
        
        let userObject = ["Phone number":phoneNumberTextField.text!] as [String:Any]
        
        let db = Firestore.firestore()
        
        db.collection("Businesses").document(uid).setData(userObject, merge: true) { (error) in
            
            if error != nil {
                self.showError("Error address upload failed")
            }
            
            self.phoneNumberTextField.text = ""
            
        }

    }



    
    @IBAction func editAdressPressed(_ sender: Any) {
        
        if adressTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            
            self.showError("Please fill in feild")
            return
        }
        
        guard let uid = Auth.auth().currentUser?.uid else {return}
        
        let userObject = ["Address":adressTextField.text!] as [String:Any]
        
        //store the url in firestore
        let db = Firestore.firestore()
        
        db.collection("Businesses").document(uid).setData(userObject, merge: true) { (error) in
            
            if error != nil {
                self.showError("Error address upload failed")
            }
            
            self.adressTextField.text = ""
            
        }
        
        
    }


    
    
}
