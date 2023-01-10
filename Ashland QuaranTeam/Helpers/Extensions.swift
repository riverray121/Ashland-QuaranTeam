//
//  Extensions.swift
//  Ashland QuaranTeam
//
//  Created by Elijah Retzlaff on 5/2/20.
//  Copyright © 2020 Ashland QuaranTeam. All rights reserved.
//

import Foundation
import UIKit
import Firebase


//checkout extension
extension Int {
    
    func penniesToFormattedCurrency() -> String {
        
        let dollars = Double(self) / 100
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        
        if let dollarString = formatter.string(from: dollars as NSNumber) {
            return dollarString
        }
        
        return "$0.00"
    }
    
    
    
    
    
}



