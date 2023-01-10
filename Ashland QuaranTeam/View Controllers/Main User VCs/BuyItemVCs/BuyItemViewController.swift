//
//  BuyItemViewController.swift
//  Ashland QuaranTeam
//
//  Created by Elijah Retzlaff on 4/19/20.
//  Copyright © 2020 Ashland QuaranTeam. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth
import Firebase
import FirebaseFirestore
import FirebaseStorage

class BuyItemViewController: UIViewController {

    @IBOutlet var backButton: UIButton!
    
    @IBOutlet var checkoutButton: UIButton!
    
    @IBOutlet var errorLabel: UILabel!
    
    
    var item:String = ""
    var business:String = ""
    var businessUID:String = ""
    var price:String = ""
    
    var itemQuantity:String = ""
    var pickUpTime:String = ""
    var itemOwnerStripeID:String = ""

    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setUpElements()
        setUpDoneButton()
    }
    
    func setUpElements () {
        
        errorLabel.alpha = 0
        
        Utilities.styleHollowButtonSmall(backButton)
        Utilities.styleHollowButton(checkoutButton)
    }
    
    //error message dislplaying fucntion
    func showError(_ message:String) {
        
        errorLabel.text = message
        errorLabel.alpha = 1
        
    }
    
    func setUpDoneButton () {
        
        //self.itemNameTextField.addDoneButton(title: "Done", target: self, selector: #selector(tapDone(sender:)))
        
    }
    
    @objc func tapDone(sender: Any) {
        self.view.endEditing(true)
    }
    
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        
        if segue.destination is CheckoutViewController {
            
            // Create a reference to the cities collection
            let vcIP = segue.destination as? CheckoutViewController
            
            vcIP?.item = self.item
            vcIP?.business = self.business
            vcIP?.businessUID = self.businessUID
            vcIP?.itemQuantity = self.itemQuantity
            vcIP?.pickUpTime = self.pickUpTime
            vcIP?.price = self.price
            vcIP?.itemOwnerStripeID = self.itemOwnerStripeID
            
        }
        
    }
    
    func transitionBackToBusiness() {
           
        let mainHomeVC = storyboard?.instantiateInitialViewController()
        
        let busVC = mainHomeVC?.storyboard?.instantiateViewController(withIdentifier: "businessViewViewCont") as? BusinessPageViewController
        
        
        // Create a reference to the cities collection
        busVC?.business = self.business
        busVC?.businessUID = self.businessUID
        busVC?.itemOwnerStripeID = self.itemOwnerStripeID

        
        
        view.window?.rootViewController = busVC
        view.window?.makeKeyAndVisible()
        
           
    }
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        
            let firebaseAuth = Auth.auth()
        do {
            
            try firebaseAuth.signOut()
            
        } catch let signOutError as NSError {
            
            print ("Error signing out: %@", signOutError)
            return
            
        }
        
        self.transitionBackToBusiness()
        
    }
    
    @IBAction func checkoutButtonPressed(_ sender: Any) {
        
        //////////////////////////CHANGE THIS HERE
        self.itemQuantity = "1"
        self.pickUpTime = "4"
        /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        
        
        
        //add price to be charged to cart
        if (self.itemQuantity == "" || self.pickUpTime == "") {
            
            self.showError("Please fill out a quantity and pick up time for your purchase")
            
            return
            
        } else {
            
            let quantitySelected = Double(self.itemQuantity)!
            let itemSelectedPrice = Double(self.price)!
            let cartedTotal = quantitySelected * itemSelectedPrice
            StripeCart.addItemToCart(price: cartedTotal)
            
            performSegue(withIdentifier: "showCheckout", sender: nil)
            
        }
        
    }
    
    
    
    
}
