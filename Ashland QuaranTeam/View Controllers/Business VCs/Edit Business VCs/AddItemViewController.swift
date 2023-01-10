//
//  AddItemViewController.swift
//  Ashland QuaranTeam
//
//  Created by Elijah Retzlaff on 4/20/20.
//  Copyright © 2020 Ashland QuaranTeam. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth
import Firebase
import FirebaseFirestore
import FirebaseStorage

class AddItemViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet var addItemButton: UIButton!
    
    @IBOutlet var uploadImageOneButton: UIButton!
    
    @IBOutlet var uploadImageTwoButton: UIButton!
    
    @IBOutlet var uploadImageThreeButton: UIButton!
    
    @IBOutlet var priceTextField: UITextField!
    
    @IBOutlet var quantityAvailibleTextField: UITextField!
    
    @IBOutlet var descriptionTextField: UITextField!
    
    @IBOutlet var errorLabel: UILabel!
    
    @IBOutlet var itemImageView: UIImageView!
    
    @IBOutlet var cancelButton: UIButton!
    
    
    var item:String = ""
    var currImageNum = String()
    
    var imagePicker:UIImagePickerController!

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpDoneButton()
        setUpElements()
        
        imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self

        // Do any additional setup after loading the view.
    }
    
    func setUpDoneButton () {
        
        self.descriptionTextField.addDoneButton(title: "Done", target: self, selector: #selector(tapDone(sender:)))
        
        self.priceTextField.addDoneButton(title: "Done", target: self, selector: #selector(tapDone(sender:)))
        
        self.quantityAvailibleTextField.addDoneButton(title: "Done", target: self, selector: #selector(tapDone(sender:)))
        
    }
    
    @objc func tapDone(sender: Any) {
        self.view.endEditing(true)
    }
    
    
    //set up elements
    func setUpElements () {
        
        //makes error label invisable
        errorLabel.alpha = 0
        
        //buttons
        Utilities.styleHollowButton(addItemButton)
        
    }
    
    //error message dislplaying fucntion
    func showError(_ message:String) {
        
        errorLabel.text = message
        errorLabel.alpha = 1
        
    }
    
    
    
    
    
    //image picker
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let pickedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            self.itemImageView.image = pickedImage
        }
        
        picker.dismiss(animated: true, completion: nil)
        
        let itemImageNum = self.currImageNum
        
        guard let image = itemImageView.image else {return}
        
        self.uploadItemImage(image, itemImageNum: itemImageNum) { (url) in
            
            if url != nil {
                
                self.saveItemImage(itemImageURL: url!, itemImageNum: itemImageNum) { success in
    
                }
                
            } else {
                
                self.showError("Unable to upload photo")
            }
            
        }
        
    }
    
    
    
    
    
    //upload image
    func uploadItemImage(_ image:UIImage, itemImageNum: String,  completion: @escaping ((_ url:URL?)->())) {
        
        guard let uid = Auth.auth().currentUser?.uid else {return}
        let currItem = self.item
        let storageRef = Storage.storage().reference().child("Items/\(uid)\(currItem)\(itemImageNum)")
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
    
    
    
    
    func saveItemImage(itemImageURL:URL, itemImageNum: String, completion: @escaping ((_ success:Bool)->())) {
        
        guard let uid = Auth.auth().currentUser?.uid else {return}
        
        let currItem = self.item
        
        let userObject = ["photo url \(itemImageNum)":itemImageURL.absoluteString] as [String:Any]
        
        //store the url in firestore
        let db = Firestore.firestore()
        
        db.collection("Products").document("\(uid)\(currItem)").setData(userObject, merge: true) { (error) in
            
            if error != nil {
                self.showError("Error saving photo url")
            }
            
        }
        
        
    }
    
    
    
    
    @IBAction func uploadImageOnePressed(_ sender: Any) {
        
        currImageNum = "ONE"
        
        self.present(imagePicker, animated: true, completion: nil)
        
    }
    
    @IBAction func uploadImageTwoPressed(_ sender: Any) {
        
        currImageNum = "TWO"
        
        self.present(imagePicker, animated: true, completion: nil)
        
    }
    
    @IBAction func uploadImageThreePressed(_ sender: Any) {
        
        currImageNum = "THREE"
        
        self.present(imagePicker, animated: true, completion: nil)
        
    }
    
    
    
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        
        guard let uid = Auth.auth().currentUser?.uid else {return}
        
        let currItem = self.item
        
        //delete photos from storage if they have been stored
        let storageRefOne = Storage.storage().reference().child("Items/\(uid)\(currItem)ONE")
        storageRefOne.delete { (error) in
            
            if error != nil {
                print("Unable to delete photo one from storage")
            }
            
        }
        
        let storageRefTwo = Storage.storage().reference().child("Items/\(uid)\(currItem)TWO")
        storageRefTwo.delete { (error) in
            
            if error != nil {
                print("Unable to delete photo two from storage")
            }
            
        }
        
        let storageRefThree = Storage.storage().reference().child("Items/\(uid)\(currItem)THREE")
        storageRefThree.delete { (error) in
            
            if error != nil {
                print("Unable to delete photo three from storage")
            }
            
        }
        
        //delete item
        let db = Firestore.firestore()
        
        db.collection("Products").document("\(uid)\(currItem)").delete { (error) in
            
            if error != nil {
                
                print("Error deleting item")
            }
        }
        
        performSegue(withIdentifier: "backToBusinissEditHome", sender: nil)
        
        
    }
    
    
    @IBAction func addItemPressed(_ sender: Any) {
        
        if priceTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || quantityAvailibleTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || descriptionTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            
            self.showError("Please fill in all fields")
            return
            
        }
        
        guard Double(priceTextField.text!) != nil else {
            
            self.showError("Please enter price as a decimal number")
            return
        }
        
        if quantityAvailibleTextField.text! != "NA" {
            
            guard Int(quantityAvailibleTextField.text!) != nil else {
                
                self.showError("Please enter quantity availible as a whole number, or NA")
                return
            }
            
        }
        
        
        guard let uid = Auth.auth().currentUser?.uid else {return}
        
        let itemSpecified = item
        let price = priceTextField.text!
        let quantity = quantityAvailibleTextField.text!
        let description = descriptionTextField.text!
        
        let db = Firestore.firestore()
        
        
        db.collection("Products").document("\(uid)\(itemSpecified)").setData(["Price": price, "Quantity": quantity, "Description": description], merge: true, completion: { (error) in
            
            if error != nil {
                self.showError("Error product upload failed")
            }
            
        })
        
        performSegue(withIdentifier: "backToBusinissEditHome", sender: nil)

    }
    
}
