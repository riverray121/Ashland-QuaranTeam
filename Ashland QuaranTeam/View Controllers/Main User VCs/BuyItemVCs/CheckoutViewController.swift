//
//  CheckoutViewController.swift
//  Ashland QuaranTeam
//
//  Created by Elijah Retzlaff on 5/1/20.
//  Copyright © 2020 Ashland QuaranTeam. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth
import Firebase
import FirebaseFirestore
import FirebaseStorage
import Stripe
import FirebaseFunctions

class CheckoutViewController: UIViewController {

    @IBOutlet var backButton: UIButton!
    @IBOutlet var makePurchaseButton: UIButton!
    @IBOutlet var itemNameLabel: UILabel!
    @IBOutlet var itemImageView: UIImageView!
    @IBOutlet var paymentMethodButton: UIButton!
    @IBOutlet var quantityLabel: UILabel!
    @IBOutlet var pickUpLabel: UILabel!
    @IBOutlet var subtotalLabel: UILabel!
    @IBOutlet var processingFeeLabel: UILabel!
    @IBOutlet var totalLabel: UILabel!
    @IBOutlet var itemPriceLabel: UILabel!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    
    
    //for stripe
    var paymentContext: STPPaymentContext!
    
    
    var item:String = ""
    var business:String = ""
    var businessUID:String = ""
    
    var itemQuantity:String = ""
    var pickUpTime:String = ""
    var price:String = ""
    
    var stripeID:String = ""
    var itemOwnerStripeID:String = ""
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setUpItemInfo()
        setUpElements()
        setUpStripeConfig()
    }
    
    func setUpElements () {
        
        itemNameLabel.text = item
        subtotalLabel.text = StripeCart.subtotal.penniesToFormattedCurrency()
        processingFeeLabel.text = StripeCart.processingFees.penniesToFormattedCurrency()
        totalLabel.text = StripeCart.total.penniesToFormattedCurrency()
        quantityLabel.text = itemQuantity
        
        Utilities.styleHollowButtonSmall(backButton)
        Utilities.styleHollowButton(makePurchaseButton)
        
    }
    
    //create cutsomer context, fetch cutomer information from stripe account after empherical key recieved
    func setUpStripeConfig() {
        
        let config = STPPaymentConfiguration.shared()
        //config.createCardSources = true
        config.requiredBillingAddressFields = .none
        config.requiredShippingAddressFields = .none
        
        let customerContext = STPCustomerContext(keyProvider: StripeApi)
        paymentContext = STPPaymentContext(customerContext: customerContext, configuration: config, theme: .default())
        
        paymentContext.paymentAmount = StripeCart.total
        paymentContext.delegate = self
        paymentContext.hostViewController = self
        
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
                let costAmount = snapshot?.get("Price") as? String

                self.itemPriceLabel.text = "$\(costAmount!)"
                                
                //get photo
                
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
                        self.itemImageView.image = image
                        
                    }
                }
                
                       
            } else {
                print("error getting item name")
            }
        }
        
        //import customer data
        guard let customerUid = Auth.auth().currentUser?.uid else {return}
        let ref = db.collection("Customers").document(customerUid)
               
        ref.getDocument { (snapshot, error) in
            if error == nil {
                
                //IMPORT TEXT INFO
                self.stripeID = (snapshot?.get("stripeID") as? String)!
                
            } else {
                print("error getting stripe ID")
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
                    self.itemImageView.image = image
                }
            }
        }
        
    }
    
    func transitionBackToBusiness() {
           
        let mainHomeVC = storyboard?.instantiateInitialViewController()
        
        let busVC = mainHomeVC?.storyboard?.instantiateViewController(withIdentifier: "businessViewViewCont") as? BusinessPageViewController
        
        
        // Create a reference to the cities collection
        busVC?.business = self.business
        busVC?.businessUID = self.businessUID
        
        
        view.window?.rootViewController = busVC
        view.window?.makeKeyAndVisible()
        
           
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        
        if segue.destination is BuyItemViewController {
            
            // Create a reference to the cities collection
            let vcIP = segue.destination as? BuyItemViewController
            
            vcIP?.item = self.item
            vcIP?.business = self.business
            vcIP?.businessUID = self.businessUID
            vcIP?.itemQuantity = self.itemQuantity
            vcIP?.pickUpTime = self.pickUpTime
            vcIP?.price = self.price
            vcIP?.itemOwnerStripeID = self.itemOwnerStripeID

            
        }
        
    }

    @IBAction func backButtonPressed(_ sender: Any) {
        
        //clear cart so that if quantity is changed before return, we dont double count
        paymentContext.paymentAmount = StripeCart.total
        
        StripeCart.clearCart()
        
        performSegue(withIdentifier: "backToBuyItem", sender: nil)
        
    }
    
    @IBAction func selectPaymentPressed(_ sender: Any) {
        
        //paymentContext.pushPaymentOptionsViewController()
        paymentContext.presentPaymentOptionsViewController()
    }
    
    @IBAction func makePurchasePressed(_ sender: Any) {
        
        paymentContext.requestPayment()
        activityIndicator.startAnimating()
        
    }
    
    
}


//stripe configuration extension
extension CheckoutViewController : STPPaymentContextDelegate {
    
    func paymentContextDidChange(_ paymentContext: STPPaymentContext) {
        
        print("payment context change")
        
        //update selected payment method
        if let paymentMethod = paymentContext.selectedPaymentOption {
            paymentMethodButton.setTitle(paymentMethod.label, for: .normal)
        } else {
            paymentMethodButton.setTitle("Select Method", for: .normal)
        }
        
    }
    
    func paymentContext(_ paymentContext: STPPaymentContext, didFailToLoadWithError error: Error) {
        
        activityIndicator.stopAnimating()
        
        let alertController = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            self.navigationController?.popViewController(animated: true)
        }
        
        let retry = UIAlertAction(title: "Retry", style: .default) { (action) in
            self.paymentContext.retryLoading()
        }
        
        alertController.addAction(cancel)
        alertController.addAction(retry)
        
        present(alertController, animated: true, completion: nil)
        
    }
    
    func paymentContext(_ paymentContext: STPPaymentContext, didCreatePaymentResult paymentResult: STPPaymentResult, completion: @escaping STPPaymentStatusBlock) {
        let idempotency = UUID().uuidString.replacingOccurrences(of: "-", with: "")
        
        let data : [String: Any] = [
            "total_amount" : StripeCart.total,
            "customer_id" : stripeID,
            "payment_method_id" : paymentResult.paymentMethod?.stripeId ?? "",
            "idempotency" : idempotency,
            "application_fee_amount": StripeCart.companyCut,
            "connectedAccountID": self.itemOwnerStripeID
        ]
                
        Functions.functions().httpsCallable("createCharge").call(data) { (result, error) in
            
            if let error = error {
                print(error.localizedDescription)
                let alert = UIAlertController(title: "Error", message: "Unable to make charge", preferredStyle: .alert)
                let ok = UIAlertAction(title: "OK", style: .default) { (action) in
                    print("failed to make charge")
                }
                alert.addAction(ok)
                self.present(alert, animated: true, completion: nil)
                
                completion(STPPaymentStatus.error, error)
                return
            }
            
            StripeCart.clearCart()
            self.setUpElements()
            completion(.success, nil)
        }
    }
    
    
    func paymentContext(_ paymentContext: STPPaymentContext, didFinishWith status: STPPaymentStatus, error: Error?) {
        
        let title : String
        let message : String
        
        switch status {
        case .error:
            activityIndicator.stopAnimating()
            title = "Error"
            message = error?.localizedDescription ?? ""
        case .success:
            activityIndicator.stopAnimating()
            title = "Success!"
            message = "Thank you for your purchase"
        case .userCancellation:
            return
        @unknown default:
            fatalError()
        }
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let action = UIAlertAction(title: "OK", style: .default) { (action) in
           
            let firebaseAuth = Auth.auth()
            do {
                
                try firebaseAuth.signOut()
                
            } catch let signOutError as NSError {
                
                print ("Error signing out: %@", signOutError)
                return
                
            }
            
            self.transitionBackToBusiness()
        }
        
        alertController.addAction(action)
        present(alertController, animated: true)
        
    }
    
}




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
