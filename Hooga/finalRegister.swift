//
//  finalRegister.swift
//  Hooga
//
//  Created by Omar Abbas on 3/3/17.
//  Copyright © 2017 Omar Abbas. All rights reserved.
//

import UIKit


class finalRegister: UIViewController{
    
    @IBAction func birthdayTextField(_ sender: UITextField) {
        let datePickerView:UIDatePicker = UIDatePicker()
        datePickerView.backgroundColor = UIColor.white
        
        
        
        datePickerView.datePickerMode = UIDatePickerMode.date
        
        sender.inputView = datePickerView
        
        datePickerView.addTarget(self, action: #selector(self.datePickerValueChanged), for: UIControlEvents.valueChanged)
    }
    @IBOutlet weak var TheBirthdayTextField: UITextField!
    @IBOutlet weak var nextButton: UIButton!
   
    
    
    var enteredName: String?
    var enteredEmail: String?
    var enteredPassword: String?
    var enteredBirthday: String?
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return.lightContent
    }
    @IBAction func unwindToRegisterBirthdayViewController(segue:UIStoryboardSegue){
        
    }
    override func viewDidLoad(){
        super.viewDidLoad()
        
        TheBirthdayTextField.placeholder = "Enter birthday here"
        
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapFunction)))

    
        nextButton.addTarget(self, action: #selector(sendInformation), for: .touchUpInside)
    }
        func sendInformation(){
        if TheBirthdayTextField.text == "" {
            print("There was nothing entered")
        }
        else{
            performSegue(withIdentifier: "registerUser", sender: self)
        }
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "registerUser" {
            let navigationVC = segue.destination as? UINavigationController
            let viewController = navigationVC?.viewControllers.first as! registeringUser
            viewController.enteredName = enteredName
            viewController.enteredEmail = enteredEmail
            viewController.enteredPassword = enteredPassword
            viewController.enteredBirthday = enteredBirthday
        }
    }
   
    func datePickerValueChanged(sender:UIDatePicker) {
        
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "MMMM dd YYYY"
        TheBirthdayTextField.text = dateFormatter.string(from: sender.date)
        enteredBirthday = dateFormatter.string(from: sender.date)
        print("this is the birthday entered", enteredBirthday as Any)
        
    }
    func tapFunction(){
        view.endEditing(true)
    }

}

