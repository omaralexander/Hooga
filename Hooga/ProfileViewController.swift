//
//  ProfileViewController.swift
//  Hooga
//
//  Created by Omar Abbas on 12/13/16.
//  Copyright © 2016 Omar Abbas. All rights reserved.
//

import UIKit
import Firebase
import FBSDKLoginKit

class ProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate,UIPickerViewDataSource,UIPickerViewDelegate {
    func resizeImage(image: UIImage, newWidth: CGFloat) -> UIImage? {
        
        let scale = newWidth / image.size.width
        let newHeight = image.size.height * scale
        UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
        image.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
    
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .default
    }

 var imagePicked = 0
 var firstPickerView = UIPickerView()
 var secondPickerView = UIPickerView()
var thirdPickerView = UIPickerView()
    
    @IBAction func presentFirstPicker(_ sender: UITextField) {
        firstPickerView.backgroundColor = UIColor.white
        sender.inputView = firstPickerView
        
        
    }
    
    @IBOutlet weak var secondLocation: UITextField!
    
    @IBOutlet var finishedEditingView: UIView!
    
    @IBOutlet weak var doneButton: UIButton!
    
    @IBOutlet weak var visualEffectView: UIVisualEffectView!
    
    @IBOutlet var mainView: UIView!
    
    @IBAction func secondLocation(_ sender: UITextField) {
        secondPickerView.backgroundColor = UIColor.white
        sender.inputView = secondPickerView
    }
    
    
    @IBOutlet weak var thirdLocation: UITextField!
    
    @IBAction func thirdLocation(_ sender: UITextField) {
        thirdPickerView.backgroundColor = UIColor.white
        sender.inputView = thirdPickerView
    }
    
    
    
    
    
    
    
    
    
    
    @IBAction func uploadProfilePicture(_ sender: UIButton) {
        handleSelectProfileImageView()
        imagePicked = sender.tag
    }
    @IBAction func uploadSecondImage(_ sender: UIButton) {
        handleSelectProfileImageView()
        imagePicked = sender.tag
    }
    @IBAction func uploadThirdImage(_ sender: UIButton) {
        handleSelectProfileImageView()
        imagePicked = sender.tag
    }
    @IBAction func uploadFourthImage(_ sender: UIButton) {
        handleSelectProfileImageView()
        imagePicked = sender.tag
    }
    @IBAction func uploadFifthImage(_ sender: UIButton) {
        handleSelectProfileImageView()
        imagePicked = sender.tag
    }
    @IBAction func uploadSixthImage(_ sender: UIButton) {
        handleSelectProfileImageView()
        imagePicked = sender.tag
    }

    @IBOutlet weak var finishedEditing: UIButton!
    
    @IBOutlet weak var firstLocation: UITextField!
    @IBOutlet weak var usersName: UITextField!
   
    @IBOutlet weak var usersEmail: UITextField!
  
    @IBOutlet weak var aboutMeSection: UITextView!
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var secondPhoto: UIImageView!
    
    @IBOutlet weak var thirdPhoto: UIImageView!
    
    @IBOutlet weak var fourthPhoto: UIImageView!
    
    @IBOutlet weak var fifthPhoto: UIImageView!
    
    @IBOutlet weak var sixthPhoto: UIImageView!
    
    @IBOutlet weak var mainScroll: UIScrollView!
    
    @IBAction func dismissButton(_ sender: Any) {
        self.dismiss(animated:true, completion: nil)
    }
    @IBAction func userBirthdayEditingBegin(_ sender: UITextField) {
        let datePickerView:UIDatePicker = UIDatePicker()
        datePickerView.backgroundColor = UIColor.white
        
        datePickerView.datePickerMode = UIDatePickerMode.date
        sender.inputView = datePickerView
        datePickerView.addTarget(self, action: #selector(self.datePickerValueChanged), for: UIControlEvents.valueChanged)
    }
    
    @IBOutlet weak var usersBirthday: UITextField!
   

    @IBAction func removeProfilePicture(_ sender: Any) {

            let uid = FIRAuth.auth()?.currentUser?.uid
            FIRDatabase.database().reference().child("Users").child(uid!).updateChildValues(["profileImageUrl": "https://firebasestorage.googleapis.com/v0/b/hooga-6dfb9.appspot.com/o/Group%2011%20%402x%20copy.png?alt=media&token=b0fbbf94-c8f6-44d0-af55-7695d0b44f3e"])
    
                imageView.image = UIImage(named:"Rectangle14")
    }
    @IBAction func removeSecondPicture(_ sender: Any) {
        let uid = FIRAuth.auth()?.currentUser?.uid
       
        FIRDatabase.database().reference().child("Users").child(uid!).updateChildValues(["secondImageUrl": "https://firebasestorage.googleapis.com/v0/b/hooga-6dfb9.appspot.com/o/Group%2011%20%402x%20copy.png?alt=media&token=b0fbbf94-c8f6-44d0-af55-7695d0b44f3e"])
        
        secondPhoto.image = UIImage(named:"Rectangle14")
        
    }
    @IBAction func removeThirdPicture(_ sender: Any) {
        let uid = FIRAuth.auth()?.currentUser?.uid
        FIRDatabase.database().reference().child("Users").child(uid!).updateChildValues(["thirdImageUrl": "https://firebasestorage.googleapis.com/v0/b/hooga-6dfb9.appspot.com/o/Group%2011%20%402x%20copy.png?alt=media&token=b0fbbf94-c8f6-44d0-af55-7695d0b44f3e"])
        
        thirdPhoto.image = UIImage(named:"Rectangle14")
    }
    @IBAction func removeFourthPicture(_ sender: Any) {
        let uid = FIRAuth.auth()?.currentUser?.uid
        FIRDatabase.database().reference().child("Users").child(uid!).updateChildValues(["fourthImageUrl": "https://firebasestorage.googleapis.com/v0/b/hooga-6dfb9.appspot.com/o/Group%2011%20%402x%20copy.png?alt=media&token=b0fbbf94-c8f6-44d0-af55-7695d0b44f3e"])
        
        fourthPhoto.image = UIImage(named:"Rectangle14")
    }
    @IBAction func removeFifthPicture(_ sender: Any) {
        let uid = FIRAuth.auth()?.currentUser?.uid
        FIRDatabase.database().reference().child("Users").child(uid!).updateChildValues(["fifthImageUrl": "https://firebasestorage.googleapis.com/v0/b/hooga-6dfb9.appspot.com/o/Group%2011%20%402x%20copy.png?alt=media&token=b0fbbf94-c8f6-44d0-af55-7695d0b44f3e"])
        
        fifthPhoto.image = UIImage(named:"Rectangle14")
    }
    @IBAction func removeSixthPicture(_ sender: Any) {
        let uid = FIRAuth.auth()?.currentUser?.uid
        FIRDatabase.database().reference().child("Users").child(uid!).updateChildValues(["sixthImageUrl": "https://firebasestorage.googleapis.com/v0/b/hooga-6dfb9.appspot.com/o/Group%2011%20%402x%20copy.png?alt=media&token=b0fbbf94-c8f6-44d0-af55-7695d0b44f3e"])
        
            sixthPhoto.image = UIImage(named:"Rectangle14")
    }
    var filteredCandies = [Locations]()
    var pickerData = [
        //MANHATTAN LOCATIONS
        Locations(Borough: "Manhattan", Neighborhood: "SoHo"),
        Locations(Borough: "Manhattan", Neighborhood: "Midtown"),
        Locations(Borough: "Manhattan", Neighborhood: "Chelsea"),
        Locations(Borough: "Manhattan", Neighborhood: "Upper East Side"),
        Locations(Borough: "Manhattan", Neighborhood: "Lower East Side"),
        Locations(Borough: "Manhattan", Neighborhood: "East Village"),
        Locations(Borough: "Manhattan", Neighborhood: "Upper West Side"),
        Locations(Borough: "Manhattan", Neighborhood: "Greenwich Village"),
        Locations(Borough: "Manhattan", Neighborhood: "Tribeca"),
        Locations(Borough: "Manhattan", Neighborhood: "Lower Manhattan"),
        Locations(Borough: "Manhattan", Neighborhood: "Chinatown"),
        Locations(Borough: "Manhattan", Neighborhood: "Harlem"),
        Locations(Borough: "Manhattan", Neighborhood: "Financial District"),
        Locations(Borough: "Manhattan", Neighborhood: "Hell's Kitchen"),
        Locations(Borough: "Manhattan", Neighborhood: "Little Italy"),
        Locations(Borough: "Manhattan", Neighborhood: "Flatiron District"),
        Locations(Borough: "Manhattan", Neighborhood: "Theatre District"),
        Locations(Borough: "Manhattan", Neighborhood: "Gramercy Park"),
        Locations(Borough: "Manhattan", Neighborhood: "West Village"),
        Locations(Borough: "Manhattan", Neighborhood: "Murray Hill"),
        Locations(Borough: "Manhattan", Neighborhood: "NoLita"),
        Locations(Borough: "Manhattan", Neighborhood: "Upper Manhattan"),
        Locations(Borough: "Manhattan", Neighborhood: "Union Square"),
        Locations(Borough: "Manhattan", Neighborhood: "Battery Park City"),
        Locations(Borough: "Manhattan", Neighborhood: "Meatpacking District"),
        Locations(Borough: "Manhattan", Neighborhood: "Turtle Bay"),
        Locations(Borough: "Manhattan", Neighborhood: "Washington Heights"),
        Locations(Borough: "Manhattan", Neighborhood: "NoHo"),
        Locations(Borough: "Manhattan", Neighborhood: "Inwood"),
        Locations(Borough: "Manhattan", Neighborhood: "Garment District"),
        Locations(Borough: "Manhattan", Neighborhood: "East Harlem"),
        Locations(Borough: "Manhattan", Neighborhood: "Kips Bay"),
        Locations(Borough: "Manhattan", Neighborhood: "Morningside Heights"),
        Locations(Borough: "Manhattan", Neighborhood: "Yorkville"),
        Locations(Borough: "Manhattan", Neighborhood: "Rockefeller Center"),
        
        //BROOKLYN LOCATIONS
        Locations(Borough: "Brooklyn", Neighborhood: "Williamsburg"),
        Locations(Borough: "Brooklyn", Neighborhood: "Park Slope"),
        Locations(Borough: "Brooklyn", Neighborhood: "Bushwick"),
        Locations(Borough: "Brooklyn", Neighborhood: "Greenpoint"),
        Locations(Borough: "Brooklyn", Neighborhood: "Bedford-Stuyvesant"),
        Locations(Borough: "Brooklyn", Neighborhood: "Fort Greene"),
        Locations(Borough: "Brooklyn", Neighborhood: "Bay Ridge"),
        Locations(Borough: "Brooklyn", Neighborhood: "Prospect Heights"),
        Locations(Borough: "Brooklyn", Neighborhood: "Carroll Gardens"),
        Locations(Borough: "Brooklyn", Neighborhood: "Clinton Hill"),
        Locations(Borough: "Brooklyn", Neighborhood: "Brooklyn Heights"),
        Locations(Borough: "Brooklyn", Neighborhood: "DUMBO"),
        Locations(Borough: "Brooklyn", Neighborhood: "Cobble Hill"),
        Locations(Borough: "Brooklyn", Neighborhood: "Crown Heights"),
        Locations(Borough: "Brooklyn", Neighborhood: "Gowanus"),
        Locations(Borough: "Brooklyn", Neighborhood: "Boerum Hill"),
        Locations(Borough: "Brooklyn", Neighborhood: "Red Hook"),
        Locations(Borough: "Brooklyn", Neighborhood: "Downtown Brooklyn"),
        Locations(Borough: "Brooklyn", Neighborhood: "Flatbush"),
        Locations(Borough: "Brooklyn", Neighborhood: "Sunset Park"),
        Locations(Borough: "Brooklyn", Neighborhood: "Windsor Terrace"),
        Locations(Borough: "Brooklyn", Neighborhood: "East New York"),
        Locations(Borough: "Brooklyn", Neighborhood: "Prospect - Lefferts Gardens"),
        Locations(Borough: "Brooklyn", Neighborhood: "Kensington"),
        Locations(Borough: "Brooklyn", Neighborhood: "Brighton Beach"),
        Locations(Borough: "Brooklyn", Neighborhood: "Bensonhurst"),
        Locations(Borough: "Brooklyn", Neighborhood: "Vinegar Hill"),
        Locations(Borough: "Brooklyn", Neighborhood: "Gravesend"),
        
        
        //QUEENS LOCATIONS
        Locations(Borough: "Queens", Neighborhood: "Bayside"),
        Locations(Borough: "Queens", Neighborhood: "Glendale"),
        Locations(Borough: "Queens", Neighborhood: "Astoria"),
        Locations(Borough: "Queens", Neighborhood: "Forest Hills"),
        Locations(Borough: "Queens", Neighborhood: "Jamaica Estates"),
        Locations(Borough: "Queens", Neighborhood: "Ridgewood"),
        Locations(Borough: "Queens", Neighborhood: "Sunnyside"),
        Locations(Borough: "Queens", Neighborhood: "Maspeth"),
        Locations(Borough: "Queens", Neighborhood: "Belle Harbor"),
        Locations(Borough: "Queens", Neighborhood: "College Point"),
        Locations(Borough: "Queens", Neighborhood: "Long Island City"),
        Locations(Borough: "Queens", Neighborhood: "Bellerose"),
        Locations(Borough: "Queens", Neighborhood: "Kew Gardens"),
        Locations(Borough: "Queens", Neighborhood: "Woodhaven"),
        Locations(Borough: "Queens", Neighborhood: "Richmond Hill"),
        Locations(Borough: "Queens", Neighborhood: "Whitestone"),
        Locations(Borough: "Queens", Neighborhood: "Laurelton"),
        Locations(Borough: "Queens", Neighborhood: "Howard Beach"),
        Locations(Borough: "Queens", Neighborhood: "Hunters Point"),
        Locations(Borough: "Queens", Neighborhood: "Floral Park"),
        Locations(Borough: "Queens", Neighborhood: "Neponsit Queens"),
        Locations(Borough: "Queens", Neighborhood: "Middle Village"),
        Locations(Borough: "Queens", Neighborhood: "Fresh Meadows"),
        Locations(Borough: "Queens", Neighborhood: "Douglaston"),
        Locations(Borough: "Queens", Neighborhood: "Auburndale"),
        Locations(Borough: "Queens", Neighborhood: "Queens Village"),
        Locations(Borough: "Queens", Neighborhood: "Forest Park"),
        Locations(Borough: "Queens", Neighborhood: "Jackson Heights"),
        Locations(Borough: "Queens", Neighborhood: "Woodside"),
        Locations(Borough: "Queens", Neighborhood: "Corona"),
        Locations(Borough: "Queens", Neighborhood: "Rego Park"),
        Locations(Borough: "Queens", Neighborhood: "Flushing"),
        Locations(Borough: "Queens", Neighborhood: "Jamaica"),
        
        //Bronx locations
        Locations(Borough: "Bronx", Neighborhood: "Riverdale"),
        Locations(Borough: "Bronx", Neighborhood: "Fordham"),
        Locations(Borough: "Bronx", Neighborhood: "Bedford Park"),
        Locations(Borough: "Bronx", Neighborhood: "Spuyten Duyvil"),
        Locations(Borough: "Bronx", Neighborhood: "Mott Haven"),
        Locations(Borough: "Bronx", Neighborhood: "Belmont"),
        Locations(Borough: "Bronx", Neighborhood: "Pelham Parkway"),
        Locations(Borough: "Bronx", Neighborhood: "Arthur Avenue"),
        Locations(Borough: "Bronx", Neighborhood: "Throggs Neck"),
        Locations(Borough: "Bronx", Neighborhood: "Woodlawn"),
        Locations(Borough: "Bronx", Neighborhood: "Kingsbridge"),
        Locations(Borough: "Bronx", Neighborhood: "Highbridge"),
        Locations(Borough: "Bronx", Neighborhood: "Country Club"),
        Locations(Borough: "Bronx", Neighborhood: "Upper Manhattan"),
        Locations(Borough: "Bronx", Neighborhood: "Morris Park"),
        Locations(Borough: "Bronx", Neighborhood: "University Heights"),
        Locations(Borough: "Bronx", Neighborhood: "Pelham Gardens"),
        Locations(Borough: "Bronx", Neighborhood: "Pelham Bay"),
        Locations(Borough: "Bronx", Neighborhood: "Morris Heights"),
        Locations(Borough: "Bronx", Neighborhood: "Fieldston"),
        Locations(Borough: "Bronx", Neighborhood: "Clason Point"),
        Locations(Borough: "Bronx", Neighborhood: "Hunts Point"),
        Locations(Borough: "Bronx", Neighborhood: "Morrisania"),
        Locations(Borough: "Bronx", Neighborhood: "Parkchester"),
        Locations(Borough: "Bronx", Neighborhood: "Castle Hill"),
        Locations(Borough: "Bronx", Neighborhood: "Port Morris"),
        Locations(Borough: "Bronx", Neighborhood: "Tremont"),
        Locations(Borough: "Bronx", Neighborhood: "Williamsbridge"),
        Locations(Borough: "Bronx", Neighborhood: "Norwood"),
        Locations(Borough: "Bronx", Neighborhood: "Van Nest"),
        Locations(Borough: "Bronx", Neighborhood: "Wakefield"),
        Locations(Borough: "Bronx", Neighborhood: "Longwood"),
        Locations(Borough: "Bronx", Neighborhood: "Soundview"),
        Locations(Borough: "Bronx", Neighborhood: "Melrose"),
        Locations(Borough: "Bronx", Neighborhood: "Marble"),
        Locations(Borough: "Bronx", Neighborhood: "Baychester"),
        Locations(Borough: "Bronx", Neighborhood: "East Morrisania"),
        Locations(Borough: "Bronx", Neighborhood: "West Farms"),
        Locations(Borough: "Bronx", Neighborhood: "Eastchester"),
        Locations(Borough: "Bronx", Neighborhood: "Co-op City"),
        Locations(Borough: "Bronx", Neighborhood: "The Hub"),
        Locations(Borough: "Bronx", Neighborhood: "Allerton"),
        Locations(Borough: "Bronx", Neighborhood: "East Tremont"),
        
        //staten island locations
        Locations(Borough: "Staten Island", Neighborhood: "St. George"),
        Locations(Borough: "Staten Island", Neighborhood: "Great Kills"),
        Locations(Borough: "Staten Island", Neighborhood: "West New Brighton"),
        Locations(Borough: "Staten Island", Neighborhood: "Todt Hill"),
        Locations(Borough: "Staten Island", Neighborhood: "Tottenville"),
        Locations(Borough: "Staten Island", Neighborhood: "Port Richmond"),
        Locations(Borough: "Staten Island", Neighborhood: "New Springville"),
        Locations(Borough: "Staten Island", Neighborhood: "Stapleton"),
        Locations(Borough: "Staten Island", Neighborhood: "Westerleigh"),
        Locations(Borough: "Staten Island", Neighborhood: "Huguenot"),
        Locations(Borough: "Staten Island", Neighborhood: "Eltingville"),
        Locations(Borough: "Staten Island", Neighborhood: "New Brighton"),
        Locations(Borough: "Staten Island", Neighborhood: "Randall Manor"),
        Locations(Borough: "Staten Island", Neighborhood: "Emerson Hill"),
        Locations(Borough: "Staten Island", Neighborhood: "Annadale"),
        Locations(Borough: "Staten Island", Neighborhood: "Rosebank"),
        Locations(Borough: "Staten Island", Neighborhood: "Oakwood"),
        Locations(Borough: "Staten Island", Neighborhood: "Castleton Corners"),
        Locations(Borough: "Staten Island", Neighborhood: "South Beach"),
        Locations(Borough: "Staten Island", Neighborhood: "Rossville"),
        Locations(Borough: "Staten Island", Neighborhood: "New Dorp"),
        Locations(Borough: "Staten Island", Neighborhood: "Arrochar"),
        Locations(Borough: "Staten Island", Neighborhood: "Midland Beach"),
        Locations(Borough: "Staten Island", Neighborhood: "Dongan Hills"),
        Locations(Borough: "Staten Island", Neighborhood: "Grymes Hill"),
        Locations(Borough: "Staten Island", Neighborhood: "Tompkinsville"),
        Locations(Borough: "Staten Island", Neighborhood: "Graniteville"),
        Locations(Borough: "Staten Island", Neighborhood: "Arden Heights"),
        Locations(Borough: "Staten Island", Neighborhood: "Richmondtown"),
        Locations(Borough: "Staten Island", Neighborhood: "Lighthouse Hill"),
        Locations(Borough: "Staten Island", Neighborhood: "Silver Lake"),
        Locations(Borough: "Staten Island", Neighborhood: "Grasmere"),
        Locations(Borough: "Staten Island", Neighborhood: "Mariners Harbor"),
        Locations(Borough: "Staten Island", Neighborhood: "Clifton"),
        Locations(Borough: "Staten Island", Neighborhood: "Woodrow"),
        Locations(Borough: "Staten Island", Neighborhood: "Grant City"),
        Locations(Borough: "Staten Island", Neighborhood: "Pleasant Plains"),
        Locations(Borough: "Staten Island", Neighborhood: "Ward Hill"),
        Locations(Borough: "Staten Island", Neighborhood: "Fort Wadsworth"),
        Locations(Borough: "Staten Island", Neighborhood: "Richmond Valley"),
        Locations(Borough: "Staten Island", Neighborhood: "Greenridge"),
        Locations(Borough: "Staten Island", Neighborhood: "Travis"),
        Locations(Borough: "Staten Island", Neighborhood: "Bulls Head"),
        Locations(Borough: "Staten Island", Neighborhood: "Bay Terrace"),
        Locations(Borough: "Staten Island", Neighborhood: "Sunnyside"),
        Locations(Borough: "Staten Island", Neighborhood: "Elm Park"),
        Locations(Borough: "Staten Island", Neighborhood: "Willowbrook"),
        
        ]
    
    var effect: UIVisualEffect!
    var newBirthday: String?
    override func viewDidLoad() {
        super.viewDidLoad()
        
                
        effect = visualEffectView.effect
        visualEffectView.effect = nil
        
        visualEffectView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        
        firstPickerView.delegate = self
        firstPickerView.dataSource = self
        
        secondPickerView.delegate = self
        secondPickerView.dataSource = self
        
        thirdPickerView.delegate = self
        thirdPickerView.dataSource = self

        self.finishedEditingView.layer.cornerRadius = 34
        self.finishedEditingView.backgroundColor = UIColor.white
        
        mainScroll.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(removePicker)))
       
        firstLocation.tintColor = UIColor.white
        secondLocation.tintColor = UIColor.white
        thirdLocation.tintColor = UIColor.white
        
        
        finishedEditing.addTarget(self, action: #selector(doneEditingProfile), for: .touchUpInside)
        doneButton.addTarget(self, action: #selector(finishedEditingAnimateOut), for: .touchUpInside)
        
        let uid = FIRAuth.auth()?.currentUser?.uid



        mainScroll.contentSize.height = 1500
        mainScroll.contentSize.width = UIScreen.main.bounds.width
        
        self.imageView.layer.cornerRadius = 46
        self.imageView.clipsToBounds = true;
        self.imageView.contentMode = .scaleAspectFill
        
        
        self.secondPhoto.layer.cornerRadius = 24
        self.secondPhoto.clipsToBounds = true;
        self.secondPhoto.contentMode = .scaleAspectFill
        
        
        self.thirdPhoto.layer.cornerRadius = 24
        self.thirdPhoto.clipsToBounds = true;
        self.thirdPhoto.contentMode = .scaleAspectFill
       
        self.fourthPhoto.layer.cornerRadius = 24
        self.fourthPhoto.clipsToBounds = true;
        self.fourthPhoto.contentMode = .scaleAspectFill
        
        self.fifthPhoto.layer.cornerRadius = 24
        self.fifthPhoto.clipsToBounds = true;
        self.fifthPhoto.contentMode = .scaleAspectFill
        
        self.sixthPhoto.layer.cornerRadius = 24
        self.sixthPhoto.clipsToBounds = true;
        self.sixthPhoto.contentMode = .scaleAspectFill
    
        FIRDatabase.database().reference().child("Users").child(uid!).observeSingleEvent(of: .value, with: {(snapshot) in if let dictionary = snapshot.value as? [String: AnyObject]
        {
       
            self.usersName.text = dictionary["name"] as? String
           
            self.usersEmail.text = dictionary["email"] as? String
            
            self.aboutMeSection.text = dictionary["aboutMe"] as? String
            
            self.firstLocation.text = dictionary["firstLocation"] as? String
            
            self.secondLocation.text = dictionary["secondLocation"] as? String
            
            self.thirdLocation.text = dictionary["thirdLocation"] as? String
            
            self.usersBirthday.text = dictionary["birthday"] as? String
            
            self.newBirthday = dictionary["birthday"] as? String
            
            self.imageView.loadImageUsingCachWithUrlString(urlString:dictionary["profileImageUrl"] as! String)
            
        
            self.secondPhoto.loadImageUsingCachWithUrlString(urlString:dictionary["secondImageUrl"] as! String)
            
            self.thirdPhoto.loadImageUsingCachWithUrlString(urlString:dictionary["thirdImageUrl"] as! String)
            
            self.fourthPhoto.loadImageUsingCachWithUrlString(urlString:dictionary["fourthImageUrl"] as! String)
            
            self.fifthPhoto.loadImageUsingCachWithUrlString(urlString:dictionary["fifthImageUrl"] as! String)
            self.sixthPhoto.loadImageUsingCachWithUrlString(urlString:dictionary["sixthImageUrl"] as! String)
            
            }
           
        }, withCancel: nil)
        
    }


    func handleSelectProfileImageView() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        present(picker, animated: true, completion:nil)
    }
    func imagePickerController(_ picker: UIImagePickerController,  didFinishPickingMediaWithInfo info: [String : Any]) {
        
        var selectedImageFromPicker:UIImage?
        
        
        if let editedImage = info["UIImagePickerControllerEditedImage"] as?  UIImage{
            selectedImageFromPicker = editedImage
            
        }else if let originalImage =  info["UIIMagePickerControllerOriginalImage"] as? UIImage{
            selectedImageFromPicker = originalImage
            
        }
        
        if let selectedImage = selectedImageFromPicker{
            switch imagePicked {
            case 10: updatesecondAvatarImageInFirebase(image: selectedImage)
           
            secondPhoto.image = resizeImage(image: selectedImage, newWidth: 366)
           
                        break
            case 20: updateProfileImageInFirebase(image: selectedImage)
                imageView.image = resizeImage(image: selectedImage, newWidth: 366)
                        break
            case 30: updateThirdAvatarImageInFirebase(image: selectedImage)
                thirdPhoto.image = resizeImage(image: selectedImage, newWidth: 366)
                        break
            case 40: updateFourthAvatarImageInFirebase(image: selectedImage)
                fourthPhoto.image = resizeImage(image: selectedImage, newWidth: 366)
                        break
            case 50: updateFifthAvatarImageInFirebase(image: selectedImage)
                fifthPhoto.image = resizeImage(image: selectedImage, newWidth: 366)
                        break
            case 60: updateSixthAvatarImageInFirebase(image: selectedImage)
                sixthPhoto.image = resizeImage(image: selectedImage, newWidth: 366)
                        break
            default: print("There is no photo")
            }

        }
        
        dismiss(animated: true, completion: nil)
    }
    func hideKeyboard() {
        view.endEditing(true)
    }


   func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("canceled picker")
        dismiss(animated: true, completion: nil)
    }
    
    func updateProfileImageInFirebase(image: UIImage){
        let user = FIRAuth.auth()?.currentUser
        guard let uid = user?.uid else {
            return
        }
        if user != nil {
            let imageName = NSUUID().uuidString
            let storageRef =  FIRStorage.storage().reference().child("Profile_Images").child("\(imageName).jpg")
            if let uploadData = UIImagePNGRepresentation(image) {
                storageRef.put(uploadData, metadata: nil, completion: { (metadata, error) in
                    if error != nil {
                        print(error!)
                        return
                    }
                    
                    
                    if let profileImageUrl = metadata?.downloadURL()?.absoluteString {
                        FIRDatabase.database().reference().child("Users").child(uid).updateChildValues(["profileImageUrl": profileImageUrl])
                    }
                })
            }
        }
    }
    func updatesecondAvatarImageInFirebase(image: UIImage){
        let user = FIRAuth.auth()?.currentUser
        guard let uid = user?.uid else {
            return
        }
        if user != nil {
            let imageName = NSUUID().uuidString
            let storageRef =  FIRStorage.storage().reference().child("Second_Images").child("\(imageName).jpg")
            if let uploadData = UIImageJPEGRepresentation(image,0.9){
                storageRef.put(uploadData, metadata: nil, completion: { (metadata, error) in
                    if error != nil {
                        print(error!)
                        return
                    }
                    
                    if let secondImageUrl = metadata?.downloadURL()?.absoluteString {
                        FIRDatabase.database().reference().child("Users").child(uid).updateChildValues(["secondImageUrl": secondImageUrl])
                    }
                })
            }
        }
    }
    func updateThirdAvatarImageInFirebase(image: UIImage){
        let user = FIRAuth.auth()?.currentUser
        guard let uid = user?.uid else {
            return
        }
        if user != nil {
            let imageName = NSUUID().uuidString
            let storageRef =  FIRStorage.storage().reference().child("Third_Images").child("\(imageName).jpg")
            if let uploadData = UIImageJPEGRepresentation(image,0.9) {
                storageRef.put(uploadData, metadata: nil, completion: { (metadata, error) in
                    if error != nil {
                        print(error!)
                        return
                    }
                    
                    if let thirdImageUrl = metadata?.downloadURL()?.absoluteString {
                        FIRDatabase.database().reference().child("Users").child(uid).updateChildValues(["thirdImageUrl": thirdImageUrl])
                    }
                })
            }
        }
    }
    func updateFourthAvatarImageInFirebase(image: UIImage){
        let user = FIRAuth.auth()?.currentUser
        guard let uid = user?.uid else {
            return
        }
        if user != nil {
            let imageName = NSUUID().uuidString
            let storageRef =  FIRStorage.storage().reference().child("Fourth_Images").child("\(imageName).jpg")
            if let uploadData = UIImageJPEGRepresentation(image,0.9) {
                storageRef.put(uploadData, metadata: nil, completion: { (metadata, error) in
                    if error != nil {
                        print(error!)
                        return
                    }
                    
                    if let fourthImageUrl = metadata?.downloadURL()?.absoluteString {
                        FIRDatabase.database().reference().child("Users").child(uid).updateChildValues(["fourthImageUrl": fourthImageUrl])
                    }
                })
            }
        }
    }
    func updateFifthAvatarImageInFirebase(image: UIImage){
        let user = FIRAuth.auth()?.currentUser
        guard let uid = user?.uid else {
            return
        }
        if user != nil {
            let imageName = NSUUID().uuidString
            let storageRef =  FIRStorage.storage().reference().child("Fifth_Images").child("\(imageName).jpg")
            if let uploadData = UIImageJPEGRepresentation(image,0.9) {
                storageRef.put(uploadData, metadata: nil, completion: { (metadata, error) in
                    if error != nil {
                        print(error!)
                        return
                    }
                    
                    if let fifthImageUrl = metadata?.downloadURL()?.absoluteString {
                        FIRDatabase.database().reference().child("Users").child(uid).updateChildValues(["fifthImageUrl": fifthImageUrl])
                    }
                })
            }
        }
    }
    func updateSixthAvatarImageInFirebase(image: UIImage){
        let user = FIRAuth.auth()?.currentUser
        guard let uid = user?.uid else {
            return
        }
        if user != nil {
            let imageName = NSUUID().uuidString
            let storageRef =  FIRStorage.storage().reference().child("Sixth_Images").child("\(imageName).jpg")
            if let uploadData = UIImageJPEGRepresentation(image,0.9) {
                storageRef.put(uploadData, metadata: nil, completion: { (metadata, error) in
                    if error != nil {
                        print(error!)
                        return
                    }
                    
                    if let sixthImageUrl = metadata?.downloadURL()?.absoluteString
                        {
                        FIRDatabase.database().reference().child("Users").child(uid).updateChildValues(["sixthImageUrl": sixthImageUrl])
                    }
                })
            }
        }
    }

    func doneEditingProfile(){
        let uid = FIRAuth.auth()?.currentUser?.uid
     
        guard let updatedName = usersName.text else {
            print("Form is not valid")
       return }
       
        guard let updatedEmail = usersEmail.text else{
            print("Form is not valid")
            return}
        guard let updatedAboutMe = aboutMeSection.text else{
            print("Form is not valid")
        return}
        guard let firstLocation = firstLocation.text else{
            print("Something went wrong with firstLocation")
            return
        }
        guard let secondLocation = secondLocation.text else{
            print("Something went wrong with secondLocation")
            return
        }
        guard let thirdLocation = thirdLocation.text else{
            print("something went wrong with thirdLocation")
            return
        }
        guard let updatedBirthday = newBirthday else{
            print("something went wrong with the updatedBirthday")
            return
        }
        FIRDatabase.database().reference().child("Users").child(uid!).updateChildValues(["birthday":updatedBirthday])
        FIRDatabase.database().reference().child("Users").child(uid!).updateChildValues(["name": updatedName])

        FIRDatabase.database().reference().child("Users").child(uid!).updateChildValues(["aboutMe":updatedAboutMe])
        
        FIRDatabase.database().reference().child("Users").child(uid!).updateChildValues(["firstLocation":firstLocation])
        
        FIRDatabase.database().reference().child("Users").child(uid!).updateChildValues(["secondLocation":secondLocation])
        
        FIRDatabase.database().reference().child("Users").child(uid!).updateChildValues(["thirdLocation":thirdLocation])
        
        let user = FIRAuth.auth()?.currentUser
        let userUID = user?.uid
        let ref = FIRDatabase.database().reference().child("Users").child(userUID!)
        
        ref.observeSingleEvent(of: .value, with: { snapshot in
            let dictionary = snapshot.value as? [String: AnyObject]
            let currentUserPassword = dictionary?["password"] as? String
            let currentEmail = dictionary?["email"] as? String
            
            let credential = FIREmailPasswordAuthProvider.credential(withEmail: currentEmail!, password: currentUserPassword!)
            user?.reauthenticate(with: credential, completion:{ error in
                if let error = error {
                print("there is an error \(error)")
                }else {
                    print("user has been relogged in ")
                    
                    FIRAuth.auth()?.currentUser?.updateEmail(updatedEmail, completion: {error in
                        if error != nil {
                            print("There was an error processing the request")
                        } else {
                            FIRDatabase.database().reference().child("Users").child(uid!).updateChildValues(["email": updatedEmail])
                                self.finishedEditingAnimation()
                        }
                    })
                }}
            )}
        )
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let candy: Locations
        candy = pickerData[row]
        let bothValuesArray = [(String(candy.Borough)),", ",(String(candy.Neighborhood))]
        let joined = bothValuesArray.joined(separator: "")
        return joined
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let candy: Locations
        candy = pickerData[row]
        let userArray = [(String(candy.Borough)),", ",(String(candy.Neighborhood))]
        if pickerView == firstPickerView{
        firstLocation.text = userArray.joined(separator: "")
        }
        if pickerView == secondPickerView{
            secondLocation.text = userArray.joined(separator: "")
            
        }
        if pickerView == thirdPickerView{
            thirdLocation.text = userArray.joined(separator: "")
        }
    }
    func removePicker() {
        hideKeyboard()
        firstPickerView.removeFromSuperview()
        secondPickerView.removeFromSuperview()
        thirdPickerView.removeFromSuperview()
        
    }
    func finishedEditingAnimation(){
        self.view.addSubview(finishedEditingView)
        hideKeyboard()
        finishedEditingView.center = self.view.center
        finishedEditingView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
        finishedEditingView.alpha = 0
        
        UIView.animate(withDuration: 0.4) {
            self.visualEffectView.effect = self.effect
            self.finishedEditingView.alpha = 1
            self.finishedEditingView.transform = CGAffineTransform.identity
        }

    }
    func finishedEditingAnimateOut(){
        UIView.animate(withDuration: 0.3, animations: {
            self.finishedEditingView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
            self.finishedEditingView.alpha = 0
            
            self.visualEffectView.effect = nil
        }) {(success:Bool) in
            self.finishedEditingView.removeFromSuperview()
        }

    }
    func datePickerValueChanged(sender:UIDatePicker){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM dd yyyy"
        usersBirthday.text = dateFormatter.string(from: sender.date)
        newBirthday = dateFormatter.string(from: sender.date)
        print("this is the new birthday entered", newBirthday as Any)
        
    }
    
}
