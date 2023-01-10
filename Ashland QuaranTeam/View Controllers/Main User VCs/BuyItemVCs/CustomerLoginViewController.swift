//
//  CustomerLoginViewController.swift
//  Ashland QuaranTeam
//
//  Created by Elijah Retzlaff on 4/30/20.
//  Copyright © 2020 Ashland QuaranTeam. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth
import Firebase
import FirebaseFirestore
import FirebaseStorage

class CustomerLoginViewController: UIViewController {

    @IBOutlet var emailTextField: UITextField!
    
    @IBOutlet var passwordTextField: UITextField!
    
    @IBOutlet var loginButton: UIButton!
    
    @IBOutlet var errorLabel: UILabel!
    
    @IBOutlet var backButton: UIButton!
    
    
    
    
    var business:String = ""
    var businessUID:String = ""
    var item:String = ""
    var price:String = ""
    var itemOwnerStripeID:String = ""


    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setUpDoneButton()
        setUpElements()
        
        
    }
    
    func setUpElements() {
        
        //make error label invisible
        errorLabel.alpha = 0
        
        //this is from the Helpers/Utilities code
        //helps style visual elements
        Utilities.styleTextField(emailTextField)
        Utilities.styleTextField(passwordTextField)
        Utilities.styleFilledButton(loginButton)
        Utilities.styleHollowButton(backButton)
        
        
    }
    
    func setUpDoneButton () {
        
        self.passwordTextField.addDoneButton(title: "Done", target: self, selector: #selector(tapDone(sender:)))
        
        self.emailTextField.addDoneButton(title: "Done", target: self, selector: #selector(tapDone(sender:)))
        
    }
    
    @objc func tapDone(sender: Any) {
        self.view.endEditing(true)
    }
    
    
    //Check the fields and ensure that the data entered is correct
    //If all is correct return nil, otherwise return error message
    func validateFields() -> String? {
        
        //check to make sure all fields are filled in
        if  emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            
            return "Please fill in all feilds"
        }
        
        return nil
    }
    
    //error message dislplaying fucntion
    func showError(_ message:String) {
        
        errorLabel.text = message
        errorLabel.alpha = 1
        
    }
    
    //function for moving user to the business home screen after and account has been created
    func transitionToCheckout() {
        
        let checkoutViewController = storyboard?.instantiateViewController(withIdentifier: "buyItemViewCont") as? BuyItemViewController
        
        // Create a reference to the cities collection
        checkoutViewController?.item = self.item
        checkoutViewController?.business = self.business
        checkoutViewController?.businessUID = self.businessUID
        checkoutViewController?.price = self.price
        checkoutViewController?.itemOwnerStripeID = self.itemOwnerStripeID


        
        view.window?.rootViewController = checkoutViewController
        view.window?.makeKeyAndVisible()
        
    }
    
    //function for when login button is tapped
    @IBAction func loginButtonTapped(_ sender: Any) {
        
        //validate the text fields
        let error = validateFields()
        
        if error != nil {
            
            //there is something wrong with the fields, show error message
            showError(error!)
            
        } else {
        
            //create claeaned versions of the text field
            let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
            //signing in the user
            Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
                
                if error != nil {
                    
                    //couldnt sign in
                    self.showError("Incorrect email or password, please try again")
                    
                } else {
                    
                    //check to see if this account is a business account, if so, dont let user sign in
                    guard let uid = Auth.auth().currentUser?.uid else {return}
                    // Create a reference to the cities collection
                    let db = Firestore.firestore()
                    
                    //Import user data
                    let nameRef = db.collection("users").document(uid)
                           
                    nameRef.getDocument { (snapshot, error) in
                        if error == nil {
                            
                            if snapshot?.get("is customer") as? String == "yes" {
                                
                                //let user login and checkout
                                //transition to the checkout screen
                                self.transitionToCheckout()
                                
                            } else {
                                
                                //dont let user access checkout
                                let firebaseAuth = Auth.auth()
                                do {
                                    
                                    try firebaseAuth.signOut()
                                    
                                } catch let signOutError as NSError {
                                    
                                    print ("Error signing out: %@", signOutError)
                                    return
                                    
                                }
                                
                                self.showError("This is a business account, please create a customer account to checkout")
                                
                            }

                            
                        } else {
                            
                            self.showError("Error user info")
                        }
                    }
                    
                    
                }
                
            }
        
            
            
            
        }
        
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        
        if segue.destination is CustomerTransitionViewController {
            
            // Create a reference to the cities collection
            let vcBI = segue.destination as? CustomerTransitionViewController
            
            vcBI?.item = self.item
            vcBI?.business = self.business
            vcBI?.businessUID = self.businessUID
            vcBI?.price = self.price
            vcBI?.itemOwnerStripeID = self.itemOwnerStripeID

            
        }
        
    }
    
    
    @IBAction func backButtonPressed(_ sender: Any) {
        
        performSegue(withIdentifier: "backToCustomerTransFromLogin", sender: nil)

    }

    

}
