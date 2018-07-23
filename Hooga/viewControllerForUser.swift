//
//  viewControllerForUser.swift
//  Hooga
//
//  Created by Omar Abbas on 2/9/17.
//  Copyright © 2017 Omar Abbas. All rights reserved.
//

import UIKit

class viewControllerForUser: UIViewController{
    var neighboorHood: String?
    var locationToPass: String?
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return.default
    }
    @IBOutlet weak var navigationBar: UINavigationBar!
    
    @IBOutlet weak var neighborhoodSelected: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
      neighborhoodSelected.text = neighboorHood
        self.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationBar.shadowImage = UIImage()
        self.navigationBar.isTranslucent = true
        self.navigationBar.backgroundColor = UIColor.clear

    }
    func sendInformationOver(){
        performSegue(withIdentifier: "loadUsers", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "loadUsers" {
            let viewController = segue.destination as! newYorkUser
            viewController.passedLocation = locationToPass
        }
    }
}
