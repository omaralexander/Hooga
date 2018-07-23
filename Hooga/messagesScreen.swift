//
//  messagesScreen.swift
//  Hooga
//
//  Created by Omar Abbas on 1/15/17.
//  Copyright © 2017 Omar Abbas. All rights reserved.
//

import UIKit

class messagesScreen: UIViewController{
    @IBAction func dismissButton(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBAction func unwindToVc(segue: UIStoryboardSegue){
        
    }
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return.default
    }
    @IBAction func backupDismissButton(_ sender: Any) {
        dismiss(animated: true)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
