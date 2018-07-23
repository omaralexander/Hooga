//
//  UserCell.swift
//  Hooga
//
//  Created by Omar Abbas on 1/12/17.
//  Copyright © 2017 Omar Abbas. All rights reserved.
//

import UIKit
import Firebase

class UserCell: UITableViewCell {
    
    let half = UIImage(named: "updatedHalfStar")
    let full = UIImage(named: "selectedReviewStar")

    
    
    var review: Reviews?{
        didSet{
            if let fromId = review?.fromId{
                let ref = FIRDatabase.database().reference().child("Users").child(fromId)
                ref.observeSingleEvent(of: .value, with: {(snapshot) in
                    if let dictionary = snapshot.value as? [String: AnyObject]
                    {
                        self.textLabel?.text = dictionary["name"] as? String
                        
                        
                        if let profileImageUrl = dictionary["profileImageUrl"] as? String
                        {
                            self.profileImageView.loadImageUsingCachWithUrlString(urlString: profileImageUrl)
                        }
                    }
                    
                }, withCancel: nil)
            }
            

            detailTextLabel?.text = review?.text
            if let seconds = review?.timeStamp?.doubleValue{
            let timestampDate = NSDate(timeIntervalSince1970: seconds)
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "MMMM dd YYYY"
                timeLabel.text = dateFormatter.string(from: timestampDate as Date)
                
                
                if let rating = review?.ratingNumber?.floatValue{
                    let number = String(rating)
                    someReviewStars.text = number
                    
                    starImage1.image = rating < 0.5 ? nil : rating < 1 ? half : full
                    starImage2.image = rating < 1.5 ? nil : rating < 2 ? half : full
                    starImage3.image = rating < 2.5 ? nil : rating < 3 ? half : full
                    starImage4.image = rating < 3.5 ? nil : rating < 4 ? half : full
                    starImage5.image = rating < 4.5 ? nil : rating < 5 ? half : full
     
                }
            }
        }
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        profileImageView.frame = CGRect(x: 3, y: 16, width: 58, height: 58)
        textLabel?.frame = CGRect(x: 64, y: 16, width: textLabel!.frame.width, height: textLabel!.frame.height)
        
       
        detailTextLabel?.frame = CGRect(x: 64, y: 60, width: 308 , height: detailTextLabel!.frame.height)
        
        self.detailTextLabel?.numberOfLines = 4
        self.detailTextLabel?.lineBreakMode = NSLineBreakMode.byTruncatingTail
        starImage1.frame = CGRect(x: 64, y: 38, width: 19, height: 17)
        starImage2.frame = CGRect(x: 85, y: 38, width: 19, height: 17)
        starImage3.frame = CGRect(x: 106, y: 38, width: 19, height: 17)
        starImage4.frame = CGRect(x: 127, y: 38, width: 19, height: 17)
        starImage5.frame = CGRect(x: 145, y: 38, width: 19, height: 17)
    
    }
   
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 15
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    let timeLabel: UILabel = {
        let label = UILabel()
        label.text = "HH:MM:SS"
        label.font = UIFont(name: "Avenir", size: 13)
        label.textColor = UIColor.darkGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let someReviewStars: UILabel = {
        let reviewLabel = UILabel()
        reviewLabel.text = ""
        reviewLabel.font = UIFont(name: "Avenir", size: 0)
        reviewLabel.translatesAutoresizingMaskIntoConstraints = false
        
        return reviewLabel
    }()
    let starImage1: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
       return imageView
    }()
    let starImage2: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    let starImage3: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    let starImage4: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    let starImage5: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
 
    

    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        addSubview(someReviewStars)
        addSubview(profileImageView)
        addSubview(timeLabel)
       
        addSubview(starImage1)
        addSubview(starImage2)
        addSubview(starImage3)
        addSubview(starImage4)
        addSubview(starImage5)
  
        
        
        
        profileImageView.leftAnchor.constraint(equalTo: self.leftAnchor,constant:8).isActive = true
        profileImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
        profileImageView.widthAnchor.constraint(equalToConstant: 58).isActive = true //was 48
        profileImageView.heightAnchor.constraint(equalToConstant: 58).isActive = true // was 48
   
        timeLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 18).isActive = true
        timeLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 18).isActive = true
        timeLabel.widthAnchor.constraint(equalToConstant: 130).isActive = true
        timeLabel.heightAnchor.constraint(equalTo: (textLabel?.heightAnchor)!).isActive = true
        
        someReviewStars.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -65).isActive = true
        someReviewStars.topAnchor.constraint(equalTo: self.topAnchor, constant: 18).isActive = true
        someReviewStars.widthAnchor.constraint(equalToConstant: 100).isActive = true
        someReviewStars.heightAnchor.constraint(equalTo: (textLabel?.heightAnchor)!).isActive = true
        


    }
    required init?(coder aDecoder:NSCoder){
        fatalError("init(coder:) has not been implemented")
    }
}


