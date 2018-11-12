//
//  AddPageViewController.swift
//  inviti
//
//  Created by Gop on 10/11/2560 BE.
//  Copyright © 2560 gopGorppol. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD

class AddPageViewController: UIViewController,UITableViewDelegate, UITableViewDataSource {

    let refToUserInfo = FIRDatabase.database().reference().child("UserInfo")
    let uid = FIRAuth.auth()?.currentUser?.uid
    let refToFriend = FIRDatabase.database().reference().child("Friend")

    var transferArray = [RequestTransfer]()
    
    @IBOutlet weak var searchTextField: UITextField!
    
    @IBOutlet weak var mainView: UIView!
       
    @IBOutlet weak var userNameLabel: UILabel!

    @IBOutlet weak var messageToUser: UILabel!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var requestTable: UITableView!

    @IBOutlet weak var requestTableView: UIView!
    let refToRequest = FIRDatabase.database().reference().child("Request")
    let refToFindUserName = FIRDatabase.database().reference().child("FindUserName")

    var storeUserId = "nil"
    var ourUserNameWhenSend = "nil" //store our username when we send
    var ownUserName = "nil" // get our username to send for friend request
    
    @IBAction func addButton(_ sender: Any) {
    
        setOurUserNameAndSend(status: "pending", toWhom: storeUserId)
        
    }
    
    @IBAction func requestButton(_ sender: UIButton) {
        
        UIView.animate(withDuration: 0.5){
            
            self.requestTableView.frame.origin.x = 76
            
        }
        
        
    }
    
    @IBOutlet weak var toHomeButton: UIButton!
    @IBAction func toHomeButton(_ sender: UIButton) {
        
        self.navigationController?.popViewController(animated: true)
        self.dismiss(animated: true, completion: nil)
        
        
        
    }
    @IBAction func closeRequestTableView(_ sender: UIButton) {
        
        UIView.animate(withDuration: 0.5){
            
            self.requestTableView.frame.origin.x = 375
            
        }
        
        
    }
    @IBAction func searchButton(_ sender: UIButton) {
        
        SVProgressHUD.show()


        
        let characterset = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789.")
        if searchTextField.text?.rangeOfCharacter(from: characterset.inverted) != nil {
            
            self.messageToUser.alpha = 1
            self.messageToUser.text = "User not found"
            print("string contains special characters")
            
            userNotFound()

            return
            
        }
        

        
        let usernameConvert = searchTextField.text!.replacingOccurrences(of: ".", with: "%2E", options: .literal, range: nil)

        
        refToUserInfo.observeSingleEvent(of: .value, with: { (snapshot) in
            
            if snapshot.hasChild(usernameConvert){
                
                self.messageToUser.alpha = 0
                
                self.retrieveUserId(username: usernameConvert)

                
                self.userNameLabel.text = self.searchTextField.text!
                
                print("There's this User Id")
                
                
            }else{
                
                self.userNotFound()
                
            }
            
            
        })
        
    }
    
    func initiationDesign(){
    
    searchTextField.layer.borderColor = UIColor.lightGray.cgColor
    
    requestTableView.layer.borderColor = UIColor.gray.cgColor
        
    requestTableView.layer.borderWidth = 1
        
    requestTableView.layer.cornerRadius = 10
        
    mainView.layer.cornerRadius = 10
        
    toHomeButton.layer.cornerRadius = 10
    
    }
    
    func addButtonTextAndDisChange(disText : String, mode : String){
    
        
        if mode == "already"{
            addButton.titleLabel?.text = disText
            
            addButton.backgroundColor = UIColor.white
            
            addButton.titleLabel?.textColor = UIColor.orange

            addButton.layer.borderColor = UIColor.orange.cgColor
            
            addButton.layer.borderWidth = 2
            
            addButton.isEnabled = false
        
        }else{
        
            addButton.titleLabel?.text = disText
            
            addButton.titleLabel?.textColor = UIColor.white
            
            addButton.backgroundColor = UIColor.orange
            
            addButton.layer.borderColor = UIColor.orange.cgColor
            
            addButton.layer.borderWidth = 2
            
            addButton.isEnabled = true

        
        
        }
    }
    
    
    func searchRequestId(friendId: String){
        
        refToRequest.child(friendId).queryOrdered(byChild: "SenderId").queryEqual(toValue: uid!)
            .observe(.value, with: { snapshot in
                
                if ( snapshot.value is NSNull ) {
                   
                    print("Have not Requested")
                    
                    self.searchFriendList(friendId: friendId)
                    
                } else {
                   
                    print(snapshot.value)
                    print("Have ALREADY Requested")
                    
                    self.addButtonTextAndDisChange(disText: "Requested", mode: "already")
                    
                    SVProgressHUD.dismiss()

                    
                }
        })
    
    }
    
    func searchFriendList(friendId : String){
    
            refToFriend.child(uid!).observeSingleEvent(of: .value, with: { (snapshot) in
                
                if snapshot.hasChild(friendId){
                    
                    print("There's this User in your friend list")
                    
                    self.addButtonTextAndDisChange(disText: "Friend", mode: "already")

                    
                    SVProgressHUD.dismiss()

                }else{
                
                    self.addButtonTextAndDisChange(disText: "ADD ME", mode: "Normal")
                    
                    print("There's NOT User in your friend list")

                    SVProgressHUD.dismiss()
                
                }
        })
    
    }
    
        func userNotFound(){
    
        self.buttonEnaDis(set: false)
        SVProgressHUD.dismiss()
        self.alphaOfDisplay(alphaInFloat: 0)
    
        self.messageToUser.alpha = 1
        self.messageToUser.text = "User not found"
        print("No User found")
    
    
    }
    
    // Table Code
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "requestCell", for: indexPath) as! FriendRequestCell
        
        cell.userNameRequest.text = transferArray[indexPath.row].username
        
        let status = transferArray[indexPath.row].status
        let requesterName = transferArray[indexPath.row].username
        
        cell.statusTextField.alpha = 1
        
        if(status == "pending"){
        
            cell.statusTextField.text = "\(requesterName) request you as a friend"
        
        }else if(status == "accepted"){
        
            cell.statusTextField.text = "\(requesterName) have accepted you as friend"
        
        }else{
        
        cell.statusTextField.text = "\(requesterName) have decline your offer"
        
        }
        
        return cell
        
    }
  
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return transferArray.count
        
    }

    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
    
        let status = self.transferArray[indexPath.row].status
        let backToId = self.transferArray[indexPath.row].senderId
        
        if(status == "pending"){
            
            let decline = UITableViewRowAction(style: .destructive, title: "Decline") { (action, indexPath) in
                // delete item at indexPath
                
                self.setOurUserNameAndSend(status: "denied", toWhom: backToId)

                self.removeValueInReqTabAndSetStat(indexPathRow: indexPath.row)
                
                
                
            }
            
            let accept = UITableViewRowAction(style: .normal, title: "Accept") { (action, indexPath) in
                
                self.setOurUserNameAndSend(status: "accepted", toWhom: backToId)

                self.addFriend(indexPathRow: indexPath.row)
                
                
            }
            accept.backgroundColor = UIColor.green
            
            return [decline, accept]
            
        }else{
        
            let delete = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in

                
                self.removeValueInReqTabAndSetStat(indexPathRow: indexPath.row)
    
            }
            return [delete]
        }
    }
    
    
    
    func removeValueInReqTabAndSetStat(indexPathRow: Int){
    
        
        myDeleteFunction(childIWantToRemove: transferArray[indexPathRow].requestId)
                
        transferArray.remove(at: indexPathRow)
        
        requestTable.reloadData()
    
    
    }
    
    func findOurUserName(){
    
        let retrieve = refToFindUserName.child(uid!)
        
        retrieve.observe(.value, with: { (snapshot) in
            
            let snapshotValue = snapshot.value as! Dictionary<String, String>
            
            self.ownUserName = snapshotValue["Username"]! 
            
            })
    }
    
    
    func alphaOfDisplay(alphaInFloat: CGFloat){
    
        userNameLabel.alpha = alphaInFloat
        addButton.alpha = alphaInFloat
    
    
    }
    
    func buttonEnaDis (set: Bool){
       
        addButton.isEnabled = set
    
    }
    
    func retrieveUserId(username: String){
        
        refToUserInfo.child(username).observe(.value, with: { (snapshot) in
            
            if let snapshotValue = snapshot.value as? Dictionary<String,String> {
                
                self.storeUserId = snapshotValue["Id"]!
                
                print("This is\(self.storeUserId)")
                
                self.searchRequestId(friendId: self.storeUserId)
                
                
                
                UIView.animate(withDuration: 0.5){
                    
                    self.alphaOfDisplay(alphaInFloat: 1)
                    self.buttonEnaDis(set: true)
                    
                }
                
            }
        })
        
    }

        
    func setOurUserNameAndSend(status: String, toWhom: String){
    
        refToFindUserName.child(uid!).observe(.value, with: { (snapshot) in
            
            if let snapshotValue = snapshot.value as? Dictionary<String,String> {
            
                print("buttontapped")

                self.ourUserNameWhenSend = snapshotValue["Username"]!
                
                self.sendRequest(status: status, toWhom: toWhom)
                
            }
        })
    
    }
    
    func sendRequest(status: String, toWhom: String){
    
    var tempDict = [
        
                    "Username" : ourUserNameWhenSend,
                    "Status" : status,
                    "SenderId" : uid!,
                    "RequestId" : "nil"
        ]
        
        

        let reference = refToRequest.child(toWhom).childByAutoId()
            
        tempDict["RequestId"] = reference.key
        print(reference.key)
        reference.setValue(tempDict){
            (error, ref) in
            
            if error != nil {
                print(error!)
            }
            else {
                print("Message request successfully")
                
            }
        }

    
    
    }
    
    
    func retrieveMessagesFromRequest(){
        
        transferArray.removeAll()
        
        let messageR = refToRequest.child(uid!)
        
        messageR.observe(.childAdded, with: { (snapshot) in
            
            let snapshotValue = snapshot.value as! Dictionary<String, String>
            
            let username = snapshotValue["Username"]!
            let status = snapshotValue["Status"]!
            let senderId = snapshotValue["SenderId"]!
            let requestId = snapshotValue["RequestId"]!
            
            let message = RequestTransfer()
            message.username = username
            message.status = status
            message.senderId = senderId
            message.requestId = requestId
            
            
            self.transferArray.append(message)
            
            self.requestTable.reloadData()
        })
        
    }
    
    func addFriend (indexPathRow: Int){
    
        
        let friendId = transferArray[indexPathRow].senderId
        let friendUserName = transferArray[indexPathRow].username
        
        refToFriend.child(uid!).child(friendId).setValue(["FriendId" : friendId, "FriendUserName" : friendUserName,"Status": "friend"])
        
        refToFriend.child(friendId).child(uid!).setValue(["FriendId" : uid!, "FriendUserName" : ownUserName,"Status": "friend"])
        
        print("success Addfriend")
        
        removeValueInReqTabAndSetStat(indexPathRow: indexPathRow)
    
    }
    
    func myDeleteFunction(childIWantToRemove: String) {
        
        print(childIWantToRemove)
        
        refToRequest.child(uid!).child(childIWantToRemove).removeValue { (error, ref) in
            if error != nil {
                print(error!)
            }
        }
        
        requestTable.reloadData()
    }


    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        requestTable.delegate = self
        requestTable.dataSource = self

        requestTable.register(UINib(nibName: "FriendRequestCell", bundle: nil), forCellReuseIdentifier: "requestCell")

        self.buttonEnaDis(set: false)
        alphaOfDisplay(alphaInFloat: 0)
        messageToUser.alpha = 0
        
        retrieveMessagesFromRequest()
        findOurUserName()
        
        self.hideKeyboardWhenTappedAround()
        
        requestTableView.frame.origin.x = 375

        
        // Do any additional setup after loading the view.
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
