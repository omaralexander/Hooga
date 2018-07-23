//
//  Request.swift
//  Hooga
//
//  Created by Omar Abbas on 5/13/17.
//  Copyright © 2017 Omar Abbas. All rights reserved.
//

import Foundation

class Request: NSObject {
    var fromId: String?
    var toId: String?
    var descriptionOfTrip: String?
    var date: String?
    var status: String?
    

    init(dictionary: [String: AnyObject]) {
    super.init()
    
    fromId = dictionary["fromId"] as? String
    toId = dictionary["toId"] as? String
    descriptionOfTrip = dictionary["descriptionOfTrip"] as? String
    date = dictionary["date"] as? String
    status = dictionary["status"] as? String
    
    
    }

}
