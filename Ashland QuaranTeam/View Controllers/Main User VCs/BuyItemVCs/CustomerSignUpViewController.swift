//
//  CustomerSignUpViewController.swift
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

class CustomerSignUpViewController: UIViewController {

    @IBOutlet var firstNameTextField: UITextField!
    
    @IBOutlet var lastNameTextField: UITextField!
    
    @IBOutlet var emailTextField: UITextField!
    
    @IBOutlet var passwordTextField: UITextField!
    
    @IBOutlet var signUpButton: UIButton!
    
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
    

    func setUpDoneButton () {
        
        self.passwordTextField.addDoneButton(title: "Done", target: self, selector: #selector(tapDone(sender:)))
        
        self.emailTextField.addDoneButton(title: "Done", target: self, selector: #selector(tapDone(sender:)))
        
        self.firstNameTextField.addDoneButton(title: "Done", target: self, selector: #selector(tapDone(sender:)))
        
        self.lastNameTextField.addDoneButton(title: "Done", target: self, selector: #selector(tapDone(sender:)))
        
    }
    
    @objc func tapDone(sender: Any) {
        self.view.endEditing(true)
    }
    
    
    
    
    func setUpElements () {
        
        //makes error label invisable
        errorLabel.alpha = 0
        
        //this is from the Helpers/Utilities code
        //helps load visual elements
        Utilities.styleTextField(firstNameTextField)
        Utilities.styleTextField(lastNameTextField)
        Utilities.styleTextField(emailTextField)
        Utilities.styleTextField(passwordTextField)
        Utilities.styleFilledButton(signUpButton)
        Utilities.styleHollowButton(backButton)
        
    }
    
    
    
    //Check the fields and ensure that the data entered is correct
    //If all is correct return nil, otherwise return error message
    func validateFields() -> String? {
        
        //check to make sure all fields are filled in
        if firstNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || lastNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""  {
            
            return "Please fill in all feilds"
        }
        
        
        let cleanedPassword = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        //check if the password is secure
        //****THIS IS FROM THE UTILITIES FILE******/////
        if Utilities.isPasswordValid(cleanedPassword) == false {
            
            //password is not secure enough
            return "Please make sure your passowrd is at least 8 charecters, contains a special charecter, and a number."
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
    
    
    //function for when the sign up button ha been pressed
    @IBAction func signUpTapped(_ sender: Any) {
        
        //validate the fields
        let error = validateFields()
        
        if error != nil {
            
            //there is something wrong with the fields, show error message
            showError(error!)
            
        } else {
            
            //create cleaned versions of data (stripped of whitespace)
            let firstname = firstNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let lastname = lastNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
            
            //create the user
            Auth.auth().createUser(withEmail: email, password: password) { (result, err) in
                
                //check for errors
                if err != nil {
                    
                    //there was an error
                    self.showError("Error creating user, if you have a business account, you will need to use a new email for your customer account")
                    
                } else {
                    
                    //user created successfully, store their info
                    let db = Firestore.firestore()
                    
                    //create customer
                    db.collection("Customers").document(result!.user.uid).setData(["Customer":"\(firstname) \(lastname)", "uid":result!.user.uid, "email":email, "stripeID": ""]) { (error) in
                        
                        if error != nil {
                            
                            //show error
                            self.showError("Error saving user data")
                        }
                    }
                    
                    //create user
                    db.collection("users").document(result!.user.uid).setData(["firstname":firstname, "lastname":lastname, "password":password,  "uid":result!.user.uid, "is customer":"yes"]) { (error) in
                        
                        if error != nil {
                            
                            //show error
                            self.showError("Error saving user data")
                        }
                    }
                    
                    
                
                    //transition to the home screen
                    self.transitionToCheckout()
                    
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
        
        performSegue(withIdentifier: "backToCustomTransFromSignUp", sender: nil)

    }
    
    

}
