//
//  loadingTableMessages.swift
//  Hooga
//
//  Created by Omar Abbas on 1/14/17.
//  Copyright © 2017 Omar Abbas. All rights reserved.
//

import UIKit
import Firebase

class loadingTableMessages: UITableViewController{
  let cellId = "cellId"
    override func viewDidLoad() {
        super.viewDidLoad()
       
        tableView.register(MessageCell.self, forCellReuseIdentifier: cellId)
        
        
    
    messages.removeAll()
    messagesDictionary.removeAll()
    tableView.reloadData()
    observeUserMessages()
    }
   
    var messages = [Messages]()
    var messagesDictionary = [String: Messages]()
    
    func observeUserMessages(){
        guard let uid = FIRAuth.auth()?.currentUser?.uid else{
            return
        }
        let ref = FIRDatabase.database().reference().child("user-messages").child(uid)
        ref.observe(.childAdded, with: {(snapshot) in
        let messageId = snapshot.key
        let messageReference = FIRDatabase.database().reference().child("messages").child(messageId)
            
            messageReference.observeSingleEvent(of: .value, with: {(snapshot) in
                
                if let dictionary = snapshot.value as? [String: AnyObject] {
                    let message = Messages(dictionary: dictionary)
                    message.setValuesForKeys(dictionary)
                    
                    if let chatPartnerId = message.chatPartnerId(){
                        self.messagesDictionary[chatPartnerId] = message
                        
                        self.messages = Array(self.messagesDictionary.values)
                        
                        self.messages.sort(by:{(message1, message2) -> Bool in
                            return (message1.timeStamp?.intValue)! > (message2.timeStamp?.intValue)!
                        })
                    }
                    self.timer?.invalidate()
                    self.timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.handleReloadTable), userInfo: nil, repeats: false)
                    
                   
                }
            
            
            }, withCancel: nil)
        
        
        }, withCancel: nil)
    }
    var timer: Timer?
    func handleReloadTable(){
         self.tableView.reloadData()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
       
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! MessageCell
       
        let message = messages[indexPath.row]
        cell.message = message

        return cell
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90 //was 72
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "justATest", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "justATest"{
            let indexPath = tableView.indexPathForSelectedRow!
            let viewController = segue.destination as! existingUserMessages
            viewController.messageUser = messages[indexPath.row]
    }

    
    }
    
}
