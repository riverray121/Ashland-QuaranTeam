//
//  ScheduleViewController.swift
//  Ashland QuaranTeam
//
//  Created by Elijah Retzlaff on 4/20/20.
//  Copyright © 2020 Ashland QuaranTeam. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase
import FirebaseFirestore
import FirebaseStorage

class ScheduleViewController: UIViewController {

    @IBOutlet var uploadScheduleButton: UIButton!
    @IBOutlet var monday89Text: UITextField!
    @IBOutlet var monday910text: UITextField!
    @IBOutlet var monday1011text: UITextField!
    @IBOutlet var monday1112text: UITextField!
    @IBOutlet var monday121text: UITextField!
    @IBOutlet var monday12text: UITextField!
    @IBOutlet var monday23text: UITextField!
    @IBOutlet var monday34text: UITextField!
    @IBOutlet var monday45text: UITextField!
    @IBOutlet var tues89text: UITextField!
    @IBOutlet var tues910text: UITextField!
    @IBOutlet var tues1011text: UITextField!
    @IBOutlet var tues1112text: UITextField!
    @IBOutlet var tues121text: UITextField!
    @IBOutlet var tues12text: UITextField!
    @IBOutlet var tues23text: UITextField!
    @IBOutlet var tues34text: UITextField!
    @IBOutlet var tues45text: UITextField!
    @IBOutlet var wed89text: UITextField!
    @IBOutlet var wed910text: UITextField!
    @IBOutlet var wed1011text: UITextField!
    @IBOutlet var wed1112text: UITextField!
    @IBOutlet var wed121text: UITextField!
    @IBOutlet var wed12text: UITextField!
    @IBOutlet var wed23text: UITextField!
    @IBOutlet var wed34text: UITextField!
    @IBOutlet var wed45text: UITextField!
    @IBOutlet var thur89text: UITextField!
    @IBOutlet var thur910text: UITextField!
    @IBOutlet var thur1011text: UITextField!
    @IBOutlet var thur1112text: UITextField!
    @IBOutlet var thur121text: UITextField!
    @IBOutlet var thur12text: UITextField!
    @IBOutlet var thur23text: UITextField!
    @IBOutlet var thur34text: UITextField!
    @IBOutlet var thur45text: UITextField!
    @IBOutlet var fri89text: UITextField!
    @IBOutlet var fri910text: UITextField!
    @IBOutlet var fri1011text: UITextField!
    @IBOutlet var fri1112text: UITextField!
    @IBOutlet var fri12text: UITextField!
    @IBOutlet var fri121text: UITextField!
    @IBOutlet var fri23text: UITextField!
    @IBOutlet var fri34text: UITextField!
    @IBOutlet var fri45text: UITextField!
    @IBOutlet var sat89text: UITextField!
    @IBOutlet var sat910text: UITextField!
    @IBOutlet var sat1011text: UITextField!
    @IBOutlet var sat1112text: UITextField!
    @IBOutlet var sat121text: UITextField!
    @IBOutlet var sat12text: UITextField!
    @IBOutlet var sat23text: UITextField!
    @IBOutlet var sat34text: UITextField!
    @IBOutlet var sat45text: UITextField!
    @IBOutlet var sun89text: UITextField!
    @IBOutlet var sun910text: UITextField!
    @IBOutlet var sun1011text: UITextField!
    @IBOutlet var sun1112text: UITextField!
    @IBOutlet var sun121text: UITextField!
    @IBOutlet var sun12text: UITextField!
    @IBOutlet var sun23text: UITextField!
    @IBOutlet var sun34text: UITextField!
    @IBOutlet var sun45text: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        setUpTextFields()
    }

    
    func setUpTextFields () {
        
        monday89Text.addDoneButton(title: "Done", target: self, selector: #selector(tapDone(sender:)))
        monday910text.addDoneButton(title: "Done", target: self, selector: #selector(tapDone(sender:)))
        monday1011text.addDoneButton(title: "Done", target: self, selector: #selector(tapDone(sender:)))
        monday1112text.addDoneButton(title: "Done", target: self, selector: #selector(tapDone(sender:)))
        monday121text.addDoneButton(title: "Done", target: self, selector: #selector(tapDone(sender:)))
        monday12text.addDoneButton(title: "Done", target: self, selector: #selector(tapDone(sender:)))
        monday23text.addDoneButton(title: "Done", target: self, selector: #selector(tapDone(sender:)))
        monday34text.addDoneButton(title: "Done", target: self, selector: #selector(tapDone(sender:)))
        monday45text.addDoneButton(title: "Done", target: self, selector: #selector(tapDone(sender:)))
        tues89text.addDoneButton(title: "Done", target: self, selector: #selector(tapDone(sender:)))
        tues910text.addDoneButton(title: "Done", target: self, selector: #selector(tapDone(sender:)))
        tues1011text.addDoneButton(title: "Done", target: self, selector: #selector(tapDone(sender:)))
        tues1112text.addDoneButton(title: "Done", target: self, selector: #selector(tapDone(sender:)))
        tues121text.addDoneButton(title: "Done", target: self, selector: #selector(tapDone(sender:)))
        tues12text.addDoneButton(title: "Done", target: self, selector: #selector(tapDone(sender:)))
        tues23text.addDoneButton(title: "Done", target: self, selector: #selector(tapDone(sender:)))
        tues34text.addDoneButton(title: "Done", target: self, selector: #selector(tapDone(sender:)))
        tues45text.addDoneButton(title: "Done", target: self, selector: #selector(tapDone(sender:)))
        wed89text.addDoneButton(title: "Done", target: self, selector: #selector(tapDone(sender:)))
        wed910text.addDoneButton(title: "Done", target: self, selector: #selector(tapDone(sender:)))
        wed1011text.addDoneButton(title: "Done", target: self, selector: #selector(tapDone(sender:)))
        wed1112text.addDoneButton(title: "Done", target: self, selector: #selector(tapDone(sender:)))
        wed121text.addDoneButton(title: "Done", target: self, selector: #selector(tapDone(sender:)))
        wed12text.addDoneButton(title: "Done", target: self, selector: #selector(tapDone(sender:)))
        wed23text.addDoneButton(title: "Done", target: self, selector: #selector(tapDone(sender:)))
        wed34text.addDoneButton(title: "Done", target: self, selector: #selector(tapDone(sender:)))
        wed45text.addDoneButton(title: "Done", target: self, selector: #selector(tapDone(sender:)))
        thur89text.addDoneButton(title: "Done", target: self, selector: #selector(tapDone(sender:)))
        thur910text.addDoneButton(title: "Done", target: self, selector: #selector(tapDone(sender:)))
        thur1011text.addDoneButton(title: "Done", target: self, selector: #selector(tapDone(sender:)))
        thur1112text.addDoneButton(title: "Done", target: self, selector: #selector(tapDone(sender:)))
        thur121text.addDoneButton(title: "Done", target: self, selector: #selector(tapDone(sender:)))
        thur12text.addDoneButton(title: "Done", target: self, selector: #selector(tapDone(sender:)))
        thur23text.addDoneButton(title: "Done", target: self, selector: #selector(tapDone(sender:)))
        thur34text.addDoneButton(title: "Done", target: self, selector: #selector(tapDone(sender:)))
        thur45text.addDoneButton(title: "Done", target: self, selector: #selector(tapDone(sender:)))
        fri89text.addDoneButton(title: "Done", target: self, selector: #selector(tapDone(sender:)))
        fri910text.addDoneButton(title: "Done", target: self, selector: #selector(tapDone(sender:)))
        fri1011text.addDoneButton(title: "Done", target: self, selector: #selector(tapDone(sender:)))
        fri1112text.addDoneButton(title: "Done", target: self, selector: #selector(tapDone(sender:)))
        fri12text.addDoneButton(title: "Done", target: self, selector: #selector(tapDone(sender:)))
        fri121text.addDoneButton(title: "Done", target: self, selector: #selector(tapDone(sender:)))
        fri23text.addDoneButton(title: "Done", target: self, selector: #selector(tapDone(sender:)))
        fri34text.addDoneButton(title: "Done", target: self, selector: #selector(tapDone(sender:)))
        fri45text.addDoneButton(title: "Done", target: self, selector: #selector(tapDone(sender:)))
        sat89text.addDoneButton(title: "Done", target: self, selector: #selector(tapDone(sender:)))
        sat910text.addDoneButton(title: "Done", target: self, selector: #selector(tapDone(sender:)))
        sat1011text.addDoneButton(title: "Done", target: self, selector: #selector(tapDone(sender:)))
        sat1112text.addDoneButton(title: "Done", target: self, selector: #selector(tapDone(sender:)))
        sat121text.addDoneButton(title: "Done", target: self, selector: #selector(tapDone(sender:)))
        sat12text.addDoneButton(title: "Done", target: self, selector: #selector(tapDone(sender:)))
        sat23text.addDoneButton(title: "Done", target: self, selector: #selector(tapDone(sender:)))
        sat34text.addDoneButton(title: "Done", target: self, selector: #selector(tapDone(sender:)))
        sat45text.addDoneButton(title: "Done", target: self, selector: #selector(tapDone(sender:)))
        sun89text.addDoneButton(title: "Done", target: self, selector: #selector(tapDone(sender:)))
        sun910text.addDoneButton(title: "Done", target: self, selector: #selector(tapDone(sender:)))
        sun1011text.addDoneButton(title: "Done", target: self, selector: #selector(tapDone(sender:)))
        sun1112text.addDoneButton(title: "Done", target: self, selector: #selector(tapDone(sender:)))
        sun121text.addDoneButton(title: "Done", target: self, selector: #selector(tapDone(sender:)))
        sun12text.addDoneButton(title: "Done", target: self, selector: #selector(tapDone(sender:)))
        sun23text.addDoneButton(title: "Done", target: self, selector: #selector(tapDone(sender:)))
        sun34text.addDoneButton(title: "Done", target: self, selector: #selector(tapDone(sender:)))
        sun45text.addDoneButton(title: "Done", target: self, selector: #selector(tapDone(sender:)))
        
        guard let uid = Auth.auth().currentUser?.uid else {return}

        let db = Firestore.firestore()
         
        let nameRef = db.collection("Businesses").document(uid)
               
        nameRef.getDocument { (snapshot, error) in
            if error == nil {

                //IMPORT TEXT INFO
                if let mon = snapshot?.get("Mon") as? [Any] {
                    self.monday89Text.text = mon[0] as? String
                    self.monday910text.text = mon[1] as? String
                    self.monday1011text.text = mon[2] as? String
                    self.monday1112text.text = mon[3] as? String
                    self.monday121text.text = mon[4] as? String
                    self.monday12text.text = mon[5] as? String
                    self.monday23text.text = mon[6] as? String
                    self.monday34text.text = mon[7] as? String
                    self.monday45text.text = mon[8] as? String
                }
                if let tue = snapshot?.get("Tue") as? [Any] {
                    self.tues89text.text = tue[0] as? String
                    self.tues910text.text = tue[1] as? String
                    self.tues1011text.text = tue[2] as? String
                    self.tues1112text.text = tue[3] as? String
                    self.tues121text.text = tue[4] as? String
                    self.tues12text.text = tue[5] as? String
                    self.tues23text.text = tue[6] as? String
                    self.tues34text.text = tue[7] as? String
                    self.tues45text.text = tue[8] as? String
                }
                if let wed = snapshot?.get("Wed") as? [Any] {
                    self.wed89text.text = wed[0] as? String
                    self.wed910text.text = wed[1] as? String
                    self.wed1011text.text = wed[2] as? String
                    self.wed1112text.text = wed[3] as? String
                    self.wed121text.text = wed[4] as? String
                    self.wed12text.text = wed[5] as? String
                    self.wed23text.text = wed[6] as? String
                    self.wed34text.text = wed[7] as? String
                    self.wed45text.text = wed[8] as? String
                }
                if let thur = snapshot?.get("Thur") as? [Any] {
                    self.thur89text.text = thur[0] as? String
                    self.thur910text.text = thur[1] as? String
                    self.thur1011text.text = thur[2] as? String
                    self.thur1112text.text = thur[3] as? String
                    self.thur121text.text = thur[4] as? String
                    self.thur12text.text = thur[5] as? String
                    self.thur23text.text = thur[6] as? String
                    self.thur34text.text = thur[7] as? String
                    self.thur45text.text = thur[8] as? String
                }
                if let fri = snapshot?.get("Fri") as? [Any] {
                    self.fri89text.text = fri[0] as? String
                    self.fri910text.text = fri[1] as? String
                    self.fri1011text.text = fri[2] as? String
                    self.fri1112text.text = fri[3] as? String
                    self.fri121text.text = fri[4] as? String
                    self.fri12text.text = fri[5] as? String
                    self.fri23text.text = fri[6] as? String
                    self.fri34text.text = fri[7] as? String
                    self.fri45text.text = fri[8] as? String
                }
                if let sat = snapshot?.get("Sat") as? [Any] {
                    self.sat89text.text = sat[0] as? String
                    self.sat910text.text = sat[1] as? String
                    self.sat1011text.text = sat[2] as? String
                    self.sat1112text.text = sat[3] as? String
                    self.sat121text.text = sat[4] as? String
                    self.sat12text.text = sat[5] as? String
                    self.sat23text.text = sat[6] as? String
                    self.sat34text.text = sat[7] as? String
                    self.sat45text.text = sat[8] as? String
                }
                if let sun = snapshot?.get("Sun") as? [Any] {
                    self.sun89text.text = sun[0] as? String
                    self.sun910text.text = sun[1] as? String
                    self.sun1011text.text = sun[2] as? String
                    self.sun1112text.text = sun[3] as? String
                    self.sun121text.text = sun[4] as? String
                    self.sun12text.text = sun[5] as? String
                    self.sun23text.text = sun[6] as? String
                    self.sun34text.text = sun[7] as? String
                    self.sun45text.text = sun[8] as? String
                }
                
            } else {

                let alertController = UIAlertController(title: "Could not upload", message: "Your schedule could not be uploaded.", preferredStyle: .alert)
                
                let action = UIAlertAction(title: "OK", style: .default) { (action) in
                }
                
                alertController.addAction(action)
                self.present(alertController, animated: true)
                
            }

        }
        
    }
    
    func validateFields() -> String? {
                
        if Int(monday89Text.text!) != nil && Int(monday910text.text!) != nil && Int(monday1011text.text!) != nil && Int(monday1112text.text!) != nil && Int(monday121text.text!) != nil && Int(monday12text.text!) != nil && Int(monday23text.text!) != nil && Int(monday34text.text!) != nil && Int(monday45text.text!) != nil && Int(tues89text.text!) != nil && Int(tues910text.text!) != nil && Int(tues1011text.text!) != nil && Int(tues1112text.text!) != nil && Int(tues121text.text!) != nil && Int(tues12text.text!) != nil && Int(tues23text.text!) != nil && Int(tues34text.text!) != nil && Int(tues45text.text!) != nil && Int(wed89text.text!) != nil && Int(wed910text.text!) != nil && Int(wed1011text.text!) != nil && Int(wed1112text.text!) != nil && Int(wed121text.text!) != nil && Int(wed12text.text!) != nil && Int(wed23text.text!) != nil && Int(wed34text.text!) != nil && Int(wed45text.text!) != nil && Int(thur89text.text!) != nil && Int(thur910text.text!) != nil && Int(thur1011text.text!) != nil && Int(thur1112text.text!) != nil && Int(thur121text.text!) != nil && Int(thur12text.text!) != nil && Int(thur23text.text!) != nil && Int(thur34text.text!) != nil && Int(thur45text.text!) != nil && Int(fri89text.text!) != nil && Int(fri910text.text!) != nil && Int(fri1011text.text!) != nil && Int(fri1112text.text!) != nil && Int(fri121text.text!) != nil && Int(fri12text.text!) != nil && Int(fri23text.text!) != nil && Int(fri34text.text!) != nil && Int(fri45text.text!) != nil && Int(sat89text.text!) != nil && Int(sat910text.text!) != nil && Int(sat1011text.text!) != nil && Int(sat1112text.text!) != nil && Int(sat121text.text!) != nil && Int(sat12text.text!) != nil && Int(sat23text.text!) != nil && Int(sat34text.text!) != nil && Int(sat45text.text!) != nil && Int(sun89text.text!) != nil && Int(sun910text.text!) != nil && Int(sun1011text.text!) != nil && Int(sun1112text.text!) != nil && Int(sun121text.text!) != nil && Int(sun12text.text!) != nil && Int(sun23text.text!) != nil && Int(sun34text.text!) != nil && Int(sun45text.text!) != nil
        
            {
            return nil
        } else {
             
            let alertController = UIAlertController(title: "Please fill in all fields with numbers", message: "Please make sure all feilds you entered contain only numbers.", preferredStyle: .alert)
            
            let action = UIAlertAction(title: "OK", style: .default) { (action) in
            }
            
            alertController.addAction(action)
            self.present(alertController, animated: true)
            
            return "Error"
        }
                
    }
    
    @objc func tapDone(sender: Any) {
        self.view.endEditing(true)
    }
    
    
    @IBAction func uploadScheduleChangedPressed(_ sender: Any) {
        
        let error = validateFields()
        
        if error == nil {
            
            guard let uid = Auth.auth().currentUser?.uid else {return}
            
            let mon = [monday89Text.text!, monday910text.text!, monday1011text.text!, monday1112text.text!, monday121text.text!, monday12text.text!, monday23text.text!, monday34text.text!, monday45text.text!]
            let tues = [tues89text.text!, tues910text.text!, tues1011text.text!, tues1112text.text!, tues121text.text!, tues12text.text!, tues23text.text!, tues34text.text!, tues45text.text!]
            let wed = [wed89text.text!, wed910text.text!, wed1011text.text!, wed1112text.text!, wed121text.text!,wed12text.text!, wed23text.text!, wed34text.text!, wed45text.text!]
            let thur = [thur89text.text!, thur910text.text!, thur1011text.text!, thur1112text.text!, thur121text.text!, thur12text.text!, thur23text.text!, thur34text.text!, thur45text.text!]
            let fri = [fri89text.text!, fri910text.text!, fri1011text.text!, fri1112text.text!, fri121text.text!, fri12text.text!, fri23text.text!, fri34text.text!, fri45text.text!]
            let sat = [sat89text.text!, sat910text.text!, sat1011text.text!, sat1112text.text!, sat121text.text!, sat12text.text!, sat23text.text!, sat34text.text!, sat45text.text!]
            let sun = [sun89text.text!, sun910text.text!, sun1011text.text!, sun1112text.text!, sun121text.text!, sun12text.text!, sun23text.text!, sun34text.text!, sun45text.text!]
            
            let userObject = ["Mon": mon, "Tue": tues, "Wed": wed, "Thur": thur, "Fri": fri, "Sat": sat, "Sun": sun] as [String: Any]
            
            let db = Firestore.firestore()
            
            db.collection("Businesses").document(uid).setData(userObject, merge: true) { (error) in
                
                if error != nil {
                    
                    let alertController = UIAlertController(title: "Error", message: "Error uploading schedule.", preferredStyle: .alert)
                    
                    let action = UIAlertAction(title: "OK", style: .default) { (action) in
                    }
                    
                    alertController.addAction(action)
                    self.present(alertController, animated: true)
                    
                }
                                
            }
            
            performSegue(withIdentifier: "backToEditProfVc", sender: nil)
        }
        
    }
    
}
