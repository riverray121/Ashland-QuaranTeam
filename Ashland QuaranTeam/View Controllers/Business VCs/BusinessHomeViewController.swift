//
//  BusinessHomeViewController.swift
//  Ashland QuaranTeam
//
//  Created by Elijah Retzlaff on 4/16/20.
//  Copyright © 2020 Ashland QuaranTeam. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase
import FirebaseFirestore
import FirebaseStorage

class BusinessHomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    var itemsArray = [String]()
    
    var searchItems = [String]()
    var isSearching = false
    var nameItemClicked = String()

    
    
    @IBOutlet var businessNameLabel: UILabel!
    
    @IBOutlet var signOutButton: UIButton!
    
    @IBOutlet var editProfileButton: UIButton!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet var businessImage: UIImageView!
    
    @IBOutlet var descriptionLabel: UILabel!
    
    @IBOutlet var phoneNumLabel: UILabel!
    
    @IBOutlet var addressLabel: UILabel!
    
    @IBOutlet var bringAccountOnlineButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setUpTableData()
        setUpDoneButton()
        setUpElements()
        getProfileData()
        setUpAccOnlineButton ()
        
    }
    
    func setUpDoneButton () {
        
        self.searchBar.addDoneButton(title: "Done", target: self, selector: #selector(tapDone(sender:)))
        
    }
    
    @objc func tapDone(sender: Any) {
        self.view.endEditing(true)
    }
    

    func setUpElements() {
        
        //style
        Utilities.styleHollowButtonSmall(signOutButton)
        Utilities.styleHollowButtonSmall(editProfileButton)
        Utilities.styleSearchBarSquare(searchBar)
        Utilities.styleTableView(tableView)
        Utilities.styleImage(businessImage)
        
    }
    
    func setUpAccOnlineButton () {
        
        //Import user data
        let db = Firestore.firestore()
        guard let uid = Auth.auth().currentUser?.uid else {return}
        let nameRef = db.collection("Businesses").document(uid)
               
        nameRef.getDocument { (snapshot, error) in
            if error == nil {
                
                //IMPORT TEXT INFO
                if snapshot?.get("online") as? String == "yes" {
                    
                    self.bringAccountOnlineButton.setTitle("Account Online", for: .normal)
                    self.bringAccountOnlineButton.setTitleColor(.green, for: .normal)

                }
                
                //IMPORT TEXT INFO
                guard let stripeId = snapshot?.get("stripeID") as? String else {return}
                                
                let data = [
                    "business_id": stripeId,
                ]
                
                Functions.functions().httpsCallable("retrieveAccount").call(data) { (result, error) in
                    
                    if let error = error {
                        print(error)
                        
                        //inform user of the error
                        print("Error: Could not open Stripe")
                        return
                    }
                    
                    guard let businessAccount = result?.data as? [String: Any] else {
                        
                        print("failed")
                        return
                    }
                    
                    print(businessAccount)
                    
                    let bankAccStatus = businessAccount["payouts_enabled"] as! Int
                    let chargesEnabled = businessAccount["charges_enabled"] as! Int
                    
                    if chargesEnabled == 0 || bankAccStatus == 0 {
                        self.bringAccountOnlineButton.setTitle("Bring Account Online", for: .normal)
                        self.bringAccountOnlineButton.setTitleColor(.red, for: .normal)
                    }
                                                  
                }
            }
        }
    }
    
    
    //set up table
    func setUpTableData () {
        
        guard let uid = Auth.auth().currentUser?.uid else {return}
        // Create a reference to the cities collection
        let db = Firestore.firestore()
        
        db.collection("Products").getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    
                    
                    for document in querySnapshot!.documents {
                        
                        if document.get("owner uid") as? String == uid {
                            
                            self.itemsArray.append("\(document.get("Product")!)")
                            
                        }
                        
                        
                    }
                    
                    //table setup
                    self.tableView.dataSource = self
                    self.tableView.delegate = self
                    
                    //search bar setup
                    self.searchBar.delegate = self
                    
                    self.tableView.reloadData()
                    
                }
        }
        
        
    }
    
    
    //update profile
    func getProfileData() {
        
        //Import user data
        let db = Firestore.firestore()
        guard let uid = Auth.auth().currentUser?.uid else {return}
        let nameRef = db.collection("Businesses").document(uid)
               
        nameRef.getDocument { (snapshot, error) in
            if error == nil {
                
                //IMPORT TEXT INFO
                self.businessNameLabel.text = snapshot?.get("business") as? String
                self.addressLabel.text = snapshot?.get("Address") as? String
                self.phoneNumLabel.text = snapshot?.get("Phone number") as? String
                self.descriptionLabel.text = snapshot?.get("Description") as? String
                
                
                //get photo
                guard let url = snapshot?.get("photo url") as? String else {
                    let storageRefEmpty = Storage.storage().reference(withPath: "Businesses/emptyImage.jpg")
                           
                    storageRefEmpty.getData(maxSize: 1 * 1024 * 1024) { data, error in
                        if error != nil {
                            print("error getting empty photo")
                        } else {
                               // Data for "images/island.jpg" is returned
                            let image = UIImage(data: data!)
                            self.businessImage.image = image
                            
                        }
                    }
                    
                    return
                }
                       
                let businessPhotoRef = Storage.storage().reference(forURL: url)
                
                businessPhotoRef.getData(maxSize: 1 * 1024 * 1024) { data, error in
                    if error != nil {
                        
                        let storageRefEmpty = Storage.storage().reference(withPath: "Businesses/emptyImage.jpg")
                               
                        storageRefEmpty.getData(maxSize: 1 * 1024 * 1024) { data, error in
                            if error != nil {
                                print("error getting empty photo")
                            } else {
                                   // Data for "images/island.jpg" is returned
                                let image = UIImage(data: data!)
                                self.businessImage.image = image
                                
                            }
                        }
                        
                        print("error getting business photo")
                    } else {
                           // Data for "images/island.jpg" is returned
                        let image = UIImage(data: data!)
                        self.businessImage.image = image
                        
                    }
                }
                       
                       
            } else {
                print("error getting business name")
            }
        }
        
    }
    
    
    //table view delegate and data source
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if isSearching {
            
            return searchItems.count
            
        } else {
            
            return itemsArray.count

        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "itemTableCell", for: indexPath)
        
        if isSearching {
            
            cell.textLabel!.text = searchItems[indexPath.row]
            
        } else {
            
            cell.textLabel!.text = itemsArray[indexPath.row]
            
        }
        
        
        return cell
    }
    
    
    //search bar code
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        searchItems = itemsArray.filter({$0.lowercased().prefix(searchText.count) == searchText.lowercased()})
        isSearching = true
        tableView.reloadData()
        
    }
    
    
    @IBSegueAction func returnFromBusiness(_ coder: NSCoder) -> MainHomeViewController? {
        
        getProfileData()
        
        return MainHomeViewController(coder: coder)
    }
    
    
    func transitionToLoginViewHome() {
           
        let loginHomeViewController = storyboard?.instantiateInitialViewController()
           
           view.window?.rootViewController = loginHomeViewController
           view.window?.makeKeyAndVisible()
           
    }
    
    @IBAction func bringAccountOnlinePressed(_ sender: Any) {
        
        performSegue(withIdentifier: "showBringAccOnline", sender: nil)
        
    }
    
    @IBAction func signOutButtonPressed(_ sender: Any) {
        
            let firebaseAuth = Auth.auth()
        do {
            
            try firebaseAuth.signOut()
            
        } catch let signOutError as NSError {
            
            print ("Error signing out: %@", signOutError)
            return
            
        }
        
        self.transitionToLoginViewHome()
        
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        if isSearching {
                   
            nameItemClicked = searchItems[indexPath.row]
                   
        } else {
                   
            nameItemClicked = itemsArray[indexPath.row]
            
        }
        
        performSegue(withIdentifier: "transitionToEditItem", sender: nil)
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        
        if segue.destination is EditItemViewController {
            
            // Create a reference to the cities collection
            let vc = segue.destination as? EditItemViewController
            
            vc?.item = self.nameItemClicked
        
        }
        
    }
    
    
    
}
