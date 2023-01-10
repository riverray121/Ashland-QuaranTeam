//
//  Utilities.swift
//  Ashland QuaranTeam
//
//  Created by Elijah Retzlaff on 4/16/20.
//  Copyright © 2020 Ashland QuaranTeam. All rights reserved.
//

import Foundation
import UIKit

class Utilities {
    
    ///this is all style code and the very last function is for testing if a password is valid
    
    static func styleTextField(_ textfield:UITextField) {
        
        // Create the bottom line
        let bottomLine = CALayer()
        
        bottomLine.frame = CGRect(x: 0, y: textfield.frame.height - 2, width: textfield.frame.width, height: 2)
        
        bottomLine.backgroundColor = UIColor.init(red: 48/255, green: 173/255, blue: 99/255, alpha: 1).cgColor
        
        // Remove border on text field
        textfield.borderStyle = .none
        
        // Add the line to the text field
        textfield.layer.addSublayer(bottomLine)
        
        
    }
    
    static func styleFilledButton(_ button:UIButton) {
        
        // Filled rounded corner style
        button.backgroundColor = UIColor.init(red: 48/255, green: 173/255, blue: 99/255, alpha: 1)
        button.layer.cornerRadius = 25.0
        button.tintColor = UIColor.white
        
    }
    
    static func styleHollowButton(_ button:UIButton) {
        
        // Hollow rounded corner style
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.cornerRadius = 25.0
        button.tintColor = UIColor.black
        
    }
    
    static func styleHollowButtonSmall(_ button:UIButton) {
        
        // Hollow rounded corner style but small
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.cornerRadius = 15.0
        button.tintColor = UIColor.black
        
    }
    
    
    static func styleHollowButtonBig(_ button:UIButton) {
        
        // Hollow rounded corner style but big
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.cornerRadius = 45.0
        button.tintColor = UIColor.black
        
    }
    
    static func styleTableView(_ tableView:UITableView) {
        
        // Hollow rounded corner style
        tableView.layer.borderWidth = 2
        tableView.layer.borderColor = UIColor.black.cgColor
        tableView.tintColor = UIColor.black
        
    }
    
    static func styleSearchBarSquare(_ searchBar:UISearchBar) {
        
        // Hollow rounded corner style
        searchBar.layer.borderWidth = 2
        searchBar.layer.borderColor = UIColor.black.cgColor
        searchBar.tintColor = UIColor.black
        
    }
    
    static func styleSearchBar(_ searchBar:UISearchBar) {
        
        // Hollow rounded corner style
        searchBar.layer.borderWidth = 2
        searchBar.layer.borderColor = UIColor.black.cgColor
        searchBar.layer.cornerRadius = 15.0
        searchBar.tintColor = UIColor.black
        
    }
    
    static func styleImage(_ imageView:UIImageView) {
        
        
        imageView.layer.cornerRadius = 5.0;
        imageView.layer.masksToBounds = true
        
        imageView.layer.borderColor = UIColor.lightGray.cgColor
        imageView.layer.borderWidth = 1.0
        
    }
    
    static func isPasswordValid(_ password : String) -> Bool {
        
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[a-z])(?=.*[$@$#!%*?&])[A-Za-z\\d$@$#!%*?&]{8,}")
        
        return passwordTest.evaluate(with: password)
        
    }
    
    
   
}
