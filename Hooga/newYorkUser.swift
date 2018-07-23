//
//  newYorkUser.swift
//  Hooga
//
//  Created by Omar Abbas on 1/8/17.
//  Copyright © 2017 Omar Abbas. All rights reserved.
//


import UIKit
import Firebase

class newYorkUser: UITableViewController{
    @IBAction func unwindToViewControllerForUser(segue: UIStoryboardSegue){
        
    }

    var users = [User]()
    var filteredUsers = [User]()
    var reviewArray = [String]()
    let Cell = "Cell"
    var passedLocation: String? 
    var width: CGFloat?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        
        print("screen height and width",self.view.frame.height, self.view.frame.width)
        //screen size is 736 height, and width is 414
        tableView.register(UserCell.self, forCellReuseIdentifier: Cell)
        tableView.separatorStyle = .none
        width = self.view.frame.width
        users.removeAll()
        filteredUsers.removeAll()
        print("how many in here", users.count)
        tableView.reloadData()
        fetchUser()
        
    }
    func fetchUser(){
//        let ref = FIRDatabase.database().reference().child("Users")
//        ref.keepSynced(true)
          FIRDatabase.database().reference().child("Users").observe(.childAdded, with: {(snapshot) in
            if let dictionary = snapshot.value as? [String: AnyObject]{
                let user = User()
                user.id = snapshot.key
                user.setValuesForKeys(dictionary)
                user.name = dictionary["name"] as! String?
                user.aboutMe = dictionary["aboutMe"] as! String?
                user.profileImageUrl = dictionary["profileImageUrl"] as! String?
                user.firstLocation = dictionary["firstLocation"] as! String?
                user.secondLocation = dictionary["secondLocation"] as! String?
                user.thirdLocation = dictionary["thirdLocation"] as! String?
                user.guiderMode = dictionary["guiderMode"] as! String?
                self.users.append(user)
                self.users =  self.users.filter{(($0.firstLocation?.contains(self.passedLocation!))!)&&$0.guiderMode == "True" || (($0.secondLocation?.contains(self.passedLocation!))!) || (($0.thirdLocation?.contains(self.passedLocation!))!)}
                
                
                
                self.tableView.reloadData()
            }
        
        }, withCancel:nil)
    }
 
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! UserCell
        
        let user = users[indexPath.row]
        let profileImageUrlThird = user.profileImageUrl
        cell.nameLabel.text = user.name
        cell.bioLabel.text = user.aboutMe
        cell.reviewRating.text = user.averageRating
        cell.profileImageView.loadImageUsingCachWithUrlString(urlString: profileImageUrlThird!)
        let tempNumber = user.profileView
        let stringTemp = tempNumber?.stringValue
        cell.profileViewCount.text = stringTemp
        cell.imageView?.contentMode = .scaleAspectFill
        cell.backgroundColor = UIColor.clear
        cell.textLabel?.font = UIFont(name:"Avenir", size:22)
        tableView.layer.borderWidth = 0;
        tableView.layer.borderColor = UIColor.lightGray.cgColor
             
 return cell
}


    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 330
    }
    var mainProfile: mainProfile?
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
     
        performSegue(withIdentifier: "mainProfile", sender: self)
       
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "mainProfile" {
            let indexPath = tableView.indexPathForSelectedRow!
            let viewController = segue.destination as! mainProfile
            let viewController1 = loadingTableReview()
            viewController.user2 = users[indexPath.row]
            viewController1.selectedUsersProfile = users[indexPath.row]
        }
    }
    
    class UserCell: UITableViewCell {
        override func layoutSubviews() {
            super.layoutSubviews()
            let possiblewidth = UIScreen.main.bounds.width
            
            bioLabel.frame = CGRect(x: 64, y: bioLabel.frame.origin.y - 2, width: bioLabel.frame.width, height: textLabel!.frame.height)
            
            nameLabel.frame = CGRect(x: 190, y: 64, width: nameLabel.frame.width, height: nameLabel.frame.height)
            
            tableViewCell.frame = CGRect(x: 5, y: 0, width: possiblewidth, height: 310)//280
            
        }
        let tableViewCell: UIView = {
            let tableCell = UIView()
            tableCell.layer.cornerRadius = 14
            tableCell.layer.masksToBounds = true
            return tableCell
        }()
            let bioLabel: UILabel = {
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.font = UIFont(name: "Avenir-Roman", size: 16)
            label.lineBreakMode = .byTruncatingTail
            label.numberOfLines = 3
            label.textColor = UIColor.black //.white
            return label
        }()
        let reviewRating: UILabel = {
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.font = UIFont(name: "Avenir-Medium", size: 15)
            label.textColor = UIColor.lightGray
            return label
        }()
        let reviewLabel: UILabel = {
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.font = UIFont(name: "Avenir-Medium", size: 15)
            label.textColor = UIColor.lightGray
            label.text = "Rating:"
            return label
        }()
        
        let nameLabel: UILabel = {
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.font = UIFont(name: "Avenir-Medium", size: 20)
            label.textColor = UIColor.black
            return label
        }()
        let profileViewCount: UILabel = {
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.font = UIFont(name: "Avenir-Medium", size: 15)
            label.textColor = UIColor.lightGray
            label.lineBreakMode = .byTruncatingTail
            
            return label
        }()
        let profileImageView: UIImageView = {
            let imageView = UIImageView()
            imageView.translatesAutoresizingMaskIntoConstraints = false
            imageView.layer.cornerRadius = 17 //14
            imageView.layer.masksToBounds = true
           
            imageView.contentMode = .scaleAspectFill
           
            return imageView
        }()

        let profileViewIcon: UIImageView = {
            let imageView = UIImageView()
            imageView.translatesAutoresizingMaskIntoConstraints = false
            imageView.layer.masksToBounds = true
            imageView.contentMode = .scaleAspectFit
            imageView.image = UIImage(named: "viewIcon")
            
            return imageView
        }()
        
        override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
            super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
       
            let view = tableViewCell
            
            addSubview(view)
            
          
           
            view.addSubview(bioLabel)
            view.addSubview(nameLabel)
            view.addSubview(reviewRating)
            view.addSubview(profileViewCount)
            view.addSubview(profileViewIcon)
            view.addSubview(reviewLabel)
            view.addSubview(profileImageView)
            let viewWidth = UIScreen.main.bounds.width
              print("possible new width ", UIScreen.main.bounds.width)
           


            
            profileViewIcon.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -79).isActive = true
            profileViewIcon.topAnchor.constraint(equalTo: self.topAnchor, constant: 219).isActive = true //146
            profileViewIcon.widthAnchor.constraint(equalToConstant: 23).isActive = true
            profileViewIcon.heightAnchor.constraint(equalToConstant: 23).isActive = true
            
            profileViewCount.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 25).isActive = true//25
            profileViewCount.topAnchor.constraint(equalTo: self.topAnchor, constant: 221).isActive = true //148
            profileViewCount.widthAnchor.constraint(equalToConstant: 100).isActive = true
            profileViewCount.heightAnchor.constraint(equalToConstant: 20).isActive = true
            
            reviewRating.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -262).isActive = true
            reviewRating.topAnchor.constraint(equalTo: self.topAnchor, constant: 221).isActive = true //148
            reviewRating.widthAnchor.constraint(equalToConstant: viewWidth - 330).isActive = true
            reviewRating.heightAnchor.constraint(equalToConstant: 20).isActive = true
            
            reviewLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -302).isActive = true
            reviewLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 220).isActive = true //147
            reviewLabel.widthAnchor.constraint(equalToConstant: viewWidth - 320).isActive = true
            reviewLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true

            profileImageView.leftAnchor.constraint(equalTo: self.leftAnchor,constant: 15).isActive = true
            profileImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 10).isActive = true
            profileImageView.widthAnchor.constraint(equalToConstant: viewWidth - 31).isActive = true //375 was 344
 
            profileImageView.heightAnchor.constraint(equalToConstant: 185).isActive = true //180
            
        
            nameLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -11).isActive = true
            nameLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 195).isActive = true //178
            nameLabel.widthAnchor.constraint(equalToConstant: viewWidth - 28).isActive = true
            nameLabel.heightAnchor.constraint(equalTo: (textLabel?.heightAnchor)!).isActive = true
            
            
            bioLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 17).isActive = true
            bioLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 240).isActive = true //200
            bioLabel.widthAnchor.constraint(equalToConstant: viewWidth - 28).isActive = true //28
            bioLabel.heightAnchor.constraint(equalTo: (textLabel?.heightAnchor)!).isActive = true
        }
        required init?(coder aDecoder:NSCoder){
            fatalError("init(coder:) has not been implemented")
        }

    }
}
