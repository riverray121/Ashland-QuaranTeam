//
//  UploadBankDetailsViewController.swift
//  Ashland QuaranTeam
//
//  Created by Elijah Retzlaff on 5/7/20.
//  Copyright © 2020 Ashland QuaranTeam. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth
import Firebase
import FirebaseFirestore
import FirebaseStorage
import Stripe
import FirebaseFunctions

class UploadBankDetailsViewController: UIViewController {

    @IBOutlet var doneButton: UIButton!
    @IBOutlet var uploadToStripeButton: UIButton!
    @IBOutlet var accountHolderTextField: UITextField!
    @IBOutlet var routingNumberTextFeild: UITextField!
    @IBOutlet var accountNumberTextField: UITextField!
    @IBOutlet var errorLabel: UILabel!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpDoneButton()
        setUpElements()
        // Do any additional setup after loading the view.
    }
    
    
    func setUpDoneButton () {
        
        self.accountHolderTextField.addDoneButton(title: "Done", target: self, selector: #selector(tapDone(sender:)))
        
        self.routingNumberTextFeild.addDoneButton(title: "Done", target: self, selector: #selector(tapDone(sender:)))
        
        self.accountNumberTextField.addDoneButton(title: "Done", target: self, selector: #selector(tapDone(sender:)))
        
    }
    
    @objc func tapDone(sender: Any) {
        self.view.endEditing(true)
    }
    
    //error message dislplaying fucntion
    func showError(_ message:String) {
        
        errorLabel.text = message
        errorLabel.alpha = 1
        
    }
    
    //set up elements
    func setUpElements () {
        
        //makes error label invisable
        errorLabel.alpha = 0
        
        //buttons
        Utilities.styleHollowButton(doneButton)
        
    }
    
    //Check the fields and ensure that the data entered is correct
    //If all is correct return nil, otherwise return error message
    func validateFields() -> String? {
        
        //check to make sure all fields are filled in
        if accountHolderTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || routingNumberTextFeild.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            accountNumberTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            
            return "Please fill in all feilds"
        }
        
        return nil
    }
    

    
    @IBAction func uploadToStripePushed(_ sender: Any) {
        
        let error = validateFields()
        
        if error == nil {
            
            self.activityIndicator.startAnimating()
            
            let accHolderName = accountHolderTextField.text
            let routingNum = routingNumberTextFeild.text
            let accNum = accountNumberTextField.text
            
            //get stripe id
            guard let uid = Auth.auth().currentUser?.uid else {
                self.showError("Error: Could not load account, please check internet connection")
                self.activityIndicator.stopAnimating()
            return
            }
            let db = Firestore.firestore()
            let ref = db.collection("Businesses").document(uid)
            var stripeID:String = ""
            
            ref.getDocument { (snapshot, err) in
                    if let err = err {
                        self.showError("Error getting documents: \(err)")
                        print("Error getting documents: \(err)")
                        self.activityIndicator.stopAnimating()
                        return
                    } else {
                        stripeID = (snapshot?.get("stripeID") as? String)!
                        
                        let stripeId = stripeID
                         
                        //store data key creation needs
                        let data = [
                            "business_id": stripeId,
                            "account_holder_name": accHolderName,
                            "routingNumber": routingNum,
                            "account_number": accNum
                        ]
                        
                        
                        Functions.functions().httpsCallable("createBankAccount").call(data) { (result, error) in
                            
                            if let error = error {
                                print(error)
                                
                                //inform user of the error
                                self.showError("Error: Could not open Stripe")
                                self.activityIndicator.stopAnimating()
                                
                                return
                            }
                            
                            guard let token = result?.data as? [String: Any] else {
                                
                                self.showError("Internal error")
                                print("failed")
                                self.activityIndicator.stopAnimating()
                                return
                            }
                            
                            print(token)
                            
                            let dataB = [
                                "business_id": stripeId,
                                "token": token["id"]
                            ]
                            
                            Functions.functions().httpsCallable("connectBankAccout").call(dataB) { (result, error) in
                                
                                if let error = error {
                                    print(error)
                                    
                                    //inform user of the error
                                    self.showError("Error: Could not open Stripe")
                                    self.activityIndicator.stopAnimating()
                                    
                                    return
                                }
                                
                                let alertController = UIAlertController(title: "Uploaded Data", message: "Uploaded to Stripe, please wait for verification", preferredStyle: .alert)
                                
                                let action = UIAlertAction(title: "OK", style: .default) { (action) in
                                   
                                    self.accountNumberTextField.text = ""
                                    self.routingNumberTextFeild.text = ""
                                    self.accountHolderTextField.text = ""
                                    
                                }
                                
                                alertController.addAction(action)
                                self.present(alertController, animated: true)
                                
                                
                                guard let bankAccount = result?.data as? [String: Any] else {
                                    
                                    print("failed")
                                    return
                                }
                                
                                print(bankAccount)
                                self.activityIndicator.stopAnimating()
                                
                                                              
                            }
                            
                                                          
                        }
                        
                        
                    }
            }
            
            
        } else {
            
            self.showError(error!)
            
        }
        
    }
    
    @IBAction func doneButtonPressed(_ sender: Any) {
        
        performSegue(withIdentifier: "backToBringAccOnline", sender: nil)

    }
    
}
