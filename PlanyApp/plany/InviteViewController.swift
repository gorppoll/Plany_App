//
//  InviteViewController.swift
//  CalendarForInviti
//
//  Created by Gop on 10/12/2560 BE.
//  Copyright © 2560 gopGorppol. All rights reserved.
//

import UIKit
import Firebase
import ChameleonFramework
import SVProgressHUD

class InviteViewController: UIViewController, UITableViewDelegate, UITableViewDataSource,UISearchBarDelegate, UITextFieldDelegate {

    let uid = FIRAuth.auth()?.currentUser?.uid
    
    let refToFriend = FIRDatabase.database().reference().child("Friend")

    let refToFindUserName = FIRDatabase.database().reference().child("FindUserName")
   
    let refToAccount = FIRDatabase.database().reference().child("Account")
   
    var friendUsernameArray = [String]()
    
    var timeStore : String = "nil"
    
    var dateStore : String = "nil"
    
    var yearStore : String = "nil"
    
    var selectedFriendsUsername = [String]()
    var selectedFriendsId = [String]()
    var selectedFriendsTransfer = [FriendTransfer]()
    var selectedFriendsTransferToSend = [FriendTransfer]()
    
    var selectedFriendsUsernameToSend = [String]()
    var selectedFriendsIdToSend = [String]()

    
    
    @IBOutlet weak var calendarImageView: UIView!
    var ourUserName: String = "nil"
    
    var friendArray = [FriendTransfer]()
    
    var friendUsername : String = "nil"
    
    var fullDateStore : String = ""
    
    var tempFriendStore = FriendTransfer()
    
    var dataAry = [String]() //for searchBar Display
    
    let viewOrigin = 400
    
    var onOffFriendTable = true
    
    var storeUserId = "nil"
    
    var onOff = true
    
    let dateFormatter = DateFormatter()
    
    @IBOutlet weak var textFieldView: UIView!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var toWhomLabel: UILabel!
    
    @IBOutlet weak var dateTimeView: UIView!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var descriptionTextField: UITextView!

    
    @IBOutlet weak var placeView: UIView!
    
    @IBOutlet weak var placeTextField: UITextField!
    @IBOutlet weak var toFriendView: UIView!
    
    // @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var descriptionView: UIView!
   
    @IBOutlet weak var friendTableView: UITableView!
   
    @IBOutlet weak var searchFriendView: UIView!
    
    @IBOutlet weak var datePickerView: UIView!
    
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBAction func friendDonebutton(_ sender: Any) {
        
        toLabelBox()
        hideSearchFriendView()
        
    }
    @IBAction func friendButton(_ sender: Any) {
        
        
        if onOffFriendTable == true{
        
        self.friendTableView.reloadData()

        showSearchFriendView()
            
       // onOffFriendTable = false
            
        }else{
        
        hideSearchFriendView()
            
       // onOffFriendTable = true

        
        }
        
        
    }
    
    func initiationDesign(){
        
        mainView.layer.cornerRadius = 15;
        mainView.layer.masksToBounds = true;
        
        
        titleTextField.layer.cornerRadius = 10
        titleTextField.layer.borderColor = UIColor.lightGray.cgColor
        
        mainView.layer.masksToBounds = true
        
        toFriendView.layer.borderWidth = 1
        toFriendView.layer.borderColor = UIColor.lightGray.cgColor
        toFriendView.layer.cornerRadius = 10;
        toFriendView.layer.masksToBounds = true;
        toFriendView.backgroundColor = UIColor.white
        
        textFieldView.layer.borderWidth = 1
        textFieldView.layer.borderColor = UIColor.lightGray.cgColor
        textFieldView.layer.cornerRadius = 10;
        textFieldView.layer.masksToBounds = true;
        textFieldView.backgroundColor = UIColor.white
        
        descriptionTextField.layer.borderColor = UIColor.lightGray.cgColor
        descriptionTextField.backgroundColor = UIColor.white
        
        descriptionView.layer.borderColor = UIColor.lightGray.cgColor
        descriptionView.layer.borderWidth = 1
        descriptionView.layer.cornerRadius = 10;
        descriptionView.layer.masksToBounds = true;
        descriptionView.backgroundColor = UIColor.white
        
        dateTimeView.layer.borderWidth = 1
        dateTimeView.layer.cornerRadius = 10
        dateTimeView.layer.masksToBounds = true;
        dateTimeView.backgroundColor = UIColor.lightGray
        dateTimeView.alpha = 1
        dateTimeView.layer.borderColor = UIColor.lightGray.cgColor
        
        placeView.layer.borderWidth = 1
        placeView.layer.cornerRadius = 10
        placeView.layer.masksToBounds = true;
        placeView.backgroundColor = UIColor.white
        placeView.layer.borderColor = UIColor.lightGray.cgColor

    }
    
    func initiationCoordinate(){
    
        datePickerView.frame.origin.x = CGFloat(viewOrigin)
        
        datePickerView.frame.origin.y = CGFloat(160)
        
        searchFriendView.frame.origin.x = CGFloat(22)
        
        searchFriendView.frame.origin.y = CGFloat(264)

        searchFriendView.layer.borderColor = UIColor.lightGray.cgColor
        searchFriendView.layer.borderWidth = 1
        searchFriendView.layer.cornerRadius = 10
    
    }

    @IBAction func dateButton(_ sender: UIButton) {

        UIView.animate(withDuration: 0.4){
            
            self.datePickerView.frame.origin.x = CGFloat(0)
            
            self.onOff = true
            
            
        }
        
    }
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
//    @IBAction func submitButton(_ sender: UIButton) {
//        
//        
//        
//        
//        
//        friendTableView.reloadData()
//        
//        toLabelBox()
//       
//        hideSearchFriendView()
//        
//
//    }
    
    func displayTimeDate(){
    
    
        dateFormatter.dateFormat = "MMM dd, yyyy"
        
        let strDateToDis = dateFormatter.string(from: datePicker.date)
        
        
        print(strDateToDis)
        
        dateFormatter.dateFormat = "HH:mm"
        
        let strTimeToDis = dateFormatter.string(from: datePicker.date)
        
        timeStore = strTimeToDis
        
        print(strTimeToDis)
        
        dateLabel.text = strDateToDis
        timeLabel.text = strTimeToDis
    
    
    }
   
    func storeDateToSend(){
    
        dateFormatter.dateFormat = "MMM. dd"
        
        let strDateToDis = dateFormatter.string(from: datePicker.date)
        
        dateStore = strDateToDis
        
        dateFormatter.dateFormat = "yyyy"
        
        let strYear = dateFormatter.string(from: datePicker.date)
        
        yearStore = strYear

    }
    
    
    @IBAction func buttonDone(_ sender: Any) {
        
 
        displayTimeDate()
        
        UIView.animate(withDuration: 0.4){
            
            self.datePickerView.frame.origin.x = CGFloat(self.viewOrigin)
            
            self.onOff = false
            
        }

        
    }
    
    
    func localToUTC(time : String, date: String, year: String) -> String {
        
        let str = "\(date) \(year) \(time)"
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM.dd yyyy HH:mm"
        dateFormatter.calendar = NSCalendar.current
        dateFormatter.timeZone = TimeZone.current
        
        let dt = dateFormatter.date(from: str)
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        dateFormatter.dateFormat = "MMM.dd yyyy HH:mm"
        
        print(dt!)
        
        return dateFormatter.string(from: dt!)
    }

    
    @IBAction func mainSubmitButton(_ sender: UIButton) {
        
        
       
        if toWhomLabel.text == "Friends" || toWhomLabel.text == "No Selected Friend" || toWhomLabel.text == "" {
        
            toWhomLabel.text = "No Selected Friend"
            print("before return")

            return
        }
        
        
        
        SVProgressHUD.show()
        
        storeDateToSend()
        
        
        let fullDateTimeStr = localToUTC(time: timeStore, date: dateStore, year: yearStore)
        
        var messageDictionary = [
            "Sender": ourUserName,
            "Description": descriptionTextField.text!,
            "Title": titleTextField.text!,
            "Place": placeTextField.text!,
            "MessageId" : "nil",
            "SenderId" : uid,
            "Status" : "pending",
            "Read" : "false",
            "Probability" : "nil",
            "Img": "Default",
            "FullDateTimeStore" : fullDateTimeStr
        ]
    //not working
        
        for element in selectedFriendsTransferToSend{
            
        let messagesDBToOther = refToAccount.child(element.friendId).child("Notification")
        let messagesDB = refToAccount.child(uid!).child("Notification")

        
        let reference = messagesDB.childByAutoId()
        
        messageDictionary["MessageId"] = reference.key
       
        //sended to self

        
        var messageDictionaryToSelf = messageDictionary
        
        messageDictionaryToSelf["Sender"] = element.friendUserName
        
        messageDictionaryToSelf["Status"] = "sendedSelf"
        
        reference.setValue(messageDictionaryToSelf) {
            (error, ref) in
            
            if error != nil {
                print(error!)
            }
            else {
                print("Message send to ourself successfully")
                
            }
        }
        // sended to other
        let referenceToOther = messagesDBToOther.child(reference.key)
        
        referenceToOther.setValue(messageDictionary) {
            (error, ref) in
            
            if error != nil {
                print(error!)
            }
            else {
                print("Message send out successfully")
                
                SVProgressHUD.dismiss()
                
                self.navigationController?.popViewController(animated: true)
                self.dismiss(animated: true, completion: nil)
                
            }
            
            }
            
        }
        
        
       
        
       
       
//        navigationController?.popViewController(animated: true)
//        dismiss(animated: true, completion: nil)
        

     }
    
    
    func retrieveFriendFromFir(){
        
        friendArray.removeAll()
        
        let messageDB = refToFriend.child(uid!)
        
        messageDB.observe(.childAdded, with: { (snapshot) in
            
            let snapshotValue = snapshot.value as! Dictionary<String, String>
            
            let friendId = snapshotValue["FriendId"]!
            let friendUserName = snapshotValue["FriendUserName"]!
            
            
            let store = FriendTransfer()
            store.friendId = friendId
            store.friendUserName = friendUserName
            
            print(store.friendUserName)
            
            self.generateSelectedFriendStore()
            self.friendArray.append(store)
            self.friendUsernameArray.append(friendUserName) //appends friends username to array
            self.friendTableView.reloadData()
        })
        
        


    }

    func generateSelectedFriendStore(){
    
        let store = FriendTransfer()
        store.friendId = "nil"
        store.friendUserName = "nil"
        selectedFriendsTransfer.append(store)
    
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = friendTableView.dequeueReusableCell(withIdentifier: "customFriendCell", for: indexPath) as! friendTableViewCell
        
       
        let contain = friendUsernameArray[indexPath.row]
        
        cell.userNameLabel.text = contain
        
        cell.accessoryType = cell.isSelected ? .checkmark : .none
        cell.selectionStyle = .none
        return cell
    }
    
    
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
    
        selectedFriendsTransfer[indexPath.row].friendUserName = friendArray[indexPath.row].friendUserName
        selectedFriendsTransfer[indexPath.row].friendId = friendArray[indexPath.row].friendId
        
       
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        
        tableView.cellForRow(at: indexPath)?.accessoryType = .none
        
        
        selectedFriendsTransfer[indexPath.row].friendUserName = "nil"
        selectedFriendsTransfer[indexPath.row].friendId = "nil"
        
        
        
    }
    
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return friendUsernameArray.count
        
    }

    
    
    func toLabelBox(){
       
        var storeStr: String = ""
        
        selectedFriendsTransfer = selectedFriendsTransfer.filter{$0.friendUserName != "nil"}


        
        for element in selectedFriendsTransfer{
        
            storeStr.append("\(element.friendUserName)  ")
            
        }
        
        print(selectedFriendsTransfer.count)
        
        toWhomLabel.text = storeStr

        selectedFriendsTransferToSend = selectedFriendsTransfer
        
        selectedFriendsTransfer.removeAll()
        
        selectedFriendsArrayRenew()
        
    }
   
    func selectedFriendsArrayRenew(){
    
        for element in friendArray{
        
        generateSelectedFriendStore()
        
        }
    
    }
    
    
    
    
    func showSearchFriendView(){
    
        
        searchFriendView.isHidden = false
        UIView.animate(withDuration: 0.4, animations: {
            self.searchFriendView.alpha = 1
        }, completion:  nil)
    
        onOffFriendTable = false
        
    }
    
    func hideSearchFriendView(){
    
        
        UIView.animate(withDuration: 0.4/*Animation Duration second*/, animations: {
            self.searchFriendView.alpha = 0
        }, completion:  {
            (value: Bool) in
            self.searchFriendView.isHidden = true
        })

        onOffFriendTable = true

    
    }
    
    func findUserName(userId: String){
        
        refToFindUserName.child(uid!).observe(.value, with: { (snapshot) in
            
            if let snapshotValue = snapshot.value as? Dictionary<String,String> {
                
                self.ourUserName = snapshotValue["Username"]!
                
                
            }
        })
        
    }


    override func viewDidLoad() {
        super.viewDidLoad()

       initiationCoordinate()

        friendTableView.delegate = self
        friendTableView.dataSource = self
        
        hideSearchFriendView()

        displayTimeDate()
        
        friendTableView.register(UINib(nibName: "friendTableViewCell", bundle: nil), forCellReuseIdentifier: "customFriendCell")
        

        
        friendTableView.allowsMultipleSelection = true

        self.hideKeyboardWhenTappedAround()
        
        
        retrieveFriendFromFir()
        
        guard let uid = FIRAuth.auth()?.currentUser?.uid else {
            return
        }

        findUserName(userId: uid)

        initiationDesign()
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        
        swipeRight.direction = UISwipeGestureRecognizerDirection.right
        self.view.addGestureRecognizer(swipeRight)

        
        }
    
    
    func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            
            
            switch swipeGesture.direction {
            case UISwipeGestureRecognizerDirection.right:
                navigationController?.popViewController(animated: true)
                
                dismiss(animated: true, completion: nil)
                
                print("Swiped right")
            default:
                break
            }
        }
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
