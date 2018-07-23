//
//  settingsController.swift
//  Hooga
//
//  Created by Omar Abbas on 4/14/17.
//  Copyright © 2017 Omar Abbas. All rights reserved.
//

import UIKit
import Firebase


class settingsController : UIViewController{
    @IBOutlet weak var radiusLabel: UILabel!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var loggedInWithFacebook: UILabel!
    @IBOutlet weak var currentPassword: UITextField!
    @IBOutlet weak var newPassword: UITextField!
    @IBOutlet weak var confirmNewPassword: UITextField!
    @IBOutlet weak var saveNewPassword: UIButton!
    @IBOutlet weak var radiusSlider: UISlider!
    @IBAction func sliderValueChanged(_ sender: UISlider) {
        let currentValue = Int(sender.value)
        radiusLabel.text = "\(currentValue)"
        let user = FIRAuth.auth()?.currentUser
        
        guard let uid = user?.uid else{
            return
        }
    let ref = FIRDatabase.database().reference().child("Users").child(uid)
        ref.updateChildValues(["radiusDistance":sender.value])
    }

    @IBAction func sliderEditingEnded(_ sender: UISlider) {
    }
    @IBAction func confirmPasswordEditingChanged(_ sender: UITextField) {
            if sender.text == newPassword.text {
            confirmNewPassword.backgroundColor = UIColor.green

        } else{
            confirmNewPassword.backgroundColor = UIColor.white
        }
    }


    @IBOutlet weak var confirmChangeLabel: UILabel!
    var retrivedPassword: String?
    var radiusDistanceNumber: Int?
    override func viewDidLoad(){
        super.viewDidLoad()
        checkIfUserIsLoggedInWithFacebook()
        backButton.addTarget(self, action: #selector(dismissViewController), for: .touchUpInside)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(tapGesture)
        
       confirmChangeLabel.isHidden = true
 
        let user = FIRAuth.auth()?.currentUser
        guard let uid = user?.uid else{
            return
        }
        let ref = FIRDatabase.database().reference().child("Users").child(uid)
        ref.observeSingleEvent(of: .value, with: { snapshot in
            if let dictionary = snapshot.value as? [String: AnyObject] {
                self.retrivedPassword = dictionary["password"] as? String
                
            }})

        backButton.addTarget(self, action: #selector(dismissViewController), for: .touchUpInside)
        
        saveNewPassword.addTarget(self, action: #selector(savePassword), for: .touchUpInside)
       
        
        radiusSlider.minimumValue = 1
        radiusSlider.maximumValue = 20
        radiusValue()
    }
    func hideKeyboard() {
        view.endEditing(true)
    }
    func checkIfUserIsLoggedInWithFacebook(){
        let user = FIRAuth.auth()?.currentUser
        let uid = user?.uid
        let ref = FIRDatabase.database().reference().child("Users").child(uid!)
        ref.observeSingleEvent(of: .value, with: { snapshot in
            if let dictionary = snapshot.value as? [String: AnyObject] {
                let userBooleanValue = dictionary["facebookUser"] as? String
                
                if userBooleanValue == "True" {
                    self.loggedInWithFacebook.isHidden = false
                    self.currentPassword.isHidden = true
                    self.newPassword.isHidden = true
                    self.confirmNewPassword.isHidden = true
                } else{
                    self.loggedInWithFacebook.isHidden = true
                    self.currentPassword.isHidden = false
                    self.newPassword.isHidden = false
                    self.confirmNewPassword.isHidden = false
                }

            }
        
        
        
        })
    }
    func radiusValue(){
        let user = FIRAuth.auth()?.currentUser
        guard let uid = user?.uid else{
            return
        }
        let ref = FIRDatabase.database().reference().child("Users").child(uid)
        ref.observeSingleEvent(of: .value, with: {snapshot in
            if let dictionary = snapshot.value as? [String: AnyObject] {
                self.radiusDistanceNumber = dictionary["radiusDistance"] as? Int
                let radiusDistanceNumberFloat = Float(self.radiusDistanceNumber!)
                self.radiusSlider.value = radiusDistanceNumberFloat
                self.radiusLabel.text = String(self.radiusSlider.value)
            }})
    
    }
    func savePassword(){
        view.endEditing(true)
        let user = FIRAuth.auth()?.currentUser
        guard let uid = user?.uid else{
            return
        }
        let ref = FIRDatabase.database().reference().child("Users").child(uid)
        if currentPassword.text == retrivedPassword!&&confirmNewPassword.text == newPassword.text&&confirmNewPassword.text != ""&&newPassword.text != ""{
             ref.observeSingleEvent(of: .value, with: {snapshot in
                let dictionary = snapshot.value as? [String:AnyObject]
                let currentUserPassword = dictionary?["password"] as? String
                let currentEmail = dictionary?["email"] as? String

            let credential = FIREmailPasswordAuthProvider.credential(withEmail: currentEmail!, password: currentUserPassword!)
            user?.reauthenticate(with: credential, completion:{ error in
                if let error = error {
                    print("there is an error \(error)")
                    self.confirmNewPassword.backgroundColor = UIColor.white
                    self.confirmChangeLabel.textColor = UIColor.red
                    self.confirmChangeLabel.text = "There was an error in changing your password"
                    self.confirmChangeLabel.isHidden = false

                }else{
            print("user has been relogged in ")
                    let password = self.confirmNewPassword.text! as String
                    user?.updatePassword(password, completion: {error in
                        
                        if error != nil{
                            print("there was an error\(error) ")
                            self.confirmNewPassword.backgroundColor = UIColor.white
                            self.confirmChangeLabel.textColor = UIColor.red
                            self.confirmChangeLabel.text = "There was an error in changing your password"
                            self.confirmChangeLabel.isHidden = false
                        } else {
                            ref.updateChildValues(["password":password])
                            self.currentPassword.text = ""
                            self.newPassword.text = ""
                            self.confirmNewPassword.text = ""
                            
                            self.confirmChangeLabel.text = "Your password has been successfully changed"
                            self.confirmChangeLabel.isHidden = false
                            self.confirmNewPassword.backgroundColor = UIColor.white
                            
                            }
                        })
                    }
        
                })
            })
        } else{
            self.confirmNewPassword.backgroundColor = UIColor.white
            self.confirmChangeLabel.textColor = UIColor.red
            self.confirmChangeLabel.text = "There was an error in changing your password"
            self.confirmChangeLabel.isHidden = false

        }
    }
func dismissViewController(){
        dismiss(animated: true, completion: nil)
    }
    override func segueForUnwinding(to toViewController: UIViewController, from fromViewController: UIViewController, identifier: String?) -> UIStoryboardSegue? {
        return UIStoryboardSegue(identifier: identifier, source: fromViewController, destination: toViewController){
            let src = fromViewController
            let dst = toViewController
            let transition: CATransition = CATransition()
            let timeFunc : CAMediaTimingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
            transition.duration = 0.4
            transition.timingFunction = timeFunc
            transition.type = kCATransitionPush
            transition.subtype = kCATransitionFromRight
            
            src.view.window?.layer.add(transition, forKey: nil)
            src.present(dst, animated: false, completion: nil)
        }

        }
    }
