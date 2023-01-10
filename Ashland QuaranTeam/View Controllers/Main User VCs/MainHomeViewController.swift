//
//  MainHomeViewController.swift
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

class MainHomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {

    
    @IBOutlet var backButton: UIButton!
    
    @IBOutlet weak var tableView: UITableView!
        
    @IBOutlet weak var searchBar: UISearchBar!
    
    
    var searchBusiness = [String]()
    var businessArray = [String]()

    var nameBusinessClicked = String()
    var isSearching = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        //setup data table
        setUpTableData()
        
        setUpDoneButton()
        
        //button visuals
        setUpElements()
        
    }
    
    func setUpDoneButton () {
        
        self.searchBar.addDoneButton(title: "Done", target: self, selector: #selector(tapDone(sender:)))
        
    }
    
    @objc func tapDone(sender: Any) {
        self.view.endEditing(true)
    }
    
    
    
    //button setup func
    func setUpElements () {
        
        Utilities.styleHollowButton(backButton)
        Utilities.styleSearchBarSquare(searchBar)
        Utilities.styleTableView(tableView)
        
    }
    
    //set up table
    func setUpTableData () {
        
        
        // Create a reference to the cities collection
        let db = Firestore.firestore()
        
        db.collection("Businesses").getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    
                    
                    for document in querySnapshot!.documents {
                        
                        if document.get("online")! as! String == "yes" {
                            
                            self.businessArray.append("\(document.get("business")!)")

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
    
    
    //table view delegate and data source
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if isSearching {
            
            return searchBusiness.count
            
        } else {
            
            return businessArray.count

        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableViewCell", for: indexPath)
        
        if isSearching {
            
            cell.textLabel!.text = searchBusiness[indexPath.row]
            
        } else {
            
            cell.textLabel!.text = businessArray[indexPath.row]
            
        }
        
        
        return cell
    }
    
    
    //search bar code
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        searchBusiness = businessArray.filter({$0.lowercased().prefix(searchText.count) == searchText.lowercased()})
        isSearching = true
        tableView.reloadData()
        
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        isSearching = false
        searchBar.text = ""
        tableView.reloadData()
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        if isSearching {
                   
            nameBusinessClicked = searchBusiness[indexPath.row]
                   
        } else {
                   
            nameBusinessClicked = businessArray[indexPath.row]
            
        }
        
        performSegue(withIdentifier: "showBusiness", sender: nil)
        
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        
        if segue.destination is BusinessPageViewController {
            
            // Create a reference to the cities collection
            let vc = segue.destination as? BusinessPageViewController
            
            vc?.business = nameBusinessClicked
        }
        
    }
    
    
    

}
