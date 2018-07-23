//
//  SlideOutMenu.swift
//  Hooga
//
//  Created by Omar Abbas on 12/10/16.
//  Copyright © 2016 Omar Abbas. All rights reserved.
//


import UIKit
import Firebase
import FBSDKLoginKit

class SlideOutMenu: UIViewController {
    
    @IBOutlet weak var username: UILabel!
    @IBOutlet var logOutButton: UIButton!
    @IBOutlet weak var dismissButton: UIButton!
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var profileButton: UIButton!
    @IBOutlet weak var helpButton: UIButton!
    @IBOutlet weak var messagesButton: UIButton!
    @IBOutlet weak var settingsButton: UIButton!
    @IBOutlet weak var historyButton: UIButton!
    @IBOutlet weak var bankingButton: UIButton!
    @IBOutlet weak var guiderSwitch: UISwitch!
    
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        let hour = NSCalendar.current.component(.hour, from: NSDate() as Date)
        
        switch hour{
        case 1...6: return.default
            
        case 7...18: return.default
            
        case 19...24, 0: return.default
            
        default: return.default
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.revealViewController().rearViewRevealWidth = self.view.frame.width-160
       
        

        
        if self.revealViewController() != nil {
            dismissButton.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
            
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        logOutButton.addTarget(self, action:#selector(handleLogout),for: .touchUpInside)
        
        if FIRAuth.auth()?.currentUser?.uid == nil {
            handleLogout()
        }
        
        let uid = FIRAuth.auth()?.currentUser?.uid
        let ref = FIRDatabase.database().reference().child("Users").child(uid!)
       ref.observe(.value, with: {(snapshot) in if let dictionary = snapshot.value as? [String: AnyObject]
        { self.username.text = dictionary["name"] as? String
                }
            
        }, withCancel: nil)
        
        
        let graphRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields" : "id, name, email"])
        let connection = FBSDKGraphRequestConnection()
        
        connection.add(graphRequest, completionHandler: { (connection, result, error) -> Void in
            
        })
        connection.start()
        
        guiderSwitch.addTarget(self, action: #selector(stateChanged(switchState:)), for: .valueChanged)
        checkState()
        

    }
    func stateChanged(switchState: UISwitch){
        if switchState.isOn {
            print("the switch is on")
            let user = FIRAuth.auth()?.currentUser
            let uid = user?.uid
            
            let ref = FIRDatabase.database().reference().child("Users")
            ref.child(uid!).updateChildValues(["guiderMode":"True"])
            
        } else {
            self.dismissButton.sendActions(for: .touchUpInside)
            print("the switch is off")
            let user = FIRAuth.auth()?.currentUser
            let uid = user?.uid
            
            let ref = FIRDatabase.database().reference().child("Users")
            ref.child(uid!).updateChildValues(["guiderMode":"False"])
            animatein()
        }
    }
    func checkState(){
        var checkMode: String?
        let user = FIRAuth.auth()?.currentUser
        let uid = user?.uid
        let ref = FIRDatabase.database().reference().child("Users")
        ref.child(uid!).observeSingleEvent(of: .value, with: {snapshot in
            let dictionary = snapshot.value as? [String:AnyObject]
            checkMode = dictionary?["guiderMode"] as? String
        
            if checkMode == "True"{
                self.guiderSwitch.isOn = true
                }else if checkMode == "False"{
                self.guiderSwitch.isOn = false
            }
        })
    }
    func handleLogout() {
        do {
            try FIRAuth.auth()?.signOut()
        } catch let logoutError {
            print(logoutError)
        }
    }

    func animatein(){
       let alertController = UIAlertController(title: "Guider Mode", message: "By turning off guider mode you will no longer be seen in location results, and will not be available as a guide. This is ideal if you are a traveling to a new place. ", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Got it!", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
        }

}
