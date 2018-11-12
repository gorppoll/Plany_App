//
//  ViewControllerThird.swift
//  inviti
//
//  Created by Gop on 10/6/2560 BE.
//  Copyright © 2560 gopGorppol. All rights reserved.
//

import UIKit
import Firebase
import ChameleonFramework


class ViewControllerThird: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate,UITextFieldDelegate {
   
    let uid = FIRAuth.auth()?.currentUser?.uid

    let refToFriend = FIRDatabase.database().reference().child("Friend")
    var storeArray = [FriendTransfer]()
    
    @IBOutlet weak var datePicker: UIDatePicker!

    @IBOutlet weak var timeTextField: UITextField!
    
    @IBOutlet weak var descriptionTextField: UITextField!
    
    var storeChosenNumber: Int = 0
    
    let refToAccount = FIRDatabase.database().reference().child("Account")
    
    
    
    var nameArray = ["Deaw","Gop"]
    
    @IBAction func buttonSubmit(_ sender: Any) {
        
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd"
        let selectedDate = dateFormatter.string(from: datePicker.date) // selected date variable
        print(selectedDate)
        
        
        //TODO: Send the message to Firebase and save it in our database
        let name = chosenName()
        
        if (timeTextField == nil) {
        
            timeTextField.text = " "
        
        }
        
        if (descriptionTextField == nil){
        
            descriptionTextField.text = " "
        }
        
        let messagesDBOther = refToAccount.child(name).child("Notification")
        let messagesDB = refToAccount.child(uid!).child("Notification")
        
        var messageDictionary = [
            "Sender": FIRAuth.auth()?.currentUser?.email,
            "Description": descriptionTextField.text!,
            "Time": timeTextField.text!,
            "Date": selectedDate,
            "MessageId" : "nil",
            "SenderId" : uid,
            "Status" : "sendedSelf"
        ]
        
     
        let reference = messagesDB.childByAutoId()
        
        messageDictionary["MessageId"] = reference.key
        
        reference.setValue(messageDictionary) {
            (error, ref) in
            
            if error != nil {
                print(error!)
            }
            else {
                print("Message send out successfully")
            
            }
        }
        
        
        let referenceToOther = messagesDBOther.child(reference.key)
        
        messageDictionary["Status"] = "pending"
        
        referenceToOther.setValue(messageDictionary) {
            (error, ref) in
            
            if error != nil {
                print(error!)
            }
            else {
                print("Message saved to Own successfully")
                
            }
        }
        
        
    }

    
   
    
    @IBOutlet weak var namePicker: UIPickerView!
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return storeArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return storeArray[row].friendUserName
        
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        print(row)
        
        storeChosenNumber = row
        
        }
    
    func chosenName()-> String{
    
        if storeChosenNumber == 0{
        
            return "AWXCva2TRCaWYbSd95sXu84tB8Q2" // Deaw id
        
        }else{
        
            return "VI5M47jMCUe7TuCwa9xtnutHhpn1" // Gop id
        
        }
    
    }
    
    func retrieveFriendFromFir(){
        
        storeArray.removeAll()
        
        let messageDB = refToFriend.child(uid!)
        
        messageDB.observe(.childAdded, with: { (snapshot) in
            
            let snapshotValue = snapshot.value as! Dictionary<String, String>
            
            let friendId = snapshotValue["FriendId"]!
            let friendUserName = snapshotValue["FriendUserName"]!
            
            
            let store = FriendTransfer()
            store.friendId = friendId
            store.friendUserName = friendUserName
            
            print(store.friendUserName)
            
            self.storeArray.append(store)
            
            self.namePicker.reloadAllComponents()
        })
        
    }

    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        namePicker.delegate = self
        namePicker.dataSource = self
        
        timeTextField.delegate = self
        descriptionTextField.delegate = self
       
        self.hideKeyboardWhenTappedAround()
        
        retrieveFriendFromFir()


        guard let uid = FIRAuth.auth()?.currentUser?.uid else {
            return
        }
        
        print(uid)
        // Do any additional setup after loading the view.
    }
    
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        self.view.endEditing(true) //This will hide the keyboard
//    }

    
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
