//
//  registeringUser.swift
//  Hooga
//
//  Created by Omar Abbas on 3/4/17.
//  Copyright © 2017 Omar Abbas. All rights reserved.
//

import UIKit
import Firebase

class registeringUser: UIViewController {
    @IBOutlet weak var registerUser: UIButton!
    var enteredName: String?
    var enteredEmail: String?
    var enteredPassword: String?
    var enteredBirthday: String?
    
    @IBOutlet weak var visualEffectView: UIVisualEffectView!
    
    @IBOutlet weak var errorDescription: UILabel!
    
    @IBOutlet weak var dismissView: UIButton!
    
    @IBOutlet var errorView: UIView!
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return.lightContent
    }
    var effect: UIVisualEffect!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        effect = visualEffectView.effect
        visualEffectView.effect = nil
        
        errorView.layer.cornerRadius = 34
        errorView.backgroundColor = UIColor.white
        
    registerUser.layer.cornerRadius = 14
        registerUser.addTarget(self, action: #selector(createUser), for: .touchUpInside)
    
    registerUser.layer.borderWidth = 3
    registerUser.layer.borderColor = UIColor.white.cgColor
        
        dismissView.addTarget(self, action: #selector(animateOut), for: .touchUpInside)
    
    }
    
    func createUser(){
        guard let email = enteredEmail, let password = enteredPassword, let name = enteredName, let age = enteredBirthday
            else {
                print("Form is not valid")
                return
        }
        
        FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (user: FIRUser?, error) in
            
            
            if error != nil {
                self.animateIn()
                self.errorDescription.text = error?.localizedDescription
                return
            }
            
            guard let uid = user?.uid else{
                
                return
            }
            let val = "0"
             let number = (val as NSString).integerValue
            let distance = "5"
            let distanceNumber = (distance as NSString).integerValue

            let ref = FIRDatabase.database().reference(fromURL:"https://hooga-6dfb9.firebaseio.com/")
            let usersReference = ref.child("Users").child(uid)

            let values = ["name" : name, "email": email, "password" : password as String,"age" : "","profileView":number,"profileImageUrl":"https://firebasestorage.googleapis.com/v0/b/hooga-6dfb9.appspot.com/o/Group%2011%20%402x%20copy.png?alt=media&token=b0fbbf94-c8f6-44d0-af55-7695d0b44f3e","secondImageUrl":"https://firebasestorage.googleapis.com/v0/b/hooga-6dfb9.appspot.com/o/Group%2011%20%402x%20copy.png?alt=media&token=b0fbbf94-c8f6-44d0-af55-7695d0b44f3e","thirdImageUrl":"https://firebasestorage.googleapis.com/v0/b/hooga-6dfb9.appspot.com/o/Group%2011%20%402x%20copy.png?alt=media&token=b0fbbf94-c8f6-44d0-af55-7695d0b44f3e","fourthImageUrl":"https://firebasestorage.googleapis.com/v0/b/hooga-6dfb9.appspot.com/o/Group%2011%20%402x%20copy.png?alt=media&token=b0fbbf94-c8f6-44d0-af55-7695d0b44f3e","fifthImageUrl":"https://firebasestorage.googleapis.com/v0/b/hooga-6dfb9.appspot.com/o/Group%2011%20%402x%20copy.png?alt=media&token=b0fbbf94-c8f6-44d0-af55-7695d0b44f3e","sixthImageUrl":"https://firebasestorage.googleapis.com/v0/b/hooga-6dfb9.appspot.com/o/Group%2011%20%402x%20copy.png?alt=media&token=b0fbbf94-c8f6-44d0-af55-7695d0b44f3e","aboutMe":"Here is where you tell the world who you are... or just copy and paste it off the internet, your choice","firstLocation":"","secondLocation":"","thirdLocation":"","radiusDistance":distanceNumber,"guiderMode":"True","birthday":age,"facebookUser":"False","averageRating":"0/5"] as [String : Any];
            usersReference.updateChildValues(values, withCompletionBlock: { (err,ref) in

                if err != nil {
                    self.animateIn()
                    self.errorDescription.text = err as! String?
                    return
                }
                //where it works
                    
                    let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                    let vc: UINavigationController = storyboard.instantiateViewController(withIdentifier: "checker") as! UINavigationController
                    self.present(vc, animated: true, completion: nil)
 
            })
        })
    }
    func animateIn(){
        self.view.addSubview(errorView)
        errorView.center = self.view.center
        errorView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
        errorView.alpha = 0
        UIView.animate(withDuration: 0.4){
            self.visualEffectView.effect = self.effect
            self.errorView.alpha = 1
            self.errorView.transform = CGAffineTransform.identity
        }
    }
    func animateOut(){
        UIView.animate(withDuration: 0.3, animations: {
            self.errorView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
            self.errorView.alpha = 0
            self.visualEffectView.effect = nil
            
        }){(success:Bool) in
            self.errorView.removeFromSuperview()
        }
    }
}
