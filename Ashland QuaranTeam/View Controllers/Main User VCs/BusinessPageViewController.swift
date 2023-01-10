//
//  BusinessPageViewController.swift
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

class BusinessPageViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {

    @IBOutlet var businessNameLabel: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet var backButton: UIButton!
    
    @IBOutlet var businessImage: UIImageView!
    
    @IBOutlet var descriptionLabel: UILabel!
    
    @IBOutlet var phoneNumLabel: UILabel!
    
    @IBOutlet var adressLabel: UILabel!
    
    
    
    var business:String = ""
    var businessUID:String = ""
    
    var searchItems = [String]()
    var itemsArray = [String]()
    
    var isSearching = false
    var nameItemClicked = String()
    
    var itemOwnerStripeID:String = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        setUpTableData()
        
        setUpDoneButton()
        
        setUpProfileInfo()
        
        setUpElements()
        
    }
    
    func setUpDoneButton () {
        
        self.searchBar.addDoneButton(title: "Done", target: self, selector: #selector(tapDone(sender:)))
        
    }
    
    @objc func tapDone(sender: Any) {
        self.view.endEditing(true)
    }
    
    
    //set up table
    func setUpTableData () {
        
        // Create a reference to the cities collection
        let db = Firestore.firestore()
        
        db.collection("Products").getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    
                    
                    for document in querySnapshot!.documents {
                        
                        if document.get("owner uid") as? String == self.businessUID {
                            
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
    
    
    
    func setUpProfileInfo () {
        
        // Create a reference to the cities collection
        let db = Firestore.firestore()
        
        db.collection("Businesses").getDocuments() { (querySnapshot, err) in
            
                if let err = err {
                    print("Error getting uid: \(err)")
                    
                } else {
                    
                    for document in querySnapshot!.documents {
                        
                        
                        if document.get("business") as? String == self.business {
                            
                            self.businessUID = "\(document.get("owner uid")!)"
                            
                        }
                        
                    }
                    
                    
                    if self.businessUID == "" {
                        
                        print("error loading uid")
                        return
                        
                    } else {
                        
                        //set up profile
                        self.getProfileData()
                        
                    }
                    
                    
                }
        }
        
        
    }
    
    
    
    
    //load profile data and update profile
    func getProfileData() {
        
        //Import user data
        let db = Firestore.firestore()
        let nameRef = db.collection("Businesses").document(businessUID)
               
        nameRef.getDocument { (snapshot, error) in
            if error == nil {
                
                //IMPORT TEXT INFO
                self.businessNameLabel.text = snapshot?.get("business") as? String
                self.adressLabel.text = snapshot?.get("Address") as? String
                self.phoneNumLabel.text = snapshot?.get("Phone number") as? String
                self.descriptionLabel.text = snapshot?.get("Description") as? String
                self.itemOwnerStripeID = (snapshot?.get("stripeID") as? String)!
                //
                
                //get photo
                guard let url = snapshot?.get("photo url") as? String else {
                    
                    self.missingOrEmptyBusinessPhoto()
                    
                    return
                }
                       
                let businessPhotoRef = Storage.storage().reference(forURL: url)
                
                businessPhotoRef.getData(maxSize: 1 * 1024 * 1024) { data, error in
                    if error != nil {
                        
                        self.missingOrEmptyBusinessPhoto()
                        
                        print("error getting business photo")
                        
                        return
                        
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
    
    
    //could not get uploaded photo
    func missingOrEmptyBusinessPhoto () {
        
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
        
    }
    
    
    //button setup func
    func setUpElements () {
        
        Utilities.styleHollowButtonSmall(backButton)
        Utilities.styleSearchBarSquare(searchBar)
        Utilities.styleTableView(tableView)
        Utilities.styleImage(businessImage)
        
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
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "itemBuyerCell", for: indexPath)
        
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
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        if isSearching {
                   
            nameItemClicked = searchItems[indexPath.row]
                   
        } else {
                   
            nameItemClicked = itemsArray[indexPath.row]
            
        }
        
        performSegue(withIdentifier: "showItemPage", sender: nil)
        
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        
        if segue.destination is ItemPageViewController {
            
            // Create a reference to the cities collection
            let vc = segue.destination as? ItemPageViewController
            
            vc?.business = self.business
            vc?.businessUID = self.businessUID
            vc?.itemOwnerStripeID = self.itemOwnerStripeID

            vc?.item = self.nameItemClicked
        
        }
        
        
        
    }
    
    

}
