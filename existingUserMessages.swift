//
//  existingUserMessages.swift
//  Hooga
//
//  Created by Omar Abbas on 1/16/17.
//  Copyright © 2017 Omar Abbas. All rights reserved.
//

import UIKit
import Firebase

class existingUserMessages: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    @IBAction func dismissButton(_ sender: Any) {
        //self.performSegue(withIdentifier: "goBack", sender: self)
    }
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var profilepicture: UIImageView!
    
    @IBOutlet weak var sendMessage: UIButton!
    @IBOutlet weak var messageTextField: UITextField!
    @IBOutlet weak var sendPhoto: UIButton!
    
    @IBOutlet weak var messageView: UIView!
   
   
    
    var messageUser: Messages?
    var keyboardActive = false
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
   
        setupKeyboardObservers()
        setupMessage()
       
        
        
        guard let chatPartnerId = messageUser?.chatPartnerId() else{
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
        
        self.username.text = user.name
        
        self.profilepicture.loadImageUsingCachWithUrlString(urlString: (user.profileImageUrl)!)
        
        self.sendMessage.addTarget(self, action: #selector(self.handleSend), for: .touchUpInside)
        
        self.sendPhoto.addTarget(self, action: #selector(self.handleUploadTap), for: .touchUpInside)
        
        self.profilepicture.clipsToBounds = true;
        
        self.profilepicture.contentMode = .scaleAspectFill
        
        self.profilepicture.layer.cornerRadius = self.profilepicture.frame.size.height / 2;
        
        self.profilepicture.layer.cornerRadius =
        
        self.profilepicture.frame.size.width / 2;
        
        let borderColor : UIColor = UIColor(red: 104/255,green: 165/255, blue: 205/255, alpha: 1.0)
        
        self.profilepicture.layer.borderColor = borderColor.cgColor
        
        self.profilepicture.layer.borderWidth = 0.8;
        
        self.sendMessage.layer.cornerRadius = 10
        
    })
}
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }

    func closeKeyboard(){
        self.view.endEditing(true)
    }
    func handleSend(){
        guard let chatPartnerId = messageUser?.chatPartnerId() else{
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
        
        let ref = FIRDatabase.database().reference().child("messages")
        let childRef = ref.childByAutoId()
        let toId = chatPartnerId
        let fromId = FIRAuth.auth()!.currentUser!.uid
        let timestamp = NSDate().timeIntervalSince1970
        let values = ["text": self.messageTextField.text!,"toId": toId as Any,"fromId": fromId,"timeStamp":timestamp] as [String : Any]
        
        childRef.updateChildValues(values, withCompletionBlock: {(error, ref) in
            if error != nil{
                print(error as Any)
                return
            }
            self.messageTextField.text = nil
            let UserReviewsRef = FIRDatabase.database().reference().child("user-messages").child(fromId)
            let messageId = childRef.key
            UserReviewsRef.updateChildValues([messageId:1])
            
            let recipientUserMessagesRef = FIRDatabase.database().reference().child("user-messages").child(toId)
            recipientUserMessagesRef.updateChildValues([messageId:1])
            
            
            
            })
        })
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showExistingMessages"{
            let viewController = segue.destination as! existingTableMessages
            viewController.existingUser = messageUser
            
        }
    }

    func handleUploadTap(){
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        present(imagePickerController, animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        var selectedImageFromPicker: UIImage?
        
        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage{
            selectedImageFromPicker = editedImage
        } else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage{
            selectedImageFromPicker = originalImage
        }
    
        if let selectedImage = selectedImageFromPicker {
            uploadToFirebaseStorageUsingImage(image: selectedImage)
        }
    
        dismiss(animated: true, completion: nil)
    }
    private func uploadToFirebaseStorageUsingImage(image: UIImage){
    let imageName = NSUUID().uuidString
    let ref = FIRStorage.storage().reference().child("message_images").child(imageName)
        if let uploadData = UIImageJPEGRepresentation(image, 0.9){
            ref.put(uploadData, metadata: nil, completion: {(metadata, error) in
                
                if error != nil{
                    print("Failed to ipload image:", error as Any)
                    return
                }
                if let imageUrl = metadata?.downloadURL()?.absoluteString{
                    self.sendMessageWithImageUrl(imageUrl: imageUrl, image: image)
                }
                
            })
        }
    }
    private func sendMessageWithImageUrl(imageUrl: String, image: UIImage){
        guard let chatPartnerId = messageUser?.chatPartnerId() else{
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
            
            let ref = FIRDatabase.database().reference().child("messages")
            let childRef = ref.childByAutoId()
            let toId = chatPartnerId
            let fromId = FIRAuth.auth()!.currentUser!.uid
            let timestamp = NSDate().timeIntervalSince1970
            
            let values = ["imageUrl": imageUrl,"toId": toId as Any,"fromId": fromId,"timeStamp":timestamp, "imageWidth": image.size.width, "imageHeight": image.size.height] as [String : Any]
            
            childRef.updateChildValues(values, withCompletionBlock: {(error, ref) in
                if error != nil{
                    print(error as Any)
                    return
                }
                self.messageTextField.text = nil
                let UserReviewsRef = FIRDatabase.database().reference().child("user-messages").child(fromId)
                let messageId = childRef.key
                UserReviewsRef.updateChildValues([messageId:1])
                
                let recipientUserMessagesRef = FIRDatabase.database().reference().child("user-messages").child(toId)
                recipientUserMessagesRef.updateChildValues([messageId:1])
                
                
                
            })
        })
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    func setupKeyboardObservers(){
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    
    func handleKeyboardWillHide(notification:NSNotification){
        messageViewBottomAnchor?.constant = 0
        
        let keyboardDuration = (notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
        UIView.animate(withDuration: keyboardDuration, animations: {self.view.layoutIfNeeded()
        })
    }
    
    func handleKeyboardWillShow(notification:NSNotification){
     
        let keyboardFrame = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
      let keyboardDuration = (notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
        
       messageViewBottomAnchor?.constant = -((keyboardFrame?.height)!)
        UIView.animate(withDuration: keyboardDuration, animations: {self.view.layoutIfNeeded()
            })
        }
    var messageViewBottomAnchor: NSLayoutConstraint?
    var sendMessageBottomAnchor: NSLayoutConstraint?
    var sendPhotoBottomAnchor: NSLayoutConstraint?
    var messageTextFieldBottomAnchor: NSLayoutConstraint?
    
    func setupMessage() {
        let containerView = UIView()
        containerView.backgroundColor = UIColor.white
        let sendMessageVariable = self.sendMessage
        let sendPhotoVariable = self.sendPhoto
        let messageTextFieldVariable = self.messageTextField
        
        
        
        containerView.translatesAutoresizingMaskIntoConstraints = false
        sendMessageVariable?.translatesAutoresizingMaskIntoConstraints = false
        sendPhotoVariable?.translatesAutoresizingMaskIntoConstraints = false
        messageTextFieldVariable?.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(containerView)
        
        containerView.addSubview(sendPhotoVariable!)
        containerView.addSubview(messageTextFieldVariable!)
        containerView.addSubview(sendMessageVariable!)
        containerView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        
        
        
        messageViewBottomAnchor = containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        messageViewBottomAnchor?.isActive = true
       
        containerView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width).isActive = true
        containerView.heightAnchor.constraint(equalToConstant: 45).isActive = true
        containerView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        
        
        sendPhotoVariable?.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 6).isActive = true
        sendPhotoVariable?.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        sendPhotoVariable?.widthAnchor.constraint(equalToConstant: 25).isActive = true
        sendPhotoVariable?.heightAnchor.constraint(equalToConstant: 18).isActive = true
        
        sendMessageVariable?.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -5).isActive = true
        sendMessageVariable?.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        sendMessageVariable?.widthAnchor.constraint(equalToConstant: 46).isActive = true
        sendMessageVariable?.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        messageTextFieldVariable?.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 51).isActive = true
        messageTextFieldVariable?.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        messageTextFieldVariable?.widthAnchor.constraint(equalToConstant: 264).isActive = true
        messageTextFieldVariable?.heightAnchor.constraint(equalToConstant: 38).isActive = true
        
    }
}
