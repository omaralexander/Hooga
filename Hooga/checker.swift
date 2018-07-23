//
//  checker.swift
//  Hooga
//
//  Created by Omar Abbas on 12/10/16.
//  Copyright © 2016 Omar Abbas. All rights reserved.
//

import UIKit
import Firebase


class checker: UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        FIRAuth.auth()?.addStateDidChangeListener { auth, user in
            if user != nil {
                // User is signed in.
                let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                let vc: UINavigationController = storyboard.instantiateViewController(withIdentifier: "newNavigationController") as! UINavigationController
                self.present(vc, animated: true, completion: nil)

            } else {
                // No user is signed in.
                let storyboard: UIStoryboard = UIStoryboard(name:"Main", bundle: nil)
                let bc: UIViewController = storyboard.instantiateViewController(withIdentifier: "LoginViewController")
                self.present(bc, animated: true, completion: nil)
                print("user not signed in ")

              
            }
        }
    }
    var loginViewController: LoginViewController?
    func checkVerifiedEmail(){
       let user = FIRAuth.auth()?.currentUser
        if user?.isEmailVerified == true {
                       
        } else{
            FIRAuth.auth()?.currentUser?.sendEmailVerification(completion:{(error) in })
        
            print("user needs to verify email ")
        }
    }
}
