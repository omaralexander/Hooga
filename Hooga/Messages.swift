//
//  Messages.swift
//  Hooga
//
//  Created by Omar Abbas on 1/14/17.
//  Copyright © 2017 Omar Abbas. All rights reserved.
//

import UIKit
import Firebase

class Messages: NSObject {
 
    var fromId: String?
    var text: String?
    var timeStamp: NSNumber?
    var toId: String?
    var ratingNumber:NSNumber?
    var imageUrl: String?
    
    var imageHeight: NSNumber?
    var imageWidth: NSNumber?
    
    
    func chatPartnerId() -> String?{
        return fromId == FIRAuth.auth()?.currentUser?.uid ? toId : fromId
        }
    
    init(dictionary: [String: AnyObject]) {
        super.init()
        
        fromId = dictionary["fromId"] as? String
        text = dictionary["text"] as? String
        timeStamp = dictionary["timestamp"] as? NSNumber
        toId = dictionary["toId"] as? String
        ratingNumber = dictionary["ratingNumber"] as? NSNumber
        
        imageUrl = dictionary["imageUrl"] as? String
        imageHeight = dictionary["imageHeight"] as? NSNumber
        imageWidth = dictionary["imageWidth"] as? NSNumber
    }


}
