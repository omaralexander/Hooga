//
//  requestsViewController.swift
//  Hooga
//
//  Created by Omar Abbas on 5/12/17.
//  Copyright © 2017 Omar Abbas. All rights reserved.
//

import UIKit
import Firebase


class requestViewController: UIViewController,UITableViewDelegate,UITableViewDataSource{
    
    @IBOutlet weak var dismissButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
       override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
    }
    var requests = [Request]()
    var requestsDictionary = [String: Request]()
    
    func observeUserRequests(){
        guard let uid = FIRAuth.auth()?.currentUser?.uid else{
            return
        }
        let ref = FIRDatabase.database().reference().child("user-requests").child(uid)
        ref.observe(.childAdded, with: {(snapshot) in
        let requestId = snapshot.key
        let requestReference = FIRDatabase.database().reference().child("requests").child(requestId)
            requestReference.observeSingleEvent(of: .value, with: {(snapshot) in
                if let dictionary = snapshot.value as? [String: AnyObject]{
                    let request = Messages(dictionary: dictionary)
                    request.setValuesForKeys(dictionary)
                    
                    self.requests = Array(self.requestsDictionary.values)
                }
            
            }, withCancel: nil)
        }, withCancel: nil)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return requests.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
         let request = requests[indexPath.row]
   
          return cell
          }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "", sender: self)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 82
    }
    
}
