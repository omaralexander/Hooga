//
//  existingTableMessages.swift
//  Hooga
//
//  Created by Omar Abbas on 1/16/17.
//  Copyright © 2017 Omar Abbas. All rights reserved.
//

import UIKit
import Firebase

// this is the messaging screen

class existingTableMessages: UICollectionViewController, UITextFieldDelegate, UICollectionViewDelegateFlowLayout{
    let cellId = "cellId"
    var existingUser: Messages?
    
   
    @IBOutlet var collectionViewInController: UICollectionView!

    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupKeyboardObservers()
        
        collectionView?.contentInset = UIEdgeInsetsMake(8, 0, 48, 0)
        collectionView?.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, 8, 0)
        collectionView?.alwaysBounceVertical = true
        collectionView?.backgroundColor = UIColor.white
        collectionView?.register(ChatMessageCell.self, forCellWithReuseIdentifier: cellId)
       collectionView?.keyboardDismissMode = .onDrag
    observeMessages()
    }
    var messages = [Messages]()
    func observeMessages(){
        guard let uid = FIRAuth.auth()?.currentUser?.uid else{
            return
        }
        let userMessagesRef = FIRDatabase.database().reference().child("user-messages").child(uid)
        userMessagesRef.observe(.childAdded, with: {(snapshot) in
           let messageId = snapshot.key
            let messagesRef = FIRDatabase.database().reference().child("messages").child(messageId)
            messagesRef.observeSingleEvent(of: .value, with: {(snapshot) in
                
            
                guard let dictionary = snapshot.value as? [String: AnyObject] else {
                    return
                }
                let message = Messages(dictionary: dictionary)
                message.setValuesForKeys(dictionary)
                
                
                if message.chatPartnerId() == self.existingUser?.chatPartnerId(){
                self.messages.append(message)
                self.collectionView?.reloadData()
                let indexPath = NSIndexPath(item: self.messages.count - 1, section: 0)
                self.collectionView?.scrollToItem(at: indexPath as IndexPath, at: .bottom, animated: true)
                }
            
            }, withCancel: nil)
            
        }, withCancel: nil)
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! ChatMessageCell
        let message = messages[indexPath.item]
        cell.textView.text = message.text
        
        setupCell(cell: cell, message: message)
        if let text = message.text {
            //a text message
        cell.bubbleWidthAnchor?.constant = estimateFrameForText(text: text).width + 32
            cell.textView.isHidden = false
            
            
        } else if message.imageUrl != nil {
            cell.bubbleWidthAnchor?.constant = 200
            cell.textView.isHidden = true
        }
        return cell
    }
    private func setupCell(cell: ChatMessageCell, message: Messages){
        guard let chatPartnerId = existingUser?.chatPartnerId() else{
            return
        }
        let ref = FIRDatabase.database().reference().child("Users").child(chatPartnerId)
        ref.observeSingleEvent(of: .value, with: {(snapshot) in
            guard let dictionary = snapshot.value as? [String: AnyObject]
                else{
                    return
            }
            let user = User()
            user.setValuesForKeys(dictionary)
            if let profileImageUrl = user.profileImageUrl{
        cell.profileImageView.loadImageUsingCachWithUrlString(urlString:profileImageUrl)
            }
        })
        if message.fromId == FIRAuth.auth()?.currentUser?.uid{
            cell.bubbleView.backgroundColor = ChatMessageCell.blueColor
            cell.textView.textColor = UIColor.white
            cell.profileImageView.isHidden = true
            cell.bubbleViewRightAnchor?.isActive = true
            cell.bubbleViewLeftAnchor?.isActive = false
        }else{
            cell.bubbleView.backgroundColor = UIColor(red: 228/255, green: 234/255, blue: 236/255, alpha: 1.0)
            cell.textView.textColor = UIColor.black
            cell.profileImageView.isHidden = false
            cell.bubbleViewRightAnchor?.isActive = false
            cell.bubbleViewLeftAnchor?.isActive = true
        }
        if let messageImageUrl = message.imageUrl {
            cell.messageImageView.loadImageUsingCachWithUrlString(urlString: messageImageUrl)
            cell.messageImageView.isHidden = false
            cell.bubbleView.backgroundColor = UIColor.clear
        }else{
            cell.messageImageView.isHidden = true
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var height: CGFloat = 80
        let message = messages[indexPath.item]
        if let text = message.text {
            
            height = estimateFrameForText(text: text).height + 20
        } else if let imageWidth = message.imageWidth?.floatValue, let imageheight = message.imageHeight?.floatValue {
           
            
            height = CGFloat(imageheight / imageWidth * 200)
        }
    
        return CGSize(width: view.frame.width, height: height)
    }
     func estimateFrameForText(text:String) -> CGRect {
     let size = CGSize(width: 200, height: 1000)
     let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
    
        return NSString(string: text).boundingRect(with: size, options: options, attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 16)], context: nil)
    }
    func handleKeyboardDidShow(){
        let indexPath = NSIndexPath(item: messages.count - 1, section: 0) // messages.count - 1
       collectionView?.scrollToItem(at: indexPath as IndexPath, at: .top, animated: true)
    }
    func setupKeyboardObservers(){
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardDidShow), name: NSNotification.Name.UIKeyboardDidShow, object: nil)
        }
   }
