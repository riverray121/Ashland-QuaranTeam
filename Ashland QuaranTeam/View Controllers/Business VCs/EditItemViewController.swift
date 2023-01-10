//
//  EditItemViewController.swift
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

class EditItemViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet var errorLabel: UILabel!
    @IBOutlet var doneEditingButton: UIButton!
    @IBOutlet var descriptionTextField: UITextField!
    @IBOutlet var quantityTextField: UITextField!
    @IBOutlet var priceTextField: UITextField!
    @IBOutlet var itemNameTextField: UITextField!
    @IBOutlet var itemImageView: UIImageView!
    @IBOutlet var changeImageOneButton: UIButton!
    @IBOutlet var changeImageTwoButton: UIButton!
    @IBOutlet var changeImageThreeButton: UIButton!
    @IBOutlet var editDescriptionButton: UIButton!
    @IBOutlet var editQuantityButton: UIButton!
    @IBOutlet var editPriceButton: UIButton!
    @IBOutlet var editItemNameButton: UIButton!
    @IBOutlet var deleteItemButton: UIButton!
    @IBOutlet var previewItemButton: UIButton!
    
    
    var item:String = ""
    var currImageNum = String()
    
    var imagePicker:UIImagePickerController!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setUpDoneButton()
        
        setUpElements()
        
        imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        
    }
    
    //error message dislplaying fucntion
    func showError(_ message:String) {
        
        errorLabel.text = message
        errorLabel.alpha = 1
        
    }
    
    func setUpDoneButton () {
        
        self.descriptionTextField.addDoneButton(title: "Done", target: self, selector: #selector(tapDone(sender:)))
        
        self.quantityTextField.addDoneButton(title: "Done", target: self, selector: #selector(tapDone(sender:)))
        
        self.priceTextField.addDoneButton(title: "Done", target: self, selector: #selector(tapDone(sender:)))
        
        self.itemNameTextField.addDoneButton(title: "Done", target: self, selector: #selector(tapDone(sender:)))
        
    }
    
    @objc func tapDone(sender: Any) {
        self.view.endEditing(true)
    }
    
    
    //set up elements
    func setUpElements () {
        
        //makes error label invisable
        errorLabel.alpha = 0
        
        //buttons
        Utilities.styleHollowButtonSmall(doneEditingButton)
        Utilities.styleHollowButtonSmall(changeImageOneButton)
        Utilities.styleHollowButtonSmall(changeImageTwoButton)
        Utilities.styleHollowButtonSmall(changeImageThreeButton)

        Utilities.styleHollowButtonSmall(editDescriptionButton)
        Utilities.styleHollowButtonSmall(editPriceButton)
        Utilities.styleHollowButtonSmall(editItemNameButton)
        Utilities.styleHollowButtonSmall(deleteItemButton)
        Utilities.styleHollowButtonSmall(editQuantityButton)
        
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
    
    
    
    @IBAction func editDescriptionPushed(_ sender: Any) {
        
        if descriptionTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            
            self.showError("Please fill in field")
            return
            
        }
        
        guard let uid = Auth.auth().currentUser?.uid else {return}
        
        let userObject = ["Description":descriptionTextField.text!] as [String:Any]
        
        let db = Firestore.firestore()
        
        let currItem = self.item
        
        db.collection("Products").document("\(uid)\(currItem)").setData(userObject, merge: true) { (error) in
            
            if error != nil {
                self.showError("Error description upload failed")
            }
            
            self.descriptionTextField.text = ""
            
        }
        
    }
    
    
    @IBAction func editQuantityPushed(_ sender: Any) {
        
        if quantityTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            
            self.showError("Please fill in field")
            return
            
        }
        
        if quantityTextField.text! != "NA" {
            
            guard Int(quantityTextField.text!) != nil else {
                
                self.showError("Please enter quantity availible as a whole number, or NA")
                return
            }
            
        }
        
        guard let uid = Auth.auth().currentUser?.uid else {return}
               
        let userObject = ["Quantity":quantityTextField.text!] as [String:Any]
               
        let db = Firestore.firestore()
               
        let currItem = self.item
               
        db.collection("Products").document("\(uid)\(currItem)").setData(userObject, merge: true) { (error) in
                   
        if error != nil {
            self.showError("Error quantity upload failed")
        }
                   
            self.quantityTextField.text = ""
                   
        }
        
        
    }
    
    
    @IBAction func editPricePushed(_ sender: Any) {
        
        if priceTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            
            self.showError("Please fill in field")
            return
            
        }
        
        guard Double(priceTextField.text!) != nil else {
            
            self.showError("Please enter price as a decimal number")
            return
        }
        
        guard let uid = Auth.auth().currentUser?.uid else {return}
               
        let userObject = ["Price":priceTextField.text!] as [String:Any]
               
        let db = Firestore.firestore()
               
        let currItem = self.item
               
        db.collection("Products").document("\(uid)\(currItem)").setData(userObject, merge: true) { (error) in
                   
        if error != nil {
            self.showError("Error quantity upload failed")
        }
                   
            self.priceTextField.text = ""
                   
        }
        
    }
    
    
    @IBAction func editNamePushed(_ sender: Any) {
        
        if itemNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            
            self.showError("Please fill in field")
            return
            
        }
        
        guard let uid = Auth.auth().currentUser?.uid else {return}
                              
        let db = Firestore.firestore()
               
        let currItem = self.item
        
        let newItem = itemNameTextField.text!
        
        
        let nameRef = db.collection("Products").document("\(uid)\(currItem)")
               
        nameRef.getDocument { (snapshot, error) in
            if error == nil {
                
                //IMPORT TEXT INFO
                var descrip = ""
                var quant = ""
                var pri = ""
                var userUID = ""
                var urlone = ""
                var urltwo = ""
                var urlthree = ""
                
                
                if snapshot?.get("Description") as? String != nil { descrip = (snapshot?.get("Description") as? String)! } else { descrip = ""}
                if snapshot?.get("Quantity") as? String != nil { quant = (snapshot?.get("Quantity") as? String)! } else { quant = ""}
                if snapshot?.get("Price") as? String != nil { pri = (snapshot?.get("Price") as? String)! } else { pri = ""}
                if snapshot?.get("owner uid") as? String != nil { userUID = (snapshot?.get("owner uid") as? String)! } else {
                    self.showError("Error changing name")
                    return
                }
                if snapshot?.get("photo url ONE") as? String != nil { urlone = (snapshot?.get("photo url ONE") as? String)! } else { urlone = ""}
                if snapshot?.get("photo url TWO") as? String != nil { urltwo = (snapshot?.get("photo url TWO") as? String)! } else { urltwo = ""}
                if snapshot?.get("photo url THREE") as? String != nil { urlthree = (snapshot?.get("photo url THREE") as? String)! } else { urlthree = ""}

        
                let description = descrip
                let quantity = quant
                let price = pri
                let owner_uid = userUID
                let photoURLone = urlone
                let photoURLtwo = urltwo
                let photoURLthree = urlthree
                
                if photoURLone != "" {
                    db.collection("Products").document("\(uid)\(newItem)").setData(["photo url ONE": photoURLone]) { (error) in
                        if error != nil {
                            self.showError("error saving photo one")
                        }
                    }
                }
                
                if photoURLtwo != "" {
                    db.collection("Products").document("\(uid)\(newItem)").setData(["photo url TWO": photoURLtwo]) { (error) in
                        if error != nil {
                            self.showError("error saving photo two")
                        }
                    }
                }
                
                if photoURLthree != "" {
                    db.collection("Products").document("\(uid)\(newItem)").setData(["photo url THREE": photoURLthree]) { (error) in
                        if error != nil {
                            self.showError("error saving photo two")
                        }
                    }
                }
                
                db.collection("Products").document("\(uid)\(newItem)").setData(["Product": newItem, "owner uid": owner_uid, "Description": description, "Quantity": quantity, "Price": price], completion: { (error) in
            
                    if error != nil {
                        self.showError("Error item name upload failed")
                    } else {
                        
                        //delete old item
                        db.collection("Products").document("\(uid)\(currItem)").delete { (error) in
                            
                            if error != nil {
                                
                                print("error deleting old item")
                            }
                            
                            
                        }
                        
                        self.item = newItem
                                       
                        self.itemNameTextField.text = ""
                        
                    }
            
                })
                
                
            }
            
        }
        
        
    }
    
    
    @IBAction func deleteItemPushed(_ sender: Any) {
        
        let dialogMessage = UIAlertController(title: "Confirm", message: "Are you sure you want to delete this item?", preferredStyle: .alert)
               
        // Create OK button with handler
        let ok = UIAlertAction(title: "Yes", style: .default, handler: { (action) -> Void in
            print("Ok button tapped")
            self.deleteRecord()
        })
               
        // Create Cancel button with handlder
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (action) -> Void in
            print("Cancel button tapped")
        }
               
        //Add OK and Cancel button to dialog message
        dialogMessage.addAction(ok)
        dialogMessage.addAction(cancel)
               
        // Present dialog message to user
        self.present(dialogMessage, animated: true, completion: nil)
        
    }
        
    func deleteRecord() {
        print("Deleting item now")
        
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
        
        performSegue(withIdentifier: "backToBusinessHomeFromEdit", sender: nil)
        
    }
        
    
    
    
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        
        if segue.destination is ItemPageViewController {
            
            // Create a reference to the cities collection
            let vc = segue.destination as? ItemPageViewController
            
            guard let uid = Auth.auth().currentUser?.uid else {return}
            let currItem = self.item
            var currBusiness = ""
            
            let db = Firestore.firestore()
            let nameRef = db.collection("Businesses").document(uid)
                   
            nameRef.getDocument { (snapshot, error) in
                if error == nil {
                    
                    //IMPORT TEXT INFO
                    currBusiness = (snapshot?.get("business") as? String)!
                } else {
                    
                    print("error getting business name")
                    return
                }
            }
            
            vc?.business = currBusiness
            vc?.businessUID = uid
            vc?.item = currItem
            vc?.cameFromBusiness = "y"
        
        }
        
    }
    
    
    @IBAction func previewItemButtonPushed(_ sender: Any) {
        
        
        performSegue(withIdentifier: "showItemPriview", sender: nil)
     
    }
    
    
    

}
