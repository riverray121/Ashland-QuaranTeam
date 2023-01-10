//
//  LoginViewController.swift
//  Ashland QuaranTeam
//
//  Created by Elijah Retzlaff on 4/16/20.
//  Copyright © 2020 Ashland QuaranTeam. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase
import FirebaseFirestore

class LoginViewController: UIViewController {
    
    
    @IBOutlet var emailTextField: UITextField!
    
    @IBOutlet var passwordTextField: UITextField!
    
    @IBOutlet var loginButton: UIButton!
    
    @IBOutlet var errorLabel: UILabel!
    
    @IBOutlet var backButton: UIButton!
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        setUpElements()
        
        setUpDoneButton()
        
        
    }
    
    
    func setUpDoneButton () {
        
        self.passwordTextField.addDoneButton(title: "Done", target: self, selector: #selector(tapDone(sender:)))
        
        self.emailTextField.addDoneButton(title: "Done", target: self, selector: #selector(tapDone(sender:)))
        
    }
    
    @objc func tapDone(sender: Any) {
        self.view.endEditing(true)
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
    func transitionToBusinessHome() {
        
        let businessHomeViewController = storyboard?.instantiateViewController(withIdentifier: Constants.Storyboard.businessHomeViewController) as? BusinessHomeViewController
        
        view.window?.rootViewController = businessHomeViewController
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
                            
                            if snapshot?.get("is customer") as? String == "no" {
                                
                                //let user login and checkout
                                //transition to the home screen
                                self.transitionToBusinessHome()
                                
                            } else {
                                
                                //dont let user access checkout
                                let firebaseAuth = Auth.auth()
                                do {
                                    
                                    try firebaseAuth.signOut()
                                    
                                } catch let signOutError as NSError {
                                    
                                    print ("Error signing out: %@", signOutError)
                                    return
                                    
                                }
                                
                                self.showError("This is a customer account, please create a seperate account for a business")
                                
                            }

                            
                        } else {
                            
                            self.showError("Error user info")
                        }
                    }
                    
                    
                    
                }
                
            }
        
            
            
            
        }
        
        
    }
    
    
    

}
