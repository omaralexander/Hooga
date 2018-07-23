//
//  MessageCell.swift
//  Hooga
//
//  Created by Omar Abbas on 1/14/17.
//  Copyright © 2017 Omar Abbas. All rights reserved.
//

import UIKit
import Firebase

let newColor = UIColor(red: 53/250, green: 55/250, blue: 56/250, alpha: 1)

let blackColor = UIColor(red: 53/250, green: 55/250, blue: 56/250, alpha: 1)
class MessageCell: UITableViewCell{
    var message: Messages?{
        didSet{
       
            if let toId = message?.chatPartnerId() {
                let ref = FIRDatabase.database().reference().child("Users").child(toId)
                ref.observeSingleEvent(of: .value, with: {(snapshot) in
                    
                    if let dictionary = snapshot.value as? [String: AnyObject] {
                        self.textLabel?.text = dictionary["name"] as? String
                        
                        if let profileImageUrl = dictionary["profileImageUrl"] as? String {
                            self.profileImageView.loadImageUsingCachWithUrlString(urlString: profileImageUrl)
                            
                        }
                    }
                    }, withCancel: nil)
                
            }
            
            detailTextLabel?.text = message?.text
            if let seconds = message?.timeStamp?.doubleValue{
            let timestampDate = NSDate(timeIntervalSince1970: seconds)
            let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "hh:mm:ss a"
                timeLabel.text = dateFormatter.string(from: timestampDate as Date)
            }
        }
    }


    override func layoutSubviews() {
        super.layoutSubviews()
        
        textLabel?.frame = CGRect(x: 88, y: textLabel!.frame.origin.y - 2, width: textLabel!.frame.width, height: textLabel!.frame.height) // x was 64
        textLabel?.font = UIFont(name: "Avenir-Medium", size: 19)
        textLabel?.textColor = blackColor
        
        detailTextLabel?.frame = CGRect(x: 88, y: detailTextLabel!.frame.origin.y - 2, width: detailTextLabel!.frame.width, height: detailTextLabel!.frame.height)
        detailTextLabel?.font = UIFont(name: "Arial", size: 15)
            detailTextLabel?.textColor = newColor //was uicolor.darkGray
    }
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 39 // was 24
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
       
    let timeLabel: UILabel = {
        let label = UILabel()
        label.text = "HH:MM:SS"
        label.font = UIFont(name: "Avenir", size: 13)
        label.textColor = newColor //was uicolor.darkGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        addSubview(profileImageView)
        addSubview(timeLabel)

        profileImageView.leftAnchor.constraint(equalTo: self.leftAnchor,constant:4).isActive = true //was 8
        profileImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 83).isActive = true//both were 48
        profileImageView.heightAnchor.constraint(equalToConstant: 83).isActive = true
   
        timeLabel.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        timeLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 18).isActive = true
        timeLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
        timeLabel.heightAnchor.constraint(equalTo: (textLabel?.heightAnchor)!).isActive = true

    }
    required init?(coder aDecoder:NSCoder){
        fatalError("init(coder:) has not been implemented")
    }
    
}

