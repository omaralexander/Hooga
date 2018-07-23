//
//  NewTableView.swift
//  Hooga
//
//  Created by Omar Abbas on 12/10/16.
//  Copyright © 2016 Omar Abbas. All rights reserved.
//


import UIKit
import Firebase
import Mapbox
class NewTableView: UITableViewController{
    @IBOutlet weak var reviewStars: UILabel!
   
    var users = [User]()
    let Cell = "Cell"
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UserCell.self, forCellReuseIdentifier: Cell)
        fetchUser()
    }
    
    func fetchUser(){
        FIRDatabase.database().reference().child("Users").observe(.childAdded, with: {(snapshot) in
        if let dictionary = snapshot.value as? [String: AnyObject]{
            let user = User()
            user.id = snapshot.key
            user.setValuesForKeys(dictionary)
            user.name = dictionary["name"] as! String?
            user.email = dictionary["email"] as! String?
            user.profileImageUrl = dictionary["profileImageUrl"] as! String?
            self.users.append(user)
           
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
        let cells = tableView.visibleCells
        let user = users[indexPath.row]
        let tableViewHeight = tableView.bounds.size.height
        
        cell.textLabel?.text = user.name
        cell.detailTextLabel?.text = user.email
        cell.imageView?.contentMode = .scaleAspectFill
        cell.textLabel?.font = UIFont(name:"Avenir", size:22)
        tableView.layer.borderWidth = 0;
        tableView.layer.borderColor = UIColor.lightGray.cgColor
        for cell in cells {
        cell.transform = CGAffineTransform(translationX: 0, y: tableViewHeight)
        }
        if let profileImageUrl = user.profileImageUrl {
        cell.profileImageView.loadImageUsingCachWithUrlString(urlString: profileImageUrl)
        }
        var delayCounter = 0
        for cell in cells {
        UIView.animate(withDuration: 1.75, delay: Double(delayCounter) * 0.05, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
                cell.transform = CGAffineTransform.identity
            }, completion: nil)
            delayCounter += 1
        }
        return cell
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }


    class UserCell: UITableViewCell {
        override func layoutSubviews() {
            super.layoutSubviews()

            textLabel?.frame = CGRect(x: 64, y: textLabel!.frame.origin.y - 2, width: textLabel!.frame.width, height: textLabel!.frame.height)
          
            detailTextLabel?.frame = CGRect(x: 64, y: detailTextLabel!.frame.origin.y - 2, width: detailTextLabel!.frame.width, height: detailTextLabel!.frame.height)
        }
        let profileImageView: UIImageView = {
            let imageView = UIImageView()
            imageView.translatesAutoresizingMaskIntoConstraints = false
            imageView.layer.cornerRadius = 24
            imageView.layer.masksToBounds = true
            imageView.contentMode = .scaleAspectFill
            return imageView
        }()
   
        override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
            super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
            addSubview(profileImageView)
            
            profileImageView.leftAnchor.constraint(equalTo: self.leftAnchor,constant:8).isActive = true
            profileImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
            profileImageView.widthAnchor.constraint(equalToConstant: 48).isActive = true
            profileImageView.heightAnchor.constraint(equalToConstant: 48).isActive = true
        }
        required init?(coder aDecoder:NSCoder){
            fatalError("init(coder:) has not been implemented")
    }

}
}
