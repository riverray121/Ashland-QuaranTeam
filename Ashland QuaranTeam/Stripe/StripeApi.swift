//
//  StripeApi.swift
//  Ashland QuaranTeam
//
//  Created by Elijah Retzlaff on 5/2/20.
//  Copyright © 2020 Ashland QuaranTeam. All rights reserved.
//

import Foundation
import Stripe
import FirebaseFunctions
import FirebaseDatabase
import FirebaseAuth
import Firebase
import FirebaseFirestore
import FirebaseStorage

let StripeApi = _StripeApi()

class _StripeApi: NSObject, STPCustomerEphemeralKeyProvider {
    
    //gets ephemeral key and stuff
    func createCustomerKey(withAPIVersion apiVersion: String, completion: @escaping STPJSONResponseCompletionBlock) {
        
        //get stripe id
        guard let uid = Auth.auth().currentUser?.uid else {return}
        let db = Firestore.firestore()
        let ref = db.collection("Customers").document(uid)
        var stripeID:String = ""
        
        ref.getDocument { (snapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                    return
                } else {
                    stripeID = (snapshot?.get("stripeID") as? String)!
                    
                    let stripeId = stripeID
                     
                    //store data key creation needs
                    let data = [
                        "stripe_version": apiVersion,
                        "customer_id": stripeId
                    ]
                    
                    print("apiVersion:")
                    print(apiVersion)
                    print(stripeID)
                    print("end")
                    
                    Functions.functions().httpsCallable("createEphemeralKey").call(data) { (result, error) in
                        
                        if let error = error {
                            print(error)
                            completion(nil, error)
                            return
                        }
                        
                        guard let key = result?.data as? [String: Any] else {
                            completion(nil, nil)
                            print("failed")
                            return
                        }
                        
                        completion(key, nil)
                        
                    }
                    
                    
                }
        }
        
    }
    
}
