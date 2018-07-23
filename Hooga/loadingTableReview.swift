//
//  loadingTableReview.swift
//  Hooga
//
//  Created by Omar Abbas on 1/12/17.
//  Copyright © 2017 Omar Abbas. All rights reserved.
//

import UIKit
import Firebase

class loadingTableReview: UITableViewController {
   
    
    
    @IBOutlet var openReviews: UIView!
   
    
       let cellId = "cellId"
    var selectedUsersProfile:User?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
    
        
        
    tableView.register(UserCell.self, forCellReuseIdentifier: cellId)
       
        observeUserReviews()
    
    }
 
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reviews.count
    }
    
   
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! UserCell
        let review = reviews[indexPath.row]
         cell.review = review
        
        
        return cell
    }
    
    var users = [User]()
    
    
    var reviews = [Reviews]()
    var reviewDictionary = [String: Reviews]()
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
            let myParent = self.parent as? mainProfile
            
            myParent?.reviewProfileData = reviews[indexPath.row]
            myParent?.review = reviews[indexPath.row]
            myParent?.reviewText.text = myParent?.reviewProfileData?.text
        
        myParent?.expandingTheReviews()
        
    }
    
    func observeUserReviews(){
        guard let uid = selectedUsersProfile?.id
        
            else{
        return
        }
        let ref = FIRDatabase.database().reference().child("user-reviews").child(uid)
        ref.observe(.childAdded, with: {(snapshot) in
           
            
            let reviewId = snapshot.key
            let messageReference = FIRDatabase.database().reference().child("reviews").child(reviewId)
            
            messageReference.observeSingleEvent(of: .value, with: {(snapshot) in
                
                    if let dictionary = snapshot.value as?[String: AnyObject]{
                    let review = Reviews()
                    review.setValuesForKeys(dictionary)
                    
                    
                    if let fromId = review.fromId{
                        self.reviewDictionary[fromId] = review
                        
                    //    let filter = self.reviews.filter{($0.ratingNumber != nil)}
                      //
                        self.reviews.append(review)
                        //dump(filter)
                   
                        
                        self.reviews.sort(by: { (review1, review2) -> Bool in
                            return (review1.timeStamp?.intValue)! > (review2.timeStamp?.intValue)!
                        })
                        
                    }
                    
                    self.tableView.reloadData()
                    
                }
          
            }, withCancel: nil)
            
        }, withCancel: nil)
    }
   override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }



}

