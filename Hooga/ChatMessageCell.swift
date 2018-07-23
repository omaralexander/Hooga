//
//  ChatMessageCell.swift
//  Hooga
//
//  Created by Omar Abbas on 1/16/17.
//  Copyright © 2017 Omar Abbas. All rights reserved.
//

import UIKit

// this is the cells inside of the messaging screen

class ChatMessageCell: UICollectionViewCell {
    var loadingUserMessages: loadingUserMessages?
    
    let textView: UITextView = {
        let tv = UITextView()
        tv.text = "SAMPLE TEXT FOR NOW"
        tv.font = UIFont.systemFont(ofSize: 16)
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.backgroundColor = UIColor.clear
        tv.textColor = .white
        tv.isEditable = false
        return tv
    }()
    
    static let blueColor = UIColor(red: 104/250, green: 165/250, blue: 205/250, alpha: 1)
    
    let bubbleView: UIView = {
        let view = UIView()
        view.backgroundColor = blueColor
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 16
        view.layer.masksToBounds = true
        return view
    }()
    
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "newSplashScreen")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 16
        imageView.layer.masksToBounds = true
        return imageView
    }()// was lazy var
    
   let messageImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 24
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.isUserInteractionEnabled = true
    
    
    
    imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleZoomTap)))
        return imageView
    
    }()
        func handleZoomTap(tapGesture: UITapGestureRecognizer) {
       print("thisisatest")
            let imageView = tapGesture.view as? UIImageView
        tapGesture.cancelsTouchesInView = false
        self.loadingUserMessages?.performZoomInForStartingImageView(startingImageView: imageView!)
    }
    
    var bubbleWidthAnchor: NSLayoutConstraint?
    var bubbleViewRightAnchor: NSLayoutConstraint?
    var bubbleViewLeftAnchor: NSLayoutConstraint?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(bubbleView)
        addSubview(textView)
        addSubview(profileImageView)
    
        
        
    bubbleView.addSubview(messageImageView)
    messageImageView.leftAnchor.constraint(equalTo: bubbleView.leftAnchor).isActive = true
    messageImageView.topAnchor.constraint(equalTo: bubbleView.topAnchor).isActive = true
    messageImageView.widthAnchor.constraint(equalTo: bubbleView.widthAnchor).isActive = true
    messageImageView.heightAnchor.constraint(equalTo: bubbleView.heightAnchor).isActive = true
        
        
        
    profileImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8).isActive = true
    profileImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
    profileImageView.widthAnchor.constraint(equalToConstant: 32).isActive = true
    profileImageView.heightAnchor.constraint(equalToConstant: 32).isActive = true
        
    bubbleViewRightAnchor = bubbleView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -8)
    bubbleViewRightAnchor?.isActive = true
    bubbleView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
    bubbleWidthAnchor =  bubbleView.widthAnchor.constraint(equalToConstant: 200)
    bubbleWidthAnchor?.isActive = true
    
    
    bubbleViewLeftAnchor = bubbleView.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 8 ) 
   
    bubbleView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        
        
    textView.leftAnchor.constraint(equalTo: bubbleView.leftAnchor, constant: 8).isActive = true
    textView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
    textView.rightAnchor.constraint(equalTo: bubbleView.rightAnchor).isActive = true
        
    textView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
    
    
    
    
    }
    
    required init?(coder aDecoder: NSCoder){
        fatalError("init(coder:) has not been implemented")
    }
}
