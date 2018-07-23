//
//  mainProfile.swift
//  Hooga
//
//  Created by Omar Abbas on 1/9/17.
//  Copyright © 2017 Omar Abbas. All rights reserved.
//

import UIKit
import Firebase

class mainProfile: UIViewController,UITextViewDelegate{
    let half = UIImage(named: "updatedHalfStar")
    let full = UIImage(named: "selectedReviewStar")
    
    @IBAction func unwindToVc(segue:UIStoryboardSegue){
        
    }
    @IBAction func requestDateEditing(_ sender: UITextField) {
        let datePickerView:UIDatePicker = UIDatePicker()
        datePickerView.backgroundColor = UIColor.white
        datePickerView.datePickerMode = UIDatePickerMode.date
        sender.inputView = datePickerView
        datePickerView.addTarget(self, action: #selector(self.datePickerValueChanged), for: UIControlEvents.valueChanged)
    }
    
    @IBOutlet weak var requestGuide: UIButton!
    @IBOutlet weak var usersMainLocation: UILabel!
    @IBOutlet weak var usersAge: UILabel!
    @IBOutlet weak var averageStars: UILabel!
   
    @IBOutlet weak var descriptionOfWhatToDoLabel: UILabel!
    @IBOutlet weak var selectDateLabel: UILabel!
    @IBOutlet weak var selectedGuideLabel: UILabel!
    @IBOutlet var requestView: UIView!
    @IBOutlet weak var descriptionRequest: UITextView!
    @IBOutlet weak var sendRequest: UIButton!
    @IBOutlet weak var guideName: UILabel!
    @IBOutlet weak var delieveredLabel: UILabel!
    @IBOutlet weak var delieveredMessage: UILabel!

    @IBOutlet weak var requestDate: UITextField!
    @IBOutlet weak var dismissRequest: UIButton!
    
    
    @IBOutlet weak var visualEffectForReview: UIVisualEffectView!
    @IBOutlet weak var reviewTimeStamp: UILabel!
    
    @IBOutlet weak var reviewText: UITextView!
    @IBOutlet weak var reviewUserImage: UIImageView!
    
    @IBOutlet weak var reviewWindow: UIView!
    @IBOutlet weak var reviewUserName: UILabel!
    @IBOutlet var openReviews: UIView!
    @IBOutlet weak var reviewDismissButton: UIButton!
    
    @IBOutlet weak var starImage1: UIImageView!
    @IBOutlet weak var starImage2: UIImageView!
    @IBOutlet weak var starImage3: UIImageView!
    @IBOutlet weak var starImage4: UIImageView!
    @IBOutlet weak var starImage5: UIImageView!
    
    @IBOutlet weak var averageStar1: UIImageView!
    @IBOutlet weak var averageStar2: UIImageView!
    @IBOutlet weak var averageStar3: UIImageView!
    @IBOutlet weak var averageStar4: UIImageView!
    @IBOutlet weak var averageStar5: UIImageView!
    
    var user2:User?
    var reviewProfileData: Reviews?
    var numberOfProfileViews = 0
    
    var review: Reviews?{
        didSet{
    if let fromId = review?.fromId{
        let ref = FIRDatabase.database().reference().child("Users").child(fromId)
        ref.observeSingleEvent(of: .value, with: {(snapshot) in
            if let dictionary = snapshot.value as? [String: AnyObject]
            {
                self.reviewUserName?.text = dictionary["name"] as? String
                
                if let rating = self.review?.ratingNumber?.floatValue{
                  
                    self.starImage1.image = rating < 0.5 ? nil : rating < 1 ? self.half : self.full
                    self.starImage2.image = rating < 1.5 ? nil : rating < 2 ? self.half : self.full
                    self.starImage3.image = rating < 2.5 ? nil : rating < 3 ? self.half : self.full
                    self.starImage4.image = rating < 3.5 ? nil : rating < 4 ? self.half : self.full
                    self.starImage5.image = rating < 4.5 ? nil : rating < 5 ? self.half : self.full

                }
                
                
                
                if let seconds = self.review?.timeStamp?.doubleValue{
                    let timestampDate = NSDate(timeIntervalSince1970: seconds)
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "MMMM dd YYYY"
                    self.reviewTimeStamp.text = dateFormatter.string(from: timestampDate as Date)
                }
                self.testForGettingAllValues()
                
                if let profileImageUrl = dictionary["profileImageUrl"] as? String {
                    self.reviewUserImage.loadImageUsingCachWithUrlString(urlString: profileImageUrl)
                        }
                    }
            
                }, withCancel: nil)
            }
        }
    }
 
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    @IBOutlet weak var visualEffectView: UIVisualEffectView!
    
   
    @IBAction func dismissButton(_ sender: Any) {
        self.dismiss(animated:true, completion: nil)
    }
    @IBOutlet weak var sendMessage: UIButton!
    
    @IBOutlet weak var openPhotos: UIView!
    
    @IBOutlet weak var mainScrollView: UIScrollView!
    @IBOutlet weak var usersName: UILabel!
    @IBOutlet weak var aboutMeSection: UITextView!
    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var blurEffect: UIVisualEffectView!
    @IBOutlet weak var backgroundProfilePicture: UIImageView!
    
    @IBOutlet weak var showingProfileViewCount: UILabel!
    
    
    @IBOutlet weak var subScrollView: UIScrollView!
    @IBOutlet weak var secondPhoto: UIImageView!
    @IBOutlet weak var thirdPhoto: UIImageView!
    @IBOutlet weak var fourthPhoto: UIImageView!
    @IBOutlet weak var fifthPhoto: UIImageView!
    @IBOutlet weak var sixthPhoto: UIImageView!
    
    @IBOutlet weak var selectedScrollView: UIScrollView!
    @IBOutlet weak var selectedSecondPhoto: UIImageView!
    @IBOutlet weak var selectedThirdPhoto: UIImageView!
    @IBOutlet weak var selectedFourthPhoto: UIImageView!
    @IBOutlet weak var selectedFifthPhoto: UIImageView!
    @IBOutlet weak var selectedSixthPhoto: UIImageView!
    @IBOutlet weak var dismissSelectedView: UIButton!
    
    @IBOutlet weak var reviewButton: UIButton!
 
    @IBOutlet weak var containerView: UIView!
    var effect:UIVisualEffect!
    
    var writeAReview: WriteAReview?
    
    var currentUserGuiderMode: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //need to set a check of if the currentuser has guidermode set on, if it is set on then put in the message that you can't request a guide when guider mode is on, turn it off and try again
        
        
        
        //"Hang tight now! You will recieve a notification on if they accepted your request or not"
        guard let currentUserUID = FIRAuth.auth()?.currentUser?.uid else{
            return
        }
        
        let checkForGuiderMode = FIRDatabase.database().reference().child("Users").child(currentUserUID)
        checkForGuiderMode.observe(.value, with: {(snapshot) in
            
            guard let dictionary = snapshot.value as? [String: AnyObject] else{
                return
            }
            self.currentUserGuiderMode = dictionary["guiderMode"] as? String
            
            if self.currentUserGuiderMode == "True" {
                self.descriptionRequest.isHidden = true
                self.guideName.isHidden = true
                self.delieveredLabel.isHidden = false
                self.delieveredMessage.isHidden = false
                self.requestDate.isHidden = true
                self.sendRequest.isHidden = true
                self.descriptionOfWhatToDoLabel.isHidden = true
                self.selectDateLabel.isHidden = true
                self.selectedGuideLabel.isHidden = true

                self.delieveredLabel.text = "Whoops"
                self.delieveredMessage.text = "Turn off Guider mode and come back here to not see this message"
            }else{
                
            }
        })
        
        let gesture = UISwipeGestureRecognizer(target: self, action: #selector(closeKeyboard))
    gesture.direction = .down
        requestView.addGestureRecognizer(gesture)
        
        
        
        
        
        delieveredLabel.isHidden = true
        delieveredMessage.isHidden = true
    requestView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(hideKeyboard)))
        sendRequest.addTarget(self, action: #selector(handleSendRequest), for: .touchUpInside)
        visualEffectView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(hideKeyboard)))
        
        mainScrollView.contentSize.height = UIScreen.main.bounds.height * 2.24887556222

        openPhotos.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        
        selectedScrollView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)

        openReviews.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)

        
        testForGettingAllValues()
        profileViewCount()
        
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(animateOut))
        swipeDown.direction = UISwipeGestureRecognizerDirection.down
        
        let secondSwipeDown = UISwipeGestureRecognizer(target: self, action: #selector(animateOut))
        secondSwipeDown.direction = UISwipeGestureRecognizerDirection.down
        
        let thirdSwipeDown = UISwipeGestureRecognizer(target: self, action: #selector(animateOut))
        thirdSwipeDown.direction = UISwipeGestureRecognizerDirection.down
        
        let fourthSwipeDown = UISwipeGestureRecognizer(target: self, action: #selector(animateOut))
        fourthSwipeDown.direction = UISwipeGestureRecognizerDirection.down
        
        let fifthSwipeDown = UISwipeGestureRecognizer(target: self, action: #selector(animateOut))
        fifthSwipeDown.direction = UISwipeGestureRecognizerDirection.down
        
        let doneWithReview = UISwipeGestureRecognizer(target: self, action: #selector(animateOut))
        doneWithReview.direction = UISwipeGestureRecognizerDirection.down
        
        let backupDoneWithReview = UISwipeGestureRecognizer(target: self, action: #selector(animateOut))
        backupDoneWithReview.direction = UISwipeGestureRecognizerDirection.down
        
        

        
        reviewButton.addTarget(self, action: #selector(goToReview), for: .touchUpInside)
        
        sendMessage.addTarget(self, action: #selector(goToMessenger), for: .touchUpInside)
        
        subScrollView.contentSize.width = 1001
        selectedScrollView.contentSize.width = UIScreen.main.bounds.width * 5
        
        
        
        effect = visualEffectView.effect
        visualEffectView.effect = nil
        
        requestGuide.layer.cornerRadius = 14
        requestGuide.layer.masksToBounds = true
       
        requestView.layer.cornerRadius = 14
        
        requestView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width - 5, height: UIScreen.main.bounds.height - 201)
        
        requestGuide.addTarget(self, action: #selector(animateRequestIn), for: .touchUpInside)
        guideName.text = user2?.name
        dismissRequest.addTarget(self, action: #selector(animateRequestOut), for: .touchUpInside)
        descriptionRequest.text = "Here is where you can write all the places you would like to visit, or even just a general idea of what you're looking for"
        descriptionRequest.textColor = UIColor.lightGray
        descriptionRequest.delegate = self
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM dd yyyy"
        let result = formatter.string(from: date)
        requestDate.placeholder = result
        
        
        
        
        dismissSelectedView.addTarget(self, action: #selector(animateOut), for: .touchUpInside)
      
        reviewDismissButton.addTarget(self, action: #selector(animateOut), for: .touchUpInside)
        
        self.profilePicture.clipsToBounds = true;
        self.profilePicture.contentMode = .scaleAspectFill
        self.profilePicture.layer.cornerRadius =  profilePicture.frame.size.height / 2;
        self.profilePicture.layer.cornerRadius = profilePicture.frame.size.width / 2;
        self.profilePicture.layer.borderColor = UIColor.white.cgColor
        self.profilePicture.layer.borderWidth = 2;
        
        
        
        self.backgroundProfilePicture.contentMode = .scaleAspectFill
        self.backgroundProfilePicture.clipsToBounds = true;
        
        
        
        blurEffect.contentMode = .scaleAspectFill
        blurEffect.frame = backgroundProfilePicture.frame
        blurEffect.frame = backgroundProfilePicture.bounds
        
        
        
        self.secondPhoto.clipsToBounds = true;
        self.secondPhoto.contentMode = .scaleAspectFill
        self.secondPhoto.layer.cornerRadius = 0
        self.secondPhoto.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(secondAnimateIn)))
        

        self.thirdPhoto.clipsToBounds = true;
        self.thirdPhoto.contentMode = .scaleAspectFill
        self.thirdPhoto.layer.cornerRadius = 0
        self.thirdPhoto.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(thirdAnimateIn)))
        

        self.fourthPhoto.clipsToBounds = true;
        self.fourthPhoto.contentMode = .scaleAspectFill
        self.fourthPhoto.layer.cornerRadius = 0
        self.fourthPhoto.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(fourthAnimateIn)))
        
        
        
        self.fifthPhoto.clipsToBounds = true;
        self.fifthPhoto.contentMode = .scaleAspectFill
        self.fifthPhoto.layer.cornerRadius = 0
        self.fifthPhoto.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(fifthAnimateIn)))
        
        
        
        self.sixthPhoto.clipsToBounds = true;
        self.sixthPhoto.contentMode = .scaleAspectFill
        self.sixthPhoto.layer.cornerRadius = 0
        self.sixthPhoto.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(sixthAnimateIn)))
        
        self.reviewUserImage.clipsToBounds = true
        self.reviewUserImage.contentMode = .scaleAspectFill
        self.reviewUserImage.layer.cornerRadius = 75 //was 24
        self.reviewUserImage.layer.borderWidth = 3
        self.reviewUserImage.layer.borderColor = UIColor.white.cgColor
        
        
        
        self.selectedSecondPhoto.clipsToBounds = true;
        self.selectedSecondPhoto.contentMode = .scaleAspectFill
        self.selectedSecondPhoto.addGestureRecognizer(secondSwipeDown)
        self.selectedSecondPhoto.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)

        
        self.selectedThirdPhoto.clipsToBounds = true;
        self.selectedThirdPhoto.contentMode = .scaleAspectFill
        self.selectedThirdPhoto.addGestureRecognizer(thirdSwipeDown)
        self.selectedThirdPhoto.frame = CGRect(x: UIScreen.main.bounds.width, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)


        
        
        self.selectedFourthPhoto.clipsToBounds = true;
        self.selectedFourthPhoto.contentMode = .scaleAspectFill
        self.selectedFourthPhoto.addGestureRecognizer(fourthSwipeDown)
        self.selectedFourthPhoto.frame = CGRect(x: UIScreen.main.bounds.width * 2, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)


        self.selectedFifthPhoto.clipsToBounds = true;
        self.selectedFifthPhoto.contentMode = .scaleAspectFill
        self.selectedFifthPhoto.addGestureRecognizer(fifthSwipeDown)
        self.selectedFifthPhoto.frame = CGRect(x: UIScreen.main.bounds.width * 3, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)


        
        
        self.selectedSixthPhoto.clipsToBounds = true;
        self.selectedSixthPhoto.contentMode = .scaleAspectFill
        self.selectedSixthPhoto.addGestureRecognizer(swipeDown)
        self.selectedSixthPhoto.frame = CGRect(x: UIScreen.main.bounds.width * 4, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)


        
        self.starImage1.contentMode = .scaleAspectFit
        //self.starImage1.translatesAutoresizingMaskIntoConstraints = false
        
        self.starImage2.contentMode = .scaleAspectFit
        //self.starImage2.translatesAutoresizingMaskIntoConstraints = false
        
        self.starImage3.contentMode = .scaleAspectFit
        //self.starImage3.translatesAutoresizingMaskIntoConstraints = false
        
        self.starImage4.contentMode = .scaleAspectFit
        //self.starImage4.translatesAutoresizingMaskIntoConstraints = false
        
        self.starImage5.contentMode = .scaleAspectFit
        //self.starImage5.translatesAutoresizingMaskIntoConstraints = false
        self.averageStar1.contentMode = .scaleAspectFit
        self.averageStar2.contentMode = .scaleAspectFit
        self.averageStar3.contentMode = .scaleAspectFit
        self.averageStar4.contentMode = .scaleAspectFit
        self.averageStar5.contentMode = .scaleAspectFit
        
        self.reviewWindow.addGestureRecognizer(doneWithReview)
        self.reviewText.addGestureRecognizer(backupDoneWithReview)
        
        self.reviewWindow.layer.cornerRadius = 34
        if let seconds = review?.timeStamp?.doubleValue{
            let timestampDate = NSDate(timeIntervalSince1970: seconds)
                let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMMM dd YYYY"
            self.reviewTimeStamp.text = dateFormatter.string(from: timestampDate as Date)
            }
        

    
    self.usersName.text = user2?.name
    
    self.aboutMeSection.text = user2?.aboutMe
    
    self.profilePicture.loadImageUsingCachWithUrlString(urlString: (user2?.profileImageUrl)!)
    
    self.backgroundProfilePicture.loadImageUsingCachWithUrlString(urlString: (user2?.profileImageUrl)!)
    
    self.secondPhoto.loadImageUsingCachWithUrlString(urlString: (user2?.secondImageUrl)!)
    
    self.thirdPhoto.loadImageUsingCachWithUrlString(urlString: (user2?.thirdImageUrl)!)
    
    self.fourthPhoto.loadImageUsingCachWithUrlString(urlString: (user2?.fourthImageUrl)!)
    
    self.fifthPhoto.loadImageUsingCachWithUrlString(urlString: (user2?.fifthImageUrl)!)
    
    self.sixthPhoto.loadImageUsingCachWithUrlString(urlString: (user2?.sixthImageUrl)!)
    
    self.selectedSecondPhoto.loadImageUsingCachWithUrlString(urlString: (user2?.secondImageUrl)!)
    
    self.selectedThirdPhoto.loadImageUsingCachWithUrlString(urlString: (user2?.thirdImageUrl)!)
    
    self.selectedFourthPhoto.loadImageUsingCachWithUrlString(urlString: (user2?.fourthImageUrl)!)
    
    self.selectedFifthPhoto.loadImageUsingCachWithUrlString(urlString: (user2?.fifthImageUrl)!)
    
    self.selectedSixthPhoto.loadImageUsingCachWithUrlString(urlString: (user2?.sixthImageUrl)!)
       
        self.usersMainLocation.text = user2?.firstLocation
        if self.usersMainLocation.text == ""{
            self.usersMainLocation.text = "No selected location"
        }

    
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray{
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty{
            textView.text = "Here is where you can write all the places you would like to visit, or even just a general idea of what you're looking for"
            textView.textColor = UIColor.lightGray
        }
    }
    func closeKeyboard(){
        view.endEditing(true)
    }

    func getUsersAge(){

                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "MMMM dd yyyy"
                var birthday: String?
                birthday = user2?.birthday
                
                let usersBirthday = dateFormatter.date(from: birthday!)
                if usersBirthday == nil{
                    self.usersAge.text = "0"
                }else{
                    let now = Date()
                    let calander = Calendar.current
                    let ageComponents = calander.dateComponents([.year], from: usersBirthday!, to: now)
                    let age = ageComponents.year!
                    print("This is the age",age)
                    self.usersAge.text = String(age)
                    
                    
                    // need to refine this to open up to date and month
                }
            }
    

    func animateReviewIn() {
        self.view.addSubview(openReviews)
        openReviews.center = self.view.center
        openReviews.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
        openReviews.alpha = 0
        
        UIView.animate(withDuration: 0.4) {
            
        }
    }
    func hideKeyboard(){
        view.endEditing(true)
    }
    
    func secondAnimateIn() {
        self.view.addSubview(openPhotos)
       
        openPhotos.center = self.view.center
        openPhotos.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
        openPhotos.alpha = 0
        
        UIView.animate(withDuration: 0.4) {
            self.visualEffectView.effect = self.effect
            self.openPhotos.alpha = 1
            self.openPhotos.transform = CGAffineTransform.identity
            
            self.selectedScrollView.contentOffset = CGPoint(x: 0, y: 0)
        }
    }
    func thirdAnimateIn() {
        self.view.addSubview(openPhotos)
        openPhotos.center = self.view.center
        openPhotos.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
        openPhotos.alpha = 0
        
        UIView.animate(withDuration: 0.4) {
            self.visualEffectView.effect = self.effect
            self.openPhotos.alpha = 1
            self.openPhotos.transform = CGAffineTransform.identity
            
            
            self.selectedScrollView.contentOffset = CGPoint(x: UIScreen.main.bounds.width , y: 0)
        }
    }
    func fourthAnimateIn() {
        self.view.addSubview(openPhotos)
        openPhotos.center = self.view.center
        openPhotos.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
        openPhotos.alpha = 0
        
        UIView.animate(withDuration: 0.4) {
            self.visualEffectView.effect = self.effect
            self.openPhotos.alpha = 1
            self.openPhotos.transform = CGAffineTransform.identity
            
            
            self.selectedScrollView.contentOffset = CGPoint(x: UIScreen.main.bounds.width * 2, y: 0)
        }
    }
    func fifthAnimateIn() {
        self.view.addSubview(openPhotos)
        openPhotos.center = self.view.center
        openPhotos.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
        openPhotos.alpha = 0
        
        UIView.animate(withDuration: 0.4) {
            self.visualEffectView.effect = self.effect
            self.openPhotos.alpha = 1
            self.openPhotos.transform = CGAffineTransform.identity
            
            
            self.selectedScrollView.contentOffset = CGPoint(x: UIScreen.main.bounds.width * 3, y: 0)
        }
    }
    func sixthAnimateIn() {
        self.view.addSubview(openPhotos)
        openPhotos.center = self.view.center
        openPhotos.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
        openPhotos.alpha = 0
        
        UIView.animate(withDuration: 0.4) {
            self.visualEffectView.effect = self.effect
            self.openPhotos.alpha = 1
            self.openPhotos.transform = CGAffineTransform.identity
            
            self.selectedScrollView.contentOffset = CGPoint(x: UIScreen.main.bounds.width * 4, y: 0)
            
            
        }
    }
    func animateRequestIn() {
        self.view.addSubview(requestView)
        self.requestGuide.isHidden = true
        requestView.center = self.view.center
        requestView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
        requestView.alpha = 0
        
        UIView.animate(withDuration: 0.4) {
            self.visualEffectView.effect = self.effect
            self.requestView.alpha = 1
            self.requestView.transform = CGAffineTransform.identity
        }
    }
    func animateRequestOut(){
        UIView.animate(withDuration: 0.3, animations: {
            self.requestGuide.isHidden = false
            self.requestView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
            self.requestView.alpha = 0
            self.visualEffectView.effect = nil
        }) { (success:Bool) in
            self.requestView.removeFromSuperview()
        }
    }
    func expandingTheReviews(){
        self.view.addSubview(openReviews)
        reviewWindow.center = self.view.center
        reviewWindow.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
        reviewWindow.alpha = 0
        
    
        UIView.animate(withDuration: 0.4) {
        self.visualEffectView.effect = self.effect
        self.reviewWindow.alpha = 1
        self.reviewWindow.transform = CGAffineTransform.identity
        }
    }
    
    func animateOut () {
        UIView.animate(withDuration: 0.3, animations: {
            self.openPhotos.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
            self.openPhotos.alpha = 0
            
            self.reviewWindow.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
            self.reviewWindow.alpha = 0
            
            self.visualEffectView.effect = nil
            //self.visualEffectForReview.effect = nil
            
        }) { (success:Bool) in
            self.openPhotos.removeFromSuperview()
            self.openReviews.removeFromSuperview()
        }
    }
    
    func goToReview(){
        performSegue(withIdentifier: "writeAReview", sender: self)
    }
    func goToMessenger(){
        performSegue(withIdentifier: "writeAMessage", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "writeAReview" {
            let viewController = segue.destination as! WriteAReview
            viewController.user3 = user2
            
        }
        if segue.identifier == "showTableView"{
            let viewController = segue.destination as! loadingTableReview
            viewController.selectedUsersProfile = user2
           
        }
    
        if segue.identifier == "writeAMessage"{
            let viewController = segue.destination as! MessagesController
            viewController.messageUser = user2
        }
    }
var reviewArray = [String]()
    func testForGettingAllValues(){
        let uid = user2?.id
        let ref = FIRDatabase.database().reference().child("userRating").child(uid!)
        ref.queryOrdered(byChild: "ratingNumber").observe(.value, with: {(snapshot) in
            if snapshot.exists(){
                if let values = snapshot.value as? [String: AnyObject]{
                    for reviews in values {
                        if let userReviews = reviews.value["ratingNumber"] as? String{
                            self.reviewArray.append(userReviews)
                            let ratingSum = self.reviewArray.flatMap {Double($0)}.reduce(0,+)
                            let reviewCount = Double(self.reviewArray.count)
                            let sumOfBoth = (ratingSum / reviewCount)
                            let roundedSum = (round(100*sumOfBoth)/100)
                            let sumTextArray = [(String(roundedSum)),"/5"]
                            let sumJoined = sumTextArray.joined(separator: "")
                            let textArray = ["Based on ",(String(self.reviewArray.count))," reviews"]
                            let joined = textArray.joined(separator: "")
                            self.averageStars.text = joined
                            self.uploadRatingSum(stringToUpload: sumJoined)
                            
                            
                                if let rating = Optional(sumOfBoth) {
                                
                                    self.averageStar1.image = rating < 0.5 ? nil : rating < 1 ? self.half : self.full
                                    self.averageStar2.image = rating < 1.5 ? nil : rating < 2 ? self.half : self.full
                                    self.averageStar3.image = rating < 2.5 ? nil : rating < 3 ? self.half : self.full
                                    self.averageStar4.image = rating < 3.5 ? nil : rating < 4 ? self.half : self.full
                                    self.averageStar5.image = rating < 4.5 ? nil : rating < 5 ? self.half : self.full
                                    
                                }

                            }
                        }
                    }
                }
            })
        }
    func uploadRatingSum(stringToUpload:String){
        guard let uid = user2?.id else{
            return
        }
        let ref = FIRDatabase.database().reference().child("Users").child(uid)
        ref.updateChildValues(["averageRating" : stringToUpload ])
    }
   
    func profileViewCount(){
        let uid = FIRAuth.auth()?.currentUser?.uid
                let profileUid = user2?.id
                        if uid == profileUid {
                        let userRef = FIRDatabase.database().reference().child("Users").child(profileUid!).child("profileView")
                            userRef.observeSingleEvent(of: .value, with: { snapshot in
                            
                            let userValString = snapshot.value
                                    let userNumber = userValString as! NSNumber
                                    let userValue = userNumber.intValue
                                        let userArray = [(String(userValue))," profile views"]
                                let userJoined = userArray.joined(separator: "")
                                self.showingProfileViewCount.text = userJoined
                                
                            
                            })
                        
                        }else{
                                let ref = FIRDatabase.database().reference().child("Users").child(profileUid!).child("profileView")
                                        ref.observeSingleEvent(of: .value, with: { snapshot in
                                            
                                            let valString = snapshot.value
                                                let number = valString as! NSNumber
                                                    var value = number.intValue
                                                        value = value + 1
                                                        ref.setValue(value)
                                                            let arrayForBeingUsed = [(String(value))," profile views"]
                                            let arrayJoined = arrayForBeingUsed.joined(separator: "")
                                            self.showingProfileViewCount.text = arrayJoined
                                            
            })
        }
    }
    func removePicker(){
        hideKeyboard()
    }
    func datePickerValueChanged(sender:UIDatePicker){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM dd yyyy"
        self.requestDate.text = dateFormatter.string(from: sender.date)
        }
    func handleSendRequest(){
        let ref = FIRDatabase.database().reference().child("requests")
        let childRef = ref.childByAutoId()
        let toIdRequest = user2?.id
        let fromIdRequest = FIRAuth.auth()?.currentUser?.uid
        let dateToSend = requestDate.text
        let descriptionOfTrip = descriptionRequest.text
        let status = "pending"
        
        let values = ["fromId":fromIdRequest as Any,"toId":toIdRequest as Any,"descriptionOfTrip":descriptionOfTrip as Any,"date":dateToSend as Any,"status":status] as [String: Any]
        childRef.updateChildValues(values, withCompletionBlock: {(error, ref) in
            if error != nil{
                self.delieveredMessage.text = error?.localizedDescription
                return
            }
            let recieverOfRequest = FIRDatabase.database().reference().child("user-requests").child(toIdRequest!)
            let requestId = childRef.key
            recieverOfRequest.updateChildValues([requestId:1])
        })
        descriptionRequest.isHidden = true
        guideName.isHidden = true
        delieveredLabel.isHidden = false
        delieveredMessage.isHidden = false
        requestDate.isHidden = true
        sendRequest.isHidden = true
        descriptionOfWhatToDoLabel.isHidden = true
        selectDateLabel.isHidden = true
        selectedGuideLabel.isHidden = true
        
    }
}
