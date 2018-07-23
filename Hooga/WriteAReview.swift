//
//  WriteAReview.swift
//  Hooga
//
//  Created by Omar Abbas on 1/6/17.
//  Copyright © 2017 Omar Abbas. All rights reserved.
//

import UIKit
import Firebase

class WriteAReview: UIViewController,FloatRatingViewDelegate, UITextViewDelegate{

    @IBAction func dismissReview(_ sender: UIButton) {
      
        dismiss(animated: true)
    }
    @IBOutlet weak var navigationBar: UINavigationBar!
    

    @IBOutlet weak var submitButton: UIButton!
    
    @IBAction func unwindBack(segue: UIStoryboardSegue){}
   
    @IBOutlet weak var sucessView: UIView!
    @IBOutlet var reviewPostSuccess: UIView!
    @IBOutlet weak var label: UILabel!
    
    @IBOutlet weak var visualEffectView: UIVisualEffectView!
    
    
    
    @IBOutlet weak var textField: UITextView!
    @IBOutlet weak var profilePicture: UIImageView!
   
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var floatRatingView: FloatRatingView!
    
    @IBOutlet weak var ratingNumber: UILabel!
    
    @IBOutlet weak var scrollView: UIScrollView!
 
    
    var mainProfile: mainProfile?
    var user3:User?
   
    var keyboardActive = false
    var effect: UIVisualEffect!
    
    let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapFunction))
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return.lightContent
    }
    var submitButtonOriginalLocation: CGRect?
    override func viewDidLoad() {
        super.viewDidLoad()
        submitButtonOriginalLocation = submitButton.frame
        setupButton()
        setupKeyboardObservers()
        
       
        
        self.sucessView.layer.cornerRadius = 34
        effect = visualEffectView.effect
        visualEffectView.effect = nil
        
        
        textField.canCancelContentTouches = false
        
        
        label.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(animateOut)))
        
        sucessView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(animateOut)))
        
        label.isExclusiveTouch = true
        //sucessView.isExclusiveTouch = true
        
        

        self.textField.text = "Write how your experience was here!"
        self.textField.textColor = UIColor.lightGray
        
        
        scrollView.contentSize.height = 1000
        scrollView.isScrollEnabled = false
        view.removeGestureRecognizer(tap)
        
        
        self.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationBar.shadowImage = UIImage()
        self.navigationBar.isTranslucent = true
        self.navigationBar.backgroundColor = UIColor.clear
      
        
       
        self.floatRatingView.emptyImage = UIImage(named:"unselectedReviewStar")
        self.floatRatingView.fullImage = UIImage(named:"selectedReviewStar")
        
        self.floatRatingView.delegate = self
        self.floatRatingView.maxRating = 5
        self.floatRatingView.minRating = 0
        self.floatRatingView.editable = true
        self.floatRatingView.halfRatings = true
        
        
        self.profilePicture.loadImageUsingCachWithUrlString(urlString: (user3?.profileImageUrl)!)
        self.profilePicture.clipsToBounds = true
        self.profilePicture.contentMode = .scaleAspectFill
        self.profilePicture.layer.cornerRadius = 100
        
        self.profilePicture.layer.borderColor = UIColor.white.cgColor
        
        self.profilePicture.layer.borderWidth = 3;
        
        
        self.userName.text = user3?.name
        
       
        submitButton.addTarget(self, action: #selector(handleSend), for: .touchUpInside)
        
      
    }
    func handleSend(){
        let ref = FIRDatabase.database().reference().child("reviews")
        let childRef = ref.childByAutoId()
        let toId = user3!.id!
        let fromId = FIRAuth.auth()!.currentUser!.uid
        let timestamp = NSDate().timeIntervalSince1970
       
        let values = ["text": self.textField.text!,"toId": toId,"fromId": fromId,"timeStamp":timestamp, "ratingNumber": self.ratingNumber.text!] as [String : Any]
        let ratingValues = ["ratingNumber": self.ratingNumber.text!] as [String: Any]
            childRef.updateChildValues(values, withCompletionBlock: {(error, ref) in
            if error != nil{
                print(error as Any)
                return
            }
      
            let recipientUserReviewsRef = FIRDatabase.database().reference().child("user-reviews").child(toId)
             let reviewId = childRef.key
            recipientUserReviewsRef.updateChildValues([reviewId:1])
            
        })
        let ratingForUser = FIRDatabase.database().reference().child("userRating").child(toId).childByAutoId()
        ratingForUser.updateChildValues(ratingValues)
    self.postSuccess()
    
    }

    func floatRatingView(_ ratingView: FloatRatingView, isUpdating rating:Float) {
           }
    
    func floatRatingView(_ ratingView: FloatRatingView, didUpdate rating: Float) {
        self.ratingNumber.text = NSString(format: "%.2f", self.floatRatingView.rating) as String
    }
    func dismissKeyboard() {
        view.endEditing(true)
    }

    func setupKeyboardObservers(){
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)

    }
    
    func handleKeyboardWillHide(notification:NSNotification){
        
        let keyboardDuration = (notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
        
        UIView.animate(withDuration: keyboardDuration, animations: {self.view.layoutIfNeeded()
           
            self.view.removeGestureRecognizer(self.tap)
            
            //self.submitButton.frame.origin = CGPoint(x: 8, y: 607)
            self.submitButton.frame = self.submitButtonOriginalLocation!
            self.scrollView.contentOffset = CGPoint(x: 0, y: 3)
            self.scrollView.isScrollEnabled = false
            
                   })
    }
    
    func handleKeyboardWillShow(notification:NSNotification){
        
        let keyboardFrame = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
        
        let keyboardDuration = (notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
       
        textField.delegate = self
     
        
        self.scrollView.contentOffset = CGPoint(x: 0, y: 329)
       
        //self.submitButton.frame.origin = CGPoint(x: 8, y: 427+(keyboardFrame?.height)!)
        submitReviewBottomAnchor?.constant = -(((keyboardFrame?.height)!) - 15)
       
        
        view.addGestureRecognizer(tap)
        
        
        
        self.scrollView.isScrollEnabled = true
        scrollView.keyboardDismissMode = .onDrag
        
        UIView.animate(withDuration: keyboardDuration, animations: {self.view.layoutIfNeeded()
        })
    }
    func tapFunction(){
        view.endEditing(true)
    }
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray{
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty{
            textView.text = "Write how your experience was here!"
            textView.textColor = UIColor.lightGray
        }
    }
    func postSuccess(){
      self.view.addSubview(reviewPostSuccess)
        
        sucessView.center = self.reviewPostSuccess.center
        reviewPostSuccess.center = self.view.center
        sucessView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
        sucessView.alpha = 0
        
        UIView.animate(withDuration: 0.4) {
            self.visualEffectView.effect = self.effect
            self.sucessView.alpha = 1
            self.sucessView.transform = CGAffineTransform.identity
        }
        view.endEditing(true)
        self.scrollView.isScrollEnabled = false
        
           }
    
    func animateOut(){
        UIView.animate(withDuration: 0.3, animations: {
            self.sucessView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
            self.sucessView.alpha = 0
            
            self.visualEffectView.effect = nil
            
           self.performSegue(withIdentifier: "writeAReview", sender: self)
        }){(success: Bool) in
            self.reviewPostSuccess.removeFromSuperview()

        }
    }
    var submitReviewBottomAnchor: NSLayoutConstraint?
    func setupButton(){
        submitReviewBottomAnchor = submitButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: UIScreen.main.bounds.width - 282)
        submitReviewBottomAnchor?.isActive = true
    }
    
}
