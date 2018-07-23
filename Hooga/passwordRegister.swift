//
//  passwordRegister.swift
//  Hooga
//
//  Created by Omar Abbas on 3/3/17.
//  Copyright © 2017 Omar Abbas. All rights reserved.
//

import UIKit

class passwordRegister: UIViewController{
    
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var showPassword: UIButton!

    
    var enteredName: String?
    var enteredEmail: String?
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return.lightContent
    }

    @IBAction func unwindToRegisterPasswordViewController(segue:UIStoryboardSegue){
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    
        setupButton()
        setupKeyboardObservers()
        
        nextButton.addTarget(self, action: #selector(sendInformation), for: .touchUpInside)
        showPassword.addTarget(self, action: #selector(showEnteredPassword), for: .touchUpInside)
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapFunction)))
    }

    func setupKeyboardObservers(){
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func handleKeyboardWillHide(notification:NSNotification){
        buttonViewBottomAnchor?.constant = 0
        
        let keyboardDuration = (notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
        UIView.animate(withDuration: keyboardDuration, animations: {self.view.layoutIfNeeded()
        })
    }
    
    func handleKeyboardWillShow(notification:NSNotification){
        
        let keyboardFrame = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
        let keyboardDuration = (notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
        
        buttonViewBottomAnchor?.constant = -(((keyboardFrame?.height)!) + 10)
        
        UIView.animate(withDuration: keyboardDuration, animations: {self.view.layoutIfNeeded()
        })
    }
    var buttonViewBottomAnchor: NSLayoutConstraint?
    
    func setupButton() {
       
        
        //nextButton.frame = CGRect(x: 300, y: 596, width: 50, height: 51)
        
        buttonViewBottomAnchor = nextButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -10)
        buttonViewBottomAnchor?.isActive = true
        nextButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        nextButton.heightAnchor.constraint(equalToConstant: 51).isActive = true
        nextButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 300).isActive = true
    }
    func sendInformation(){
        if passwordTextField.text == "" {
            print("There was nothing entered")
        }
        else{
            performSegue(withIdentifier: "compileInformation", sender: self)
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "compileInformation" {
            let navigationVC = segue.destination as? UINavigationController
            let viewController = navigationVC?.viewControllers.first as! finalRegister
            viewController.enteredName = enteredName
            viewController.enteredEmail = enteredEmail
            viewController.enteredPassword = self.passwordTextField.text
            
        }
    }
    func showEnteredPassword(){
        self.passwordTextField.isSecureTextEntry = false
    }
    func tapFunction(){
        view.endEditing(true)
    }

}
