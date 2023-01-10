//
//  BringAccountOnlineViewController.swift
//  Ashland QuaranTeam
//
//  Created by Elijah Retzlaff on 5/6/20.
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

class BringAccountOnlineViewController: UIViewController {

    @IBOutlet var backButton: UIButton!
    @IBOutlet var setupStripeButton: UIButton!
    @IBOutlet var errorLabel: UILabel!
    @IBOutlet var uploadBankAccButton: UIButton!
    @IBOutlet var refreshButton: UIButton!
    @IBOutlet var verificationStatusLabel: UILabel!
    @IBOutlet var bankAccStatus: UILabel!
    @IBOutlet var stripeAccStatus: UILabel!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    @IBOutlet var bringAppAccOnline: UIButton!
    
    var canBringOnline: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpStatus()
        setUpElements()
        // Do any additional setup after loading the view.
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
        Utilities.styleHollowButtonSmall(backButton)
        Utilities.styleHollowButtonSmall(setupStripeButton)
        Utilities.styleHollowButtonSmall(uploadBankAccButton)
        Utilities.styleHollowButtonSmall(refreshButton)
        Utilities.styleHollowButtonSmall(bringAppAccOnline)
        
    }
    
    func setUpStatus() {
        
        activityIndicator.startAnimating()
        
        //Import user data
        let db = Firestore.firestore()
        guard let uid = Auth.auth().currentUser?.uid else {return}
        let nameRef = db.collection("Businesses").document(uid)
               
        nameRef.getDocument { (snapshot, error) in
            if error == nil {
                
                //IMPORT TEXT INFO
                guard let stripeId = snapshot?.get("stripeID") as? String else {return}
                                
                let data = [
                    "business_id": stripeId,
                ]
                
                //print(stripeId)
                
                Functions.functions().httpsCallable("retrieveAccount").call(data) { (result, error) in
                    
                    if let error = error {
                        print(error)
                        
                        //inform user of the error
                        self.showError("Error: Could not open Stripe")
                        self.activityIndicator.stopAnimating()
                        
                        return
                    }
                    
                    guard let businessAccount = result?.data as? [String: Any] else {
                        
                        print("failed")
                        return
                    }
                    
                    print(businessAccount)
                    self.activityIndicator.stopAnimating()
                    
                    let bankAccStatus = businessAccount["payouts_enabled"] as! Int
                    let chargesEnabled = businessAccount["charges_enabled"] as! Int
                    
                    
                    if bankAccStatus == 1 {
                        self.bankAccStatus.text = "Verified"
                        self.bankAccStatus.textColor = UIColor.green
                    } else {
                        self.bankAccStatus.text = "Innactive"
                        self.bankAccStatus.textColor = UIColor.red
                    }
                    
                    if chargesEnabled == 1 {
                        self.verificationStatusLabel.text = "Verified"
                        self.verificationStatusLabel.textColor = UIColor.green
                    } else {
                        self.verificationStatusLabel.text = "Inncomplete"
                        self.verificationStatusLabel.textColor = UIColor.red
                    }
                    
                    if chargesEnabled == 1 && bankAccStatus == 1 {
                        self.stripeAccStatus.text = "Verified"
                        self.stripeAccStatus.textColor = UIColor.green
                        self.canBringOnline = "t"
                    } else {
                        self.stripeAccStatus.text = "Offline"
                        self.stripeAccStatus.textColor = UIColor.red
                    }
                    
                                                  
                }
                
            } else {
                self.showError("Error connecting to database, please check internet connection")
            }
            
        }

    }
    
    @IBAction func setupStripeButtonPushed(_ sender: Any) {
        
        activityIndicator.startAnimating()
        
        //get stripe id
        guard let uid = Auth.auth().currentUser?.uid else {
            self.showError("Error: Could not load account, please check internet connection")
        return
        }
        let db = Firestore.firestore()
        let ref = db.collection("Businesses").document(uid)
        var stripeID:String = ""
        
        ref.getDocument { (snapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                    return
                } else {
                    stripeID = (snapshot?.get("stripeID") as? String)!
                    
                    let stripeId = stripeID
                     
                    //store data key creation needs
                    let data = [
                        "business_id": stripeId
                    ]
                    
                    
                    Functions.functions().httpsCallable("createAccountLink").call(data) { (result, error) in
                        
                        if let error = error {
                            print(error)
                            
                            ///////////////////////////////inform user of the error
                            self.showError("Error: Could not open Stripe")
                            
                            return
                        }
                        
                        guard let url = result?.data as? [String: Any] else {
                            
                            print("failed")
                            return
                        }
                        
                        print(url)
                        
                        self.activityIndicator.stopAnimating()
                        
                        UIApplication.shared.open(URL(string: url["url"] as! String)! as URL, options: [ : ], completionHandler: nil)
                                                      
                    }
                    
                    
                }
        }
        
        
    }
    
    @IBAction func bringAppAccOnlinePushed(_ sender: Any) {
                
        if canBringOnline == "t" {
            
            let alertController = UIAlertController(title: "Bring account online", message: "Are you sure you are ready to allow customers to view your business?", preferredStyle: .alert)
            
            let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            }
            
            let action = UIAlertAction(title: "Yes", style: .default) { (action) in
                
                //get stripe id
                guard let uid = Auth.auth().currentUser?.uid else {
                    self.showError("Error: Could not load account, please check internet connection")
                return
                }
                
                //user created successfully, store their info
                let db = Firestore.firestore()
                
                //create business
                db.collection("Businesses").document(uid).setData(["online": "yes"], merge: true) { (error) in
                    
                    if error != nil {
                        
                        //show error
                        self.showError("Error saving user data")
                    } else {
                        self.performSegue(withIdentifier: "backToBusinessHome", sender: nil)
                    }
                    
                }
            }
            
            alertController.addAction(cancel)
            alertController.addAction(action)
            self.present(alertController, animated: true)
            
        } else {
            
            let alertController = UIAlertController(title: "Could not bring online", message: "Your stripe account must be verrified and bank account must be added first. If you have completed these, refresh and then try again.", preferredStyle: .alert)
            
            let action = UIAlertAction(title: "OK", style: .default) { (action) in
                
            }
            
            alertController.addAction(action)
            self.present(alertController, animated: true)
            
        }
        
    }
    
    @IBAction func uploadBankAccPushed(_ sender: Any) {
    
        performSegue(withIdentifier: "showUploadBank", sender: nil)
        
    }
    
    @IBAction func backButtonPushed(_ sender: Any) {
        
        performSegue(withIdentifier: "backToBusinessHome", sender: nil)

    }
    
    @IBAction func refreshButtonPressed(_ sender: Any) {
        
        setUpStatus()
        
    }
    
}
