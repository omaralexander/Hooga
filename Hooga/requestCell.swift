//
//  requestCell.swift
//  Hooga
//
//  Created by Omar Abbas on 5/14/17.
//  Copyright © 2017 Omar Abbas. All rights reserved.
//

import UIKit
import Firebase

class requestCell: UITableViewCell{
    var request: Request?{
        didSet{
            if let fromId = request?.fromId{
                let ref = FIRDatabase.database().reference().child("Users").child(fromId)
                ref.observeSingleEvent(of: .value, with: {(snapshot) in
                    if let dictionary = snapshot.value as? [String:AnyObject]{
                     self.textLabel?.text = dictionary["name"] as? String
                    
                    }
                }, withCancel: nil)
            }
            
            detailTextLabel?.text = request?.descriptionOfTrip
        }
    }
    override func layoutSubviews() {
        super.layoutSubviews()
     
        //set up the rest of this, and then afterwords you need to set it up so that when the cell is selected that there is a drop down menu that shows exactly everything that is written along with the date and the persons name and picture with also either the ability to select the photo and it takes the person to their profile, or have an ability to message the person then have the ability to accept or reject it which would send a notification to the other person letting them know if they accepted it or not, if it is accepted using a switch statement and have the ability move to the next scene if it is accepeted.
        
        self.detailTextLabel?.numberOfLines = 4
        self.detailTextLabel?.lineBreakMode = NSLineBreakMode.byTruncatingTail
    }
}
