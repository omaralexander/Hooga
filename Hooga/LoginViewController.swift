//
//  LoginViewController.swift
//  Hooga
//
//  Created by Omar Abbas on 12/10/16.
//  Copyright © 2016 Omar Abbas. All rights reserved.
//

import UIKit
import Firebase
import FBSDKCoreKit
import FBSDKLoginKit

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    
    @IBOutlet var facebookError: UIView!
    
    @IBOutlet var emailError: UIView!
    
    @IBOutlet var notVerifiedEmail: UIView!
    
    @IBOutlet weak var closeEmailButton: UIButton!
    
    @IBOutlet weak var forgotPasswordButton: UIButton!
    
    @IBOutlet weak var signupButton: UIButton!
    
    @IBOutlet weak var emailandphoneTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var loginButton: UIButton!
    
    @IBOutlet weak var FacebookButton: UIButton!
    
    @IBOutlet weak var visualEffectView: UIVisualEffectView!
    
    @IBOutlet weak var enteredEmail: UITextField!
    
    @IBOutlet weak var buttonView: UIView!
    
    @IBAction func dismissPopUp(_ sender: Any) {
        animateOut()
    }
    
    @IBOutlet weak var facebookDismiss: UIButton!
    
    @IBAction func closeForgotPassword(_ sender: Any) {
        facebookanimateOut()
    }
    func closeKeyboard(){
        self.view.endEditing(true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        closeKeyboard()
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return.lightContent
    }
   
    @IBAction func unwindToLoginViewController(segue:UIStoryboardSegue){
        
    }
    var keyboardActive = false
    var effect: UIVisualEffect!
    
    
    var signupButtonOriginalLocation: CGRect?
    var facebookButtonOriginalLocation: CGRect?
    var loginButtonOriginalLocation: CGRect?
    var forgotPassswordOriginalLocation: CGRect?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        setupButton()
        setupKeyboardObservers()
     
        signupButtonOriginalLocation = signupButton.frame
        facebookButtonOriginalLocation = FacebookButton.frame
        loginButtonOriginalLocation = loginButton.frame
        forgotPassswordOriginalLocation = forgotPasswordButton.frame
        
        
        
        
        forgotPasswordButton.addTarget(self, action: #selector(facebookanimateIn), for: .touchUpInside)
        
        facebookDismiss.addTarget(self, action: #selector(forgotPassword), for: .touchUpInside)

        effect = visualEffectView.effect
        visualEffectView.effect = nil

        visualEffectView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(endEditing)))
        
        self.notVerifiedEmail.layer.cornerRadius = 34
        self.notVerifiedEmail.backgroundColor = UIColor.white
      
        emailError.layer.cornerRadius = 14
        facebookError.layer.cornerRadius = 24
        facebookError.backgroundColor = UIColor.white
       
        FacebookButton.layer.borderWidth = 3
        FacebookButton.layer.borderColor = UIColor.white.cgColor
        
        emailandphoneTextField.tintColor = UIColor.white
        passwordTextField.tintColor = UIColor.white
        
        loginButton.layer.borderWidth = 3
        loginButton.layer.borderColor = UIColor.white.cgColor

        FacebookButton.addTarget(self, action: #selector(handleCustomFBLogin), for: .touchUpInside)
        loginButton.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
        signupButton.addTarget(self, action: #selector(transitionToSignUp), for: .touchUpInside)
        
        closeEmailButton.addTarget(self, action: #selector(emailAnimateOut), for: .touchUpInside)
      
        
    }

    func handleCustomFBLogin() {
        FBSDKLoginManager().logIn(withReadPermissions: ["email"], from: self) { (result, err) in
            if err != nil {
                print("Error loggin in is \(err)")
                //self.facebookanimateIn()
            } else if (result?.isCancelled)!{
                print("The user cancelled loggin in ")
            } else {
                //let credential = FIRFacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
                                let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, email"])
                    graphRequest.start(completionHandler: { (connection, result, error) -> Void in
                    if ((error) != nil) {
                        print("Error: \(error)")
                    } else {
                        
                        let data:[String:AnyObject] = result as! [String: AnyObject]
                        let facebookName:NSString =  data["name"] as! NSString
                        print("facebook name", facebookName as String)
                        let facebookEmail = data["email"] as Any
                        print("facebookeMAIL", facebookEmail as! String)
                        let userId = data["id"] as! NSString
                        print("userId",userId)
                        //let facebookProfileUrl = "http://graph.facebook.com/\(userId)/picture?type=large"
                        let facebookAge = data["age_range"] as Any
                        
                        let fbname = facebookName as String
                        let id = userId as String
                        
                        let array = [fbname,"",id]
                        let password = array.joined(separator: "")
                        
                        FIRAuth.auth()?.createUser(withEmail: facebookEmail as! String, password: password, completion: {result, error in
                            if error != nil{
                              
                                    FIRAuth.auth()?.signIn(withEmail: facebookEmail as! String, password: password, completion: {(user, error) in
                                        if error != nil{
                                            print(error.debugDescription)
                                            return
                                        }
                                    let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                                    let vc: UINavigationController = storyboard.instantiateViewController(withIdentifier: "checker") as! UINavigationController
                                    self.present(vc, animated: true, completion: nil)
                                   // ref.removeObserver(withHandle: handle)
                                })
                            } else {
                                
                                guard let uid = result?.uid else{
                                    return
                                }
                                print("user created as \(uid)")
                                let val = "0"
                                let distance = "5"
                                let distanceNumber = (distance as NSString).integerValue
                                let number = (val as NSString).integerValue
                                let ref = FIRDatabase.database().reference(fromURL:"https://hooga-6dfb9.firebaseio.com/")
                                let usersReference = ref.child("Users").child(uid)
                                let values = ["name" : facebookName, "email": facebookEmail, "password" : password as String,"age" : facebookAge,"profileView":number,"profileImageUrl":"https://firebasestorage.googleapis.com/v0/b/hooga-6dfb9.appspot.com/o/Group%2011%20%402x%20copy.png?alt=media&token=b0fbbf94-c8f6-44d0-af55-7695d0b44f3e","secondImageUrl":"https://firebasestorage.googleapis.com/v0/b/hooga-6dfb9.appspot.com/o/Group%2011%20%402x%20copy.png?alt=media&token=b0fbbf94-c8f6-44d0-af55-7695d0b44f3e","thirdImageUrl":"https://firebasestorage.googleapis.com/v0/b/hooga-6dfb9.appspot.com/o/Group%2011%20%402x%20copy.png?alt=media&token=b0fbbf94-c8f6-44d0-af55-7695d0b44f3e","fourthImageUrl":"https://firebasestorage.googleapis.com/v0/b/hooga-6dfb9.appspot.com/o/Group%2011%20%402x%20copy.png?alt=media&token=b0fbbf94-c8f6-44d0-af55-7695d0b44f3e","fifthImageUrl":"https://firebasestorage.googleapis.com/v0/b/hooga-6dfb9.appspot.com/o/Group%2011%20%402x%20copy.png?alt=media&token=b0fbbf94-c8f6-44d0-af55-7695d0b44f3e","sixthImageUrl":"https://firebasestorage.googleapis.com/v0/b/hooga-6dfb9.appspot.com/o/Group%2011%20%402x%20copy.png?alt=media&token=b0fbbf94-c8f6-44d0-af55-7695d0b44f3e","aboutMe":"Here is where you tell the world who you are... or just copy and paste it off the internet, your choice","firstLocation":"","secondLocation":"","thirdLocation":"","radiusDistance":distanceNumber,"guiderMode":"True","birthday":"","facebookUser":"True","averageRating":"0/5"] as [String : Any];
                                usersReference.updateChildValues(values, withCompletionBlock: { (err,ref) in
                                    if err != nil {
                                        print(err.debugDescription)
                                        return}})
                                print("Save the user successfully into Firebase database")
                                let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                                let vc: UINavigationController = storyboard.instantiateViewController(withIdentifier: "checker") as! UINavigationController
                                self.present(vc, animated: true, completion: nil)
                                //ref.removeObserver(withHandle: handle)
                                
                            }
                        })
                    }
                })
            }
        }
    }

   
    func showEmailAddress() {
        let accessToken = FBSDKAccessToken.current()
        guard let accessTokenString = accessToken?.tokenString else { return }
        
        let credentials = FIRFacebookAuthProvider.credential(withAccessToken: accessTokenString)
        FIRAuth.auth()?.signIn(with: credentials, completion: { (user, error) in
            if error != nil {
                print(error as Any)
                self.facebookanimateIn()
                return
            }
            let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let vc: UINavigationController = storyboard.instantiateViewController(withIdentifier: "checker") as! UINavigationController
            self.present(vc, animated: true, completion: nil)
            
        })
    }


    func handleLogin() {
        self.emailandphoneTextField.resignFirstResponder()
        self.passwordTextField.resignFirstResponder()

        guard let email = emailandphoneTextField.text, let password = passwordTextField.text
            else {
                print ("Form is not valid")
                return
        }
        FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: {(user: FIRUser?, error) in
            if error != nil{
               print(error as Any)
                self.animateIn()
                return
            }
            // the parts that are in green are for verifying if the user has verified their email address, we should implement this after we have added the banking feature and label the software update as "added security features"
           // let user = FIRAuth.auth()?.currentUser
         //   if user?.isEmailVerified == true{
                let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                let vc: UINavigationController = storyboard.instantiateViewController(withIdentifier: "newNavigationController") as!
                UINavigationController
                self.present(vc, animated: true, completion: nil)
                self.emailandphoneTextField.text = ""
                self.passwordTextField.text = ""
               // print("user has verified their email")
                
//            } else{
//                user?.sendEmailVerification(completion: {(error) in
//                    if error != nil{
//                        print(error as Any)
//                        return
//                    }
//                    print("user has not verified their email")
//                    self.emailandphoneTextField.text = ""
//                    self.passwordTextField.text = ""
//                    self.notEmailVerifiedAnimate()
//                })
//            }
        })
    }
    func endEditing(){
        view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    func animateIn() {
        self.view.addSubview(emailError)
        emailError.center = self.view.center
        
        emailError.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
        emailError.alpha = 0
        
        UIView.animate(withDuration: 0.4) {
           self.visualEffectView.effect = self.effect
            self.emailError.alpha = 1
            self.emailError.transform = CGAffineTransform.identity
        }
        
    }
    
    
    func animateOut () {
        UIView.animate(withDuration: 0.3, animations: {
            self.emailError.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
            self.emailError.alpha = 0
            
           
             self.visualEffectView.effect = nil
        }) { (success:Bool) in
            self.emailError.removeFromSuperview()
        }
    }
    
    
    func facebookanimateIn() {
        self.view.addSubview(facebookError)
        
        facebookError.center = self.view.center
        
        facebookError.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
        facebookError.alpha = 0
        
        UIView.animate(withDuration: 0.4) {
           self.visualEffectView.effect = self.effect
            self.facebookError.alpha = 1
            self.facebookError.transform = CGAffineTransform.identity
        }
        
    }
    func notEmailVerifiedAnimate() {
        self.view.addSubview(notVerifiedEmail)
    
        notVerifiedEmail.center = self.view.center
        notVerifiedEmail.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
        notVerifiedEmail.alpha = 0
        
        UIView.animate(withDuration: 0.4) {
            self.visualEffectView.effect = self.effect
            self.notVerifiedEmail.alpha = 1
            self.notVerifiedEmail.transform = CGAffineTransform.identity
        }
        
    }
    
    func emailAnimateOut(){
        UIView.animate(withDuration: 0.3, animations: {
            self.notVerifiedEmail.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
            self.notVerifiedEmail.alpha = 0
            
            self.visualEffectView.effect = nil
        }) {(success:Bool) in
            self.notVerifiedEmail.removeFromSuperview()
        }
    }

    

    
    func facebookanimateOut () {
        UIView.animate(withDuration: 0.3, animations: {
            self.facebookError.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
            self.facebookError.alpha = 0
            
                     self.visualEffectView.effect = nil
        }) { (success:Bool) in
            self.facebookError.removeFromSuperview()
        }
    }
    func setupKeyboardObservers(){
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    
    func handleKeyboardWillHide(notification:NSNotification){
        
        
        signupButton.frame = signupButtonOriginalLocation!
        FacebookButton.frame = facebookButtonOriginalLocation!
        loginButton.frame = loginButtonOriginalLocation!
        forgotPasswordButton.frame = forgotPassswordOriginalLocation!
        
        signupButton.translatesAutoresizingMaskIntoConstraints = true
        FacebookButton.translatesAutoresizingMaskIntoConstraints = true
        loginButton.translatesAutoresizingMaskIntoConstraints = true
        forgotPasswordButton.translatesAutoresizingMaskIntoConstraints = true
        
        
        
        
        let keyboardDuration = (notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
        UIView.animate(withDuration: keyboardDuration, animations: {self.view.layoutIfNeeded()
        })
    }
    
    func handleKeyboardWillShow(notification:NSNotification){
        
        signupButton.translatesAutoresizingMaskIntoConstraints = false
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        FacebookButton.translatesAutoresizingMaskIntoConstraints = false
        forgotPasswordButton.translatesAutoresizingMaskIntoConstraints = false
        let keyboardFrame = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
        let keyboardDuration = (notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
      
        loginButtonBottomAnchor?.constant = -(((keyboardFrame?.height)!) + 2)
        loginButton.widthAnchor.constraint(equalToConstant: loginButton.frame.width).isActive = true
       
        loginButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -10).isActive = true
        
        facebookButtonBottomAnchor?.constant = -(((keyboardFrame?.height)!) + 2)
        FacebookButton.widthAnchor.constraint(equalToConstant: FacebookButton.frame.width).isActive = true
       
        signupButtonBottomAnchor?.constant = -(((keyboardFrame?.height)!) + 40)
        signupButtonLeftAnchor?.constant = 54
        
        forgotPasswordButtonBottomAnchor?.constant = -(((keyboardFrame?.height)!) + 40)
        forgotPasswordButtonLeftAnchor?.constant = 176
        
        
        UIView.animate(withDuration: keyboardDuration, animations: {self.view.layoutIfNeeded()
        })
    }
    var buttonViewBottomAnchor: NSLayoutConstraint?
    var loginButtonBottomAnchor: NSLayoutConstraint?
    var facebookButtonBottomAnchor: NSLayoutConstraint?
    
    var forgotPasswordButtonBottomAnchor:NSLayoutConstraint?
    var forgotPasswordButtonLeftAnchor:NSLayoutConstraint?
    
    var signupButtonBottomAnchor: NSLayoutConstraint?
    var signupButtonLeftAnchor: NSLayoutConstraint?
    
    func setupButton() {

       loginButtonBottomAnchor = loginButton.bottomAnchor.constraint(equalTo: (view?.bottomAnchor)!, constant: -145) //-145
        loginButtonBottomAnchor?.isActive = true
        
        loginButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 190).isActive = true //190 //changing to 185


        facebookButtonBottomAnchor = FacebookButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -145)
        facebookButtonBottomAnchor?.isActive = true
        FacebookButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 13).isActive = true
        
        signupButtonBottomAnchor = signupButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50)
        signupButtonBottomAnchor?.isActive = true
        
        signupButtonLeftAnchor = signupButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: UIScreen.main.bounds.width - 252 ) //was 138 //now going into uiscreen - 237
        signupButtonLeftAnchor?.isActive = true
   

        forgotPasswordButtonBottomAnchor = forgotPasswordButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant:  -105) //-295 //view.bottomAnchor
        forgotPasswordButtonBottomAnchor?.isActive = true
        
        forgotPasswordButtonLeftAnchor = forgotPasswordButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: UIScreen.main.bounds.width - 259)
       forgotPasswordButtonLeftAnchor?.isActive = true
        
        }

    func transitionToSignUp(){
        performSegue(withIdentifier: "signUpSegue", sender: self)
        
    }
    
    func forgotPassword(){
        FIRAuth.auth()?.sendPasswordReset(withEmail: enteredEmail.text!, completion: { result in
            print("done")
            self.facebookanimateOut()
           
        })
    }
}

