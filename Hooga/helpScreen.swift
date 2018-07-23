//
//  helpScreen.swift
//  Hooga
//
//  Created by Omar Abbas on 4/20/17.
//  Copyright © 2017 Omar Abbas. All rights reserved.
//

import Foundation
import UIKit


class helpScreen: UIViewController{
    
    @IBOutlet weak var contactUs: UIButton!
    @IBOutlet weak var accountHelp: UIButton!
    @IBOutlet weak var findingUsers: UIButton!

   
    @IBAction func dismissButton(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        contactUs.addTarget(self, action: #selector(contactUsFunction), for: .touchUpInside)
        accountHelp.addTarget(self, action: #selector(goToAccountHelp), for: .touchUpInside)
        findingUsers.addTarget(self, action: #selector(findingUsersFunction), for: .touchUpInside)
 
    }
    func goToAccountHelp(){
        //accountHelp
       performSegue(withIdentifier: "accountHelp", sender: self)
    }
    func contactUsFunction(){
        //contactUs
        performSegue(withIdentifier: "contactUs", sender: self)
    }
    func findingUsersFunction(){
        //findingUsers
        performSegue(withIdentifier: "findingUsers", sender: self)
    }
}
