//
//  ItemPageViewController.swift
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

class ItemPageViewController: UIViewController {

    
    @IBOutlet var backButton: UIButton!
    @IBOutlet var buyItemButton: UIButton!
    @IBOutlet var itemImageOne: UIImageView!
    @IBOutlet var itemImageTwo: UIImageView!
    @IBOutlet var itemImageThree: UIImageView!
    @IBOutlet var costLabel: UILabel!
    @IBOutlet var itemNameLabel: UILabel!
    @IBOutlet var quantityAvailibleLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    
    
    
    
    var business:String = ""
    var businessUID:String = ""
    var item:String = ""
    var price:String = ""

    var cameFromBusiness:String = ""
    var itemOwnerStripeID:String = ""


    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpItemInfo()
        
        setUpElements()
        
        // Do any additional setup after loading the view.
    }
    
    
    
    func setUpElements () {
        
        Utilities.styleHollowButtonSmall(backButton)
        Utilities.styleHollowButtonBig(buyItemButton)
    }
    
    
    
    //load profile data and update profile
    func setUpItemInfo() {
        
        //Import user data
        let db = Firestore.firestore()
        
        let uid = businessUID
        let currItem = item
        
        let nameRef = db.collection("Products").document("\(uid)\(currItem)")
               
        nameRef.getDocument { (snapshot, error) in
            if error == nil {
                
                //IMPORT TEXT INFO
                let quantAvailable = snapshot?.get("Quantity") as? String
                let costAmount = snapshot?.get("Price") as? String
                self.price = costAmount!
                
                self.itemNameLabel.text = snapshot?.get("Product") as? String
                self.costLabel.text = "$\(costAmount!)"
                self.descriptionLabel.text = snapshot?.get("Description") as? String
                
                
                if quantAvailable == "0" {
                    self.quantityAvailibleLabel.text = "SOLD OUT"
                } else if quantAvailable == "NA" {
                     self.quantityAvailibleLabel.text = "Product Availible"
                } else {
                    self.quantityAvailibleLabel.text = "Availible: \(quantAvailable!)"
                }
                
                //
                //
                
                //get photos
                self.getPhotoTwo()
                self.getPhotoThree()
                
                guard let url = snapshot?.get("photo url ONE") as? String else {
                    
                    self.missingOrEmptyItemPhoto("one")
                   
                    return
                }
                       
                let itemONEPhotoRef = Storage.storage().reference(forURL: url)
                
                itemONEPhotoRef.getData(maxSize: 1 * 1024 * 1024) { data, error in
                    if error != nil {
                        print("error getting image one photo")
                        
                        self.missingOrEmptyItemPhoto("one")
                        
                        return
                        
                    } else {
                           // Data for "images/island.jpg" is returned
                        let image = UIImage(data: data!)
                        self.itemImageOne.image = image
                        
                    }
                }
                
                       
            } else {
                print("error getting item name")
            }
        }
        
    }
    
    
    func getPhotoTwo () {
           
           //Import user data
           let db = Firestore.firestore()
           
           let uid = businessUID
           let currItem = item
           
           let nameRef = db.collection("Products").document("\(uid)\(currItem)")
        
            nameRef.getDocument { (snapshot, error) in
                   if error == nil {
                    
                    guard let urltwo = snapshot?.get("photo url TWO") as? String else {
                        
                        self.missingOrEmptyItemPhoto("two")
                        
                        return
                    }
                           
                    let itemTWOPhotoRef = Storage.storage().reference(forURL: urltwo)
                    
                    itemTWOPhotoRef.getData(maxSize: 1 * 1024 * 1024) { data, error in
                        if error != nil {
                            print("error getting image two photo")
                            
                            self.missingOrEmptyItemPhoto("two")
                            
                            return
                            
                        } else {
                               // Data for "images/island.jpg" is returned
                            let image = UIImage(data: data!)
                            self.itemImageTwo.image = image
                            
                        }
                    }
                    
                    
            } else {
                print("error getting item name")
                }
            }
           
       }
       
       func getPhotoThree () {
           
           //Import user data
           let db = Firestore.firestore()
           
           let uid = businessUID
           let currItem = item
           
           let nameRef = db.collection("Products").document("\(uid)\(currItem)")
           
            nameRef.getDocument { (snapshot, error) in
                if error == nil {
                               
                               guard let urlthree = snapshot?.get("photo url THREE") as? String else {
                                   
                                   self.missingOrEmptyItemPhoto("three")
                                   
                                   return
                               }
                                      
                               let itemTHREEPhotoRef = Storage.storage().reference(forURL: urlthree)
                               
                               itemTHREEPhotoRef.getData(maxSize: 1 * 1024 * 1024) { data, error in
                                   if error != nil {
                                       
                                       print("error getting image three photo")
                                       
                                       self.missingOrEmptyItemPhoto("three")
                                       
                                       return
                                       
                                   } else {
                                          // Data for "images/island.jpg" is returned
                                       let image = UIImage(data: data!)
                                       self.itemImageThree.image = image
                                       
                                   }
                               }
                               
                } else {
                    print("error getting item name")
                }
            }
           
       }
    
    
    //could not get uploaded photo
    func missingOrEmptyItemPhoto (_ photoNum: String) {
        
        
        let storageRefEmpty = Storage.storage().reference(withPath: "Items/emptyItemImage.jpg")
               
        storageRefEmpty.getData(maxSize: 1 * 1024 * 1024) { data, error in
            if error != nil {
                print("error getting empty photo")
            } else {
                   // Data for "images/island.jpg" is returned
                let image = UIImage(data: data!)
                
                if photoNum == "one" {
                    self.itemImageOne.image = image
                } else if photoNum == "two" {
                    self.itemImageTwo.image = image
                } else if photoNum == "three" {
                    self.itemImageThree.image = image
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

                    
        
        } else if segue.destination is BusinessPageViewController {
            
            let vcBP = segue.destination as? BusinessPageViewController
            
            vcBP?.business = self.business
            vcBP?.itemOwnerStripeID = self.itemOwnerStripeID
            
        } else if segue.destination is EditItemViewController {
            
            let vcBP = segue.destination as? EditItemViewController
            
            vcBP?.item = self.item
            
        }
        
    }
    
    
    @IBAction func backButtonPressed(_ sender: Any) {
                
        if self.cameFromBusiness == "y" {
            
            performSegue(withIdentifier: "backToItemEdit", sender: nil)
            
        } else {
            
            performSegue(withIdentifier: "backToBusiness", sender: nil)
            
        }
        
    }
    
    
    @IBAction func buyItemPressed(_ sender: Any) {
        
        if self.quantityAvailibleLabel.text! == "SOLD OUT" || self.cameFromBusiness == "y" {
            
            return
            
        }
        
        performSegue(withIdentifier: "showCustomerTransition", sender: nil)
    }
    
    
}
