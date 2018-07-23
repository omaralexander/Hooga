//
//  CompletedProfile.swift
//  Hooga
//
//  Created by Omar Abbas on 12/25/16.
//  Copyright © 2016 Omar Abbas. All rights reserved.
//

import UIKit
import Firebase
import CoreImage

class CompletedProfile: UIViewController{
    
    override var prefersStatusBarHidden: Bool {
        return true
    }

    
    @IBOutlet weak var visualEffectView: UIVisualEffectView!
   
    @IBAction func dismissButton(_ sender: Any) {
        self.dismiss(animated:true, completion: nil)
    }
    @IBOutlet weak var openPhotos: UIView!
    
    @IBOutlet weak var mainScrollView: UIScrollView!
    @IBOutlet weak var usersName: UILabel!
    
    @IBOutlet weak var aboutMeSection: UITextView!
    
    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var blurEffect: UIVisualEffectView!
    @IBOutlet weak var backgroundProfilePicture: UIImageView!
    @IBOutlet weak var editButton: UIButton!
 
    
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

    @IBOutlet weak var userMainLocation: UILabel!
    @IBOutlet weak var userAge: UILabel!

    
  
    
    var effect:UIVisualEffect!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        openPhotos.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        
        selectedScrollView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        
        
        
        
        getUsersAge()
        
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
       
        
        
        mainScrollView.contentSize.height = 1500
        subScrollView.contentSize.width = 1001
        selectedScrollView.contentSize.width = UIScreen.main.bounds.width * 5
    
        
        
        effect = visualEffectView.effect
        visualEffectView.effect = nil
     
        
        
        dismissSelectedView.addTarget(self, action: #selector(animateOut), for: .touchUpInside)
        
        
        
        let uid = FIRAuth.auth()?.currentUser?.uid
        self.editButton.layer.cornerRadius = 24
    
        
        
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
        
        
        
        
        FIRDatabase.database().reference().child("Users").child(uid!).observe(.value, with: {(snapshot) in if let dictionary = snapshot.value as? [String: AnyObject]
        {
                self.usersName.text = dictionary["name"] as? String
            
                self.aboutMeSection.text = dictionary["aboutMe"] as? String
            
                self.userMainLocation.text = dictionary["firstLocation"] as? String
                if self.userMainLocation.text == ""{
                    self.userMainLocation.text = "No selected location"
            }
                self.profilePicture.loadImageUsingCachWithUrlString(urlString: dictionary["profileImageUrl"] as! String)
            
                self.backgroundProfilePicture.loadImageUsingCachWithUrlString(urlString:dictionary["profileImageUrl"]as! String)
           
                self.secondPhoto.loadImageUsingCachWithUrlString(urlString: dictionary["secondImageUrl"] as! String)
            
                self.thirdPhoto.loadImageUsingCachWithUrlString(urlString: dictionary["thirdImageUrl"]as! String)
            
                self.fourthPhoto.loadImageUsingCachWithUrlString(urlString: dictionary["fourthImageUrl"]as! String)
            
                self.fifthPhoto.loadImageUsingCachWithUrlString(urlString: dictionary["fifthImageUrl"] as! String)
           
                self.sixthPhoto.loadImageUsingCachWithUrlString(urlString: dictionary["sixthImageUrl"]as! String)
                self.selectedSecondPhoto.loadImageUsingCachWithUrlString(urlString: dictionary["secondImageUrl"] as! String)
                self.selectedThirdPhoto.loadImageUsingCachWithUrlString(urlString: dictionary["thirdImageUrl"] as! String)
                self.selectedFourthPhoto.loadImageUsingCachWithUrlString(urlString: dictionary["fourthImageUrl"] as! String)
                self.selectedFifthPhoto.loadImageUsingCachWithUrlString(urlString: dictionary["fifthImageUrl"] as! String)
                self.selectedSixthPhoto.loadImageUsingCachWithUrlString(urlString: dictionary["sixthImageUrl"] as! String)
            }
            
        }, withCancel: nil)
        
    }
    
    func getUsersAge(){
        let user = FIRAuth.auth()?.currentUser
        
        guard let uid = user?.uid else{
            return
        }
        let ref = FIRDatabase.database().reference().child("Users").child(uid)
        ref.observe(.value, with: { snapshot in
            if let dictionary = snapshot.value as? [String: AnyObject] {
                
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMMM dd yyyy"
            var birthday: String?
            birthday = dictionary["birthday"] as? String

            let usersBirthday = dateFormatter.date(from: birthday!)
                if usersBirthday == nil{
                    self.userAge.text = "0"
                }else{
            let now = Date()
            let calander = Calendar.current
            let ageComponents = calander.dateComponents([.year], from: usersBirthday!, to: now)
            let age = ageComponents.year!
            print("This is the age",age)
            self.userAge.text = String(age)
            
            
            // need to refine this to open up to date and month
                }
            }
        })
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
   

    func animateOut () {
        UIView.animate(withDuration: 0.3, animations: {
            self.openPhotos.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
            self.openPhotos.alpha = 0
            
            self.visualEffectView.effect = nil
            
        }) { (success:Bool) in
            self.openPhotos.removeFromSuperview()
            
        }
    }
}
