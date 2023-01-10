//
//  AddItemNameViewController.swift
//  Ashland QuaranTeam
//
//  Created by Elijah Retzlaff on 4/23/20.
//  Copyright © 2020 Ashland QuaranTeam. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth
import Firebase
import FirebaseFirestore
import FirebaseStorage

class AddItemNameViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    
    @IBOutlet var backButton: UIButton!
    
    @IBOutlet var createItemButton: UIButton!
    
    @IBOutlet var errorLabel: UILabel!
    
    @IBOutlet var itemNameTextField: UITextField!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpDoneButton()
        setUpElements()
        
        
        // Do any additional setup after loading the view.
    }
    
    func setUpDoneButton () {
        
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
        Utilities.styleHollowButtonSmall(backButton)
        Utilities.styleHollowButton(createItemButton)
        
    }
    
    //error message dislplaying fucntion
    func showError(_ message:String) {
        
        errorLabel.text = message
        errorLabel.alpha = 1
        
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        
        if segue.destination is AddItemViewController {
            
            // Create a reference to the cities collection
            let vc = segue.destination as? AddItemViewController
            
            vc?.item = self.itemNameTextField.text!
            
        }
        
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        
        performSegue(withIdentifier: "backToEditProf", sender: nil)

    }
    
    @IBAction func createItemButtonPressed(_ sender: Any) {
        
        if itemNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            
            self.showError("Please fill in field")
            return
            
        }
        
        guard let uid = Auth.auth().currentUser?.uid else {return}
        
        let newItem = itemNameTextField.text!
        
        let db = Firestore.firestore()
        
        db.collection("Products").document("\(uid)\(newItem)").setData(["Product": newItem, "owner uid": uid], completion: { (error) in
            
            
            if error != nil {
                self.showError("Error description upload failed")
            }
            
        })
        
        
        performSegue(withIdentifier: "transitionToItemCreate", sender: nil)
        
    }
    
    
    
}
