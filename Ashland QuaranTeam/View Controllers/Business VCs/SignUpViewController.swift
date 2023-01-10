//
//  SignUpViewController.swift
//  Ashland QuaranTeam
//
//  Created by Elijah Retzlaff on 4/16/20.
//  Copyright © 2020 Ashland QuaranTeam. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase
import FirebaseFirestore

class SignUpViewController: UIViewController {

    @IBOutlet var firstNameTextField: UITextField!
    
    @IBOutlet var lastNameTextField: UITextField!
    
    @IBOutlet var businessNameTextField: UITextField!
    
    @IBOutlet var emailTextField: UITextField!
    
    @IBOutlet var passwordTextField: UITextField!
    
    @IBOutlet var signUpButton: UIButton!
    
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
        
        self.firstNameTextField.addDoneButton(title: "Done", target: self, selector: #selector(tapDone(sender:)))
        
        self.lastNameTextField.addDoneButton(title: "Done", target: self, selector: #selector(tapDone(sender:)))
        
        self.businessNameTextField.addDoneButton(title: "Done", target: self, selector: #selector(tapDone(sender:)))
        
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
        Utilities.styleTextField(businessNameTextField)
        
    }
    
    
    
    //Check the fields and ensure that the data entered is correct
    //If all is correct return nil, otherwise return error message
    func validateFields() -> String? {
        
        //check to make sure all fields are filled in
        if firstNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || lastNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || businessNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            
            return "Please fill in all feilds"
        }
        
        
        let cleanedPassword = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        //check if the password is secure
        if Utilities.isPasswordValid(cleanedPassword) == false {
            
            //password is not secure enough
            return "Please make sure your passowrd is at least 8 charecters, contains a special charecter, and a number."
        }
        
        if businessNameTextField.text!.count > 19 {
            
            return "Business name too long"
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
            let business = businessNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
            
            //create the user
            Auth.auth().createUser(withEmail: email, password: password) { (result, err) in
                
                //check for errors
                if err != nil {
                    
                    //there was an error
                    self.showError("Error creating user, you may already have an account with that email")
                    
                } else {
                    
                    //user created successfully, store their info
                    let db = Firestore.firestore()
                    
                    //create business
                    db.collection("Businesses").document(result!.user.uid).setData(["business":business, "business owner":lastname, "owner uid":result!.user.uid, "uid":result!.user.uid, "email": email, "online": "no"]) { (error) in
                        
                        if error != nil {
                            
                            //show error
                            self.showError("Error saving user data")
                        }
                    }
                    
                    //create user
                    db.collection("users").document(result!.user.uid).setData(["firstname":firstname, "lastname":lastname, "password":password,  "uid":result!.user.uid, "business":business, "is customer":"no"]) { (error) in
                        
                        if error != nil {
                            
                            //show error
                            self.showError("Error saving user data")
                        }
                    }
                    
                    
                
                    //transition to the home screen
                    self.transitionToBusinessHome()
                    
                }
                
            }
            
        }
        
    }
    
    
    
    
    
    
    

}
