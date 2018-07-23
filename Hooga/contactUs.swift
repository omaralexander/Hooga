//
//  contactUs.swift
//  Hooga
//
//  Created by Omar Abbas on 4/20/17.
//  Copyright © 2017 Omar Abbas. All rights reserved.
//

import UIKit


class contactUs: UIViewController{
   
    
    @IBAction func dismissButton(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
  
    @IBOutlet weak var facebookButton: UIImageView!
    
    @IBOutlet weak var twitterButton: UIImageView!
    
    @IBOutlet weak var instagramButton: UIImageView!
    
    @IBOutlet weak var emailButton: UIImageView!
    
    @IBOutlet weak var websiteButton: UIImageView!
    
    @IBOutlet weak var websiteLabelButton: UILabel!
    
    override func viewDidLoad(){
    super.viewDidLoad()
        facebookButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(facebookHyperLink)))
        twitterButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(twitterHyperLink)))
        instagramButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(instagramHyperLink)))
        emailButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(emailApplicationLink)))
        websiteButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(websiteHyperLink)))
        websiteLabelButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(websiteHyperLink)))
        
    }
    func facebookHyperLink(){
        if let url = URL(string: "https://www.facebook.com/hoogaapp/"){
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:])
            } else {
                // Fallback on earlier versions
            }
        }
    
    }
    func twitterHyperLink(){
        if let url = URL(string: "https://twitter.com/hooga_app"){
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:])
            } else {
                // Fallback on earlier versions
                UIApplication.shared.openURL(url)
            }
        }
        

    }
    func instagramHyperLink(){
        if let url = URL(string: "https://www.instagram.com/hooga_app/"){
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:])
            } else {
                // Fallback on earlier versions
                UIApplication.shared.openURL(url)
            }
        }
        

    }
    func websiteHyperLink(){
        if let url = URL(string: "http://hooga-app.weebly.com"){
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:])
            } else {
                // Fallback on earlier versions
                UIApplication.shared.openURL(url)
            }
        }
        

    }
    func emailApplicationLink(){
        let email = "HoogaTeam@gmail.com"
        let urlEmail = NSURL(string: "mailto:\(email)")
        
        if UIApplication.shared.canOpenURL(urlEmail! as URL){
            UIApplication.shared.openURL(urlEmail! as URL)
        } else{
            print("UPS")
        }
    }
    
}
