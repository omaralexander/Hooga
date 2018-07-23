//
//  cellForLocations.swift
//  Hooga
//
//  Created by Omar Abbas on 4/9/17.
//  Copyright © 2017 Omar Abbas. All rights reserved.
//


import UIKit


class cellForLocations: UICollectionViewCell{
    let boroughLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Avenir-Roman", size: 18)
        label.textColor = UIColor.black
        return label
    }()
    let clearResults: UIButton = {
        let button = UIButton()
        let redColor = UIColor(red: 246/255, green: 59/255, blue: 38/255, alpha: 100)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = UIFont(name:"Avenir-Medium", size: 17)
        button.setTitle("Clear results", for: .normal)
        button.setTitleColor(redColor, for: .normal)
        return button
    }()
    let upperLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Avenir-Medium", size: 25)//25
        label.textColor = UIColor.black
        return label
    }()
    let viewBackground: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 34
        view.layer.masksToBounds = true
        return view
    }()
    override init(frame: CGRect){
    super.init(frame: frame)
    let view = viewBackground
    addSubview(viewBackground)
    addSubview(clearResults)
    view.addSubview(boroughLabel)
    view.addSubview(upperLabel)
  //30
 // Put app in iphone and take screenshots and place them inside of collection view
    let screenWidth = self.frame.width
    
    view.widthAnchor.constraint(equalToConstant: screenWidth - 30).isActive = true
    view.heightAnchor.constraint(equalToConstant: 214).isActive = true
    view.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 13).isActive = true
    view.topAnchor.constraint(equalTo: self.topAnchor).isActive = true

        
        
    clearResults.widthAnchor.constraint(equalToConstant: 132).isActive = true//132
    clearResults.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 25).isActive = true //25
    clearResults.heightAnchor.constraint(equalToConstant: 30).isActive = true //30
    clearResults.topAnchor.constraint(equalTo: self.topAnchor, constant: 5).isActive = true //5
  
        
        
    boroughLabel.widthAnchor.constraint(equalToConstant: 300).isActive = true
    boroughLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 110).isActive = true //125
    boroughLabel.heightAnchor.constraint(equalToConstant: 110).isActive = true //44
    boroughLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 68).isActive = true
    //75
        
        
    upperLabel.widthAnchor.constraint(equalToConstant: 300).isActive = true
    upperLabel.heightAnchor.constraint(equalToConstant: 100).isActive = true //55
    upperLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 106).isActive = true
    upperLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 43).isActive = true
    }
    required init?(coder aDecoder: NSCoder){
        fatalError("init(coder:) has not been implemented")

    }
}
