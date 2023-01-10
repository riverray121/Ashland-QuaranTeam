//
//  StripeCart.swift
//  Ashland QuaranTeam
//
//  Created by Elijah Retzlaff on 5/1/20.
//  Copyright © 2020 Ashland QuaranTeam. All rights reserved.
//

import Foundation

let StripeCart = _StripeCart()

final class _StripeCart {
    
    var cartItemPrice = [Double]()
    
    private let stripeCreditCardCut = 0.029
    private let flatFeeCents = 30
    
    //variables for the subtotal, the proccesing fees, the total
    var subtotal: Int {
        var amount = 0
        for item in cartItemPrice {
            let pricePennies = Double(item * 100)
            amount += Int(pricePennies)
        }
        return amount
        
    }
    
    var companyCut: Int {
        
        let cut = processingFees * 2
        
        return cut
    }
    
    var processingFees: Int {
        
        if subtotal == 0 {
            return 0
        }
        
        let sub = Double(subtotal)
        let feesAndSubToatal = Int(((sub) + Double(flatFeeCents)) * stripeCreditCardCut) + flatFeeCents
        
        return feesAndSubToatal
    }
    
    var total: Int {
        return subtotal + processingFees
    }
    
    //if it was a cart here would be where we add or remove items from cart
        //func for this
    
    func addItemToCart(price: Double) {
        cartItemPrice.append(price)
    }
    
    func clearCart() {
        cartItemPrice.removeAll()
    }
    
}
