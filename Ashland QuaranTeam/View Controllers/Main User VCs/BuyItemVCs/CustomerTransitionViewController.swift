//
//  CustomerTransitionViewController.swift
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

class CustomerTransitionViewController: UIViewController {
    
    @IBOutlet var backButton: UIButton!
    
    @IBOutlet var signUpButton: UIButton!
    
    @IBOutlet var loginButton: UIButton!
    
    
    var business:String = ""
    var businessUID:String = ""
    var item:String = ""
    var price:String = ""
    var itemOwnerStripeID:String = ""


    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setUpElements()
    }
    
    
    func setUpElements () {
        
        Utilities.styleFilledButton(signUpButton)
        Utilities.styleHollowButton(loginButton)
        Utilities.styleHollowButton(backButton)
    }
    
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        
        if segue.destination is CustomerSignUpViewController {
            
            // Create a reference to the cities collection
            let vcBI = segue.destination as? CustomerSignUpViewController
            
            vcBI?.item = self.item
            vcBI?.business = self.business
            vcBI?.businessUID = self.businessUID
            vcBI?.price = self.price
            vcBI?.itemOwnerStripeID = self.itemOwnerStripeID

            
        } else if segue.destination is CustomerLoginViewController {
            
            // Create a reference to the cities collection
            let vcBI = segue.destination as? CustomerLoginViewController
            
            vcBI?.item = self.item
            vcBI?.business = self.business
            vcBI?.businessUID = self.businessUID
            vcBI?.price = self.price
            vcBI?.itemOwnerStripeID = self.itemOwnerStripeID


            
        } else if segue.destination is ItemPageViewController {
            
            // Create a reference to the cities collection
            let vcBI = segue.destination as? ItemPageViewController
            
            vcBI?.item = self.item
            vcBI?.business = self.business
            vcBI?.businessUID = self.businessUID
            vcBI?.itemOwnerStripeID = self.itemOwnerStripeID
            
        }
        
    }
    
    
    
    
    @IBAction func backButtonPressed(_ sender: Any) {
                
        performSegue(withIdentifier: "backToItemView", sender: nil)

    }
    
    @IBAction func signUpButtonPushed(_ sender: Any) {
        
        performSegue(withIdentifier: "showCustomerSignUp", sender: nil)
        
    }
    
    @IBAction func loginButtonPushed(_ sender: Any) {
        
        performSegue(withIdentifier: "showCustomerLogin", sender: nil)
        
    }
    

}
