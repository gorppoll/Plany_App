//
//  SecondViewController.swift
//  inviti
//
//  Created by Gop on 10/6/2560 BE.
//  Copyright © 2560 gopGorppol. All rights reserved.
//  Working

import UIKit
import Firebase
import ChameleonFramework



class SecondViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    let refToAccount = FIRDatabase.database().reference().child("Account")
    
    let uid = FIRAuth.auth()?.currentUser?.uid

    let sideTabOrigin = 375
    
    var onOff: Bool = true
    
    var indexPathRowNumber : Int = 0
    
    var messageArray = [Transfer]()
    var toMainArray = [Transfer]()
    var waitStore = [Transfer]()
    
    @IBOutlet weak var myBoardNotifView: UIView!

    @IBOutlet weak var myBoardNotifBarView: UIView!
    
    
    let refreshControl = UIRefreshControl()

    
    @IBOutlet weak var tableViewMain: UITableView!

    @IBOutlet weak var tableViewMainSide: UITableView!
    
    @IBOutlet weak var detailView: UIView!
    @IBOutlet weak var detailSenderLabel: UILabel!
    
    @IBOutlet weak var detailTitleLabel: UILabel!
    
    @IBOutlet weak var detailStatusView: UIView!
    
    @IBOutlet weak var detailDateLabel: UILabel!
    
    @IBOutlet weak var detailProbability: UILabel!
    
    @IBOutlet weak var detailTimeLabel: UILabel!
    
    @IBOutlet weak var detailReadLabel: UILabel!
    @IBOutlet weak var detailStatusAccept: UIButton!
    
    @IBOutlet weak var detailButtonView: UIView!
    
    @IBOutlet weak var detailDescriptionLabel: UILabel!
    
    @IBOutlet weak var detailStatusDelete: UIButton!

    @IBOutlet weak var detailViewBackgroundBut: UIButton!
    
    @IBOutlet weak var mainTableView: UIView!
    @IBOutlet weak var probabilityView: UIView!
    
    @IBOutlet weak var probabilitySlider: UISlider!
    
    @IBOutlet weak var probabilityLabel: UILabel!
    
    @IBOutlet weak var notificationButton: UIButton!
    
    @IBOutlet weak var myBoardButton: UIButton!
    
    @IBAction func probabilityClose(_ sender: UIButton) {
        
        
        hideProbabilityView()
        
    }
    
    @IBAction func probabilitySendBut(_ sender: UIButton) {
        
        let str = probabilityLabel.text!
        
        maybeTableViewMainSide(indexPathRow: indexPathRowNumber, probability: str)
        
        
        hideProbabilityView()
    }
    
    @IBAction func probabilityNoBut(_ sender: UIButton) {
        
        acceptTableViewMainSide(indexPathRow: indexPathRowNumber)

        hideProbabilityView()
    }
    
    @IBAction func probabilitySlider(_ sender: UISlider) {
        
        let x = Int(sender.value)
        
        probabilityLabel.text = "\(x)%"
        
        
    }
    
    
    
    
    
    @IBAction func detailViewBackgroundBut(_ sender: UIButton) {
        
        hideDetailView()
        
    }

    
    @IBOutlet weak var detailCancelButtonMain: UIButton!
    
    @IBAction func detailCancelButtonMain(_ sender: UIButton) {
        
        cancelTableViewMain(indexPathRow: indexPathRowNumber)
        
        hideDetailView()

        
    }
    @IBAction func detailDeclineButton(_ sender: UIButton) {
        
        declineTableViewMainSide(indexPathRow: indexPathRowNumber)

        hideDetailView()

        print("declinePress")

        
    }
    
    @IBAction func detailCloseButton(_ sender: UIButton) {
        
        hideDetailView()
        
    }
    @IBAction func detailAcceptButton(_ sender: UIButton) {
        
        acceptTableViewMainSide(indexPathRow: indexPathRowNumber)
        
        hideDetailView()
        
    }
    

    
    
    @IBAction func detailStatusAccept(_ sender: Any) {
        
        moveToMainFromSide(indexPathRow: indexPathRowNumber)
        hideDetailView()

        
    }
    
    
    @IBAction func detailStatusDelete(_ sender: UIButton) {
        
        deleteTableViewMainSide(indexPathRow: indexPathRowNumber)
        
        hideDetailView()

    }
    
    @IBAction func detailMaybeButton(_ sender: UIButton) {
        
        hideDetailView()
        showProbabilityView()
        print("MaybePress")

    }
   
    
    
    
    @IBOutlet weak var sideTab: UIView!
    
    @IBAction func logoutButton(_ sender: Any) {
        
        do {
            try FIRAuth.auth()?.signOut()
        }
        catch {
            print("error: there was a problem signing out")
        }
        
        guard (navigationController?.popToRootViewController(animated: true)) != nil
            else {
                print("No View Controllers to pop off")
                return
        }
        

        
    }
    
    
    @IBAction func buttonInvite(_ sender: Any) {
        
        self.performSegue(withIdentifier: "homeToInvite", sender: self)
    }
    
    @IBAction func addButton(_ sender: Any) {
        
        self.performSegue(withIdentifier: "homeToAddPage", sender: self)
        
    }
    
    @IBAction func sideTabButtonClose(_ sender: Any) {
        
        UIView.animate(withDuration: 0.5){
            
            self.sideTab.frame.origin.x = CGFloat(self.sideTabOrigin)
            
            self.onOff = true
            
            
        }

        
    }
    
        
    func showDetailView(status: String, mode: String){
        //tableViewMainSide
        
        detailView.isHidden = false
        detailViewBackgroundBut.isHidden = false

        
        UIView.animate(withDuration: 0.4, animations: {
            
            self.detailViewBackgroundBut.alpha = 1
            self.detailView.alpha = 1
            
        }, completion:  nil)
        
        detailButtonView.isHidden = true //situation on Pending
        detailStatusView.isHidden = true //UI view for accept and delete
        detailStatusAccept.isHidden = true // accept button
        detailStatusDelete.isHidden = true // delete button
        detailCancelButtonMain.isHidden = true // cancel button


        if mode == "tableViewMainSide"{
            
            
            if status == "sendedSelf"{
            
                detailStatusView.isHidden = false //UI view for accept and delete
                
            
            }else if status == "accepted" || status == "terminated" || status == "maybe"{
          
                detailStatusView.isHidden = false
                detailStatusAccept.isHidden = false
              

                
            
            }else if status == "pending"{
            
                detailButtonView.isHidden = false
                
            }else{
            
                //sendedSelf
                detailStatusView.isHidden = false
                
                detailStatusDelete.isHidden = false
            
            
            
            }
//TableViewMain
        }else{
            
            detailStatusView.isHidden = false
        
            detailCancelButtonMain.isHidden = false
            
        
        }
        
        
    }
    
    func hideDetailView(){
        
        
        UIView.animate(withDuration: 0.4/*Animation Duration second*/, animations: {
            self.detailView.alpha = 0
            self.detailViewBackgroundBut.alpha = 0
        }, completion:  {
            (value: Bool) in
            self.detailView.isHidden = true
            self.detailViewBackgroundBut.isHidden = true
        })
        
    }
    
    
    
    func showProbabilityView(){
    
        
            probabilityView.isHidden = false
            
            UIView.animate(withDuration: 0.4, animations: {
                
                print("Show")
            self.probabilityView.alpha = 1
                
            }, completion:  nil)
    
    }
    
    
    
    func hideProbabilityView(){
    
        UIView.animate(withDuration: 0.4/*Animation Duration second*/, animations: {
            self.probabilityView.alpha = 0
            
        }, completion:  {
            (value: Bool) in
            self.probabilityView.isHidden = true
            
        })
        
    }
    
    func setDetailViewOrigin(x : Int, y: Int){
    
        
   
        
        detailView.frame.origin.x = CGFloat(x)
        detailView.frame.origin.y = CGFloat(y)

    
    
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        retrieveMessagesToSide2()
        retrieveMessagesToMain()
    
    }
    
       
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableViewMain.delegate = self
        tableViewMain.dataSource = self
        
        tableViewMainSide.delegate = self
        tableViewMainSide.dataSource = self
        
        self.tableViewMainSide.rowHeight = 75
       
        self.tableViewMain.rowHeight = 55


        
        initiationDesign()

        // Do any additional setup after loading the view.
        
        tableViewMain.register(UINib(nibName: "CustomCellMain", bundle: nil), forCellReuseIdentifier: "customTimeCell")
        
        tableViewMainSide.register(UINib(nibName: "CustomCellMainSide", bundle: nil), forCellReuseIdentifier: "sideCellMain")
        
        
        
        
        //retrieveMessagesToSide2()
        //retrieveMessagesToMain()
        
//       var timer = Timer.scheduledTimer(timeInterval: 15, target: self,selector: Selector("execute"), userInfo: nil, repeats: true)
        
        tableViewMainSide.reloadData()
        
        refreshControl.addTarget(self, action: #selector(didPullToRefresh), for: .valueChanged)
        
        tableViewMainSide.addSubview(refreshControl)
        
        detailView.isHidden = true
        detailView.alpha = 0
        
       detailViewBackgroundBut.isHidden = true
       detailViewBackgroundBut.alpha = 0
        
        probabilityView.isHidden = true
        probabilityView.alpha = 0
        
        detailViewBackgroundBut.frame.origin.x = 0
        detailViewBackgroundBut.frame.origin.y = 64
        
        detailReadLabel.alpha = 0
        detailProbability.alpha = 0

       let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeLeft.direction = UISwipeGestureRecognizerDirection.left
        self.view.addGestureRecognizer(swipeLeft)
        
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeDown.direction = UISwipeGestureRecognizerDirection.down
        self.view.addGestureRecognizer(swipeDown)
        
       
    }
    

// MARK: - Swipe gesture

func respondToSwipeGesture(gesture: UIGestureRecognizer) {
    
    if let swipeGesture = gesture as? UISwipeGestureRecognizer {
        
        
        switch swipeGesture.direction {
      
        case UISwipeGestureRecognizerDirection.down:
            print("Swiped down")
        case UISwipeGestureRecognizerDirection.left:
            self.performSegue(withIdentifier: "homeToInvite", sender: self)

            print("Swiped left")
        case UISwipeGestureRecognizerDirection.up:
            print("Swiped up")
        default:
            break
        }
    }

    
       // detailDescriptionLabel.sizeToFit()
    
}
    
   
    func didPullToRefresh() {
        
        retrieveMessagesToSide2()
        
        
    }
    
    
//    func execute() {
//        
//        retrieveMessagesToSide2()
//        
//    }
    // MARK: - TableCell
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if (tableView == tableViewMain) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "customTimeCell", for: indexPath) as! CustomCellMain
        
            cell.cellBackground.alpha = 0
            
            cell.Title.text = toMainArray[indexPath.row].title
            
            cell.Username.text = toMainArray[indexPath.row].sender
            
            cell.Date.text = toMainArray[indexPath.row].date
            
            cell.Time.text = toMainArray[indexPath.row].time
            

            if toMainArray[indexPath.row].status == "terminated"{
                
                cell.cellBackground.alpha = 1
                
                return cell

            }else{
            
                cell.cellBackground.alpha = 0
        
                return cell
            }
            
        
        } else {
    //Mark: Cell Display
            // tableView == tableViewmainside
        
            let cell2 = tableViewMainSide.dequeueReusableCell(withIdentifier: "sideCellMain", for: indexPath) as! CustomCellMainSide
            
            cell2.Sender.text = messageArray[indexPath.row].sender
            
            cell2.Date.text = messageArray[indexPath.row].date
            
            cell2.Time.text = messageArray[indexPath.row].time
            
            cell2.Title.text = messageArray[indexPath.row].title
            
            if messageArray[indexPath.row].place != ""{
            
                cell2.Place.text = "@ \(messageArray[indexPath.row].place)"
            
            }else{
            
                cell2.Place.text = ""
                
            }
        
            
            //Initiation of Cell
            cell2.notification.backgroundColor = UIColor.cyan
            cell2.notification.layer.borderWidth = 2
            cell2.notification.layer.borderColor = UIColor.cyan.cgColor

            cell2.read.backgroundColor = UIColor.yellow
            cell2.read.layer.borderWidth = 2
            cell2.read.layer.borderColor = UIColor.yellow.cgColor

            cell2.notification.alpha = 0
            cell2.sended.alpha = 0
            cell2.read.alpha = 0

            let read = messageArray[indexPath.row].read

            
            if messageArray[indexPath.row].status == "pending"{
            // didn't read
                cell2.notification.alpha = 1

                if read == "false"{
                    
                cell2.notification.backgroundColor = UIColor.cyan
                
                }else{
                
                cell2.notification.backgroundColor = UIColor.white
                    
                }
            
            } else if (messageArray[indexPath.row].status == "accepted" || messageArray[indexPath.row].status == "terminated"){
            
                cell2.sended.alpha = 1
                cell2.sended.backgroundColor = UIColor.green
               
            
            }else if messageArray[indexPath.row].status == "rejected"{
            
                cell2.sended.alpha = 1
                cell2.sended.backgroundColor = UIColor.red
            
            
            }else if messageArray[indexPath.row].status == "sendedSelf"{
            // sended self and waiting
                cell2.read.alpha = 1
                cell2.sended.alpha = 1
                cell2.sended.backgroundColor = UIColor.yellow

                //not yet read
                if read == "false" {
                    
                    cell2.read.backgroundColor = UIColor.yellow
                }else{
                    
                    cell2.read.backgroundColor = UIColor.white
                
                }
            
            }else{
            
                cell2.read.alpha = 0
                cell2.sended.alpha = 1
                cell2.sended.backgroundColor = UIColor.yellow
            
            }
            
            
            return cell2
        }
        
        
    }
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
//    {
//        
//        if tableView == tableViewMainSide{
//        
//            return 70 //Choose your custom row height
//        
//        }else{
//        
//        
//        return 50
//        
//        }
//    
//        
//    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        indexPathRowNumber = indexPath.row
        
        if tableView == tableViewMainSide{
            
            let readOrNot = messageArray[indexPath.row].read
            let currentStatus = messageArray[indexPath.row].status
            
            if readOrNot == "false" && currentStatus == "pending"{
                
                    messageArray[indexPath.row].read = "true"
                refToAccount.child(messageArray[indexPath.row].senderId).child("Notification").child(self.messageArray[indexPath.row].messageId).updateChildValues(["Read": "true"])
               
                refToAccount.child(uid!).child("Notification").child(self.messageArray[indexPath.row].messageId).updateChildValues(["Read": "true"])
                
                
                print("Read Or not")
                
            }
            
            showDetailView(status: messageArray[indexPath.row].status, mode: "tableViewMainSide")
        
            showSelectedRowInDetailView(indexPathRow: indexPath.row, array: messageArray, read: messageArray[indexPath.row].read)
            
            tableViewMainSide.reloadData()

        }else{
        

            
            showDetailView(status: toMainArray[indexPath.row].status, mode: "tableViewMain")
            
            showSelectedRowInDetailView(indexPathRow: indexPath.row, array: toMainArray, read: "None")
        
        
        }
        

        
    }

    func showSelectedRowInDetailView(indexPathRow: Int, array: [Transfer] , read: String){
    
        detailDateLabel.text = array[indexPathRow].date
        detailDescriptionLabel.text = array[indexPathRow].description
        detailTimeLabel.text = array[indexPathRow].time
        detailSenderLabel.text = array[indexPathRow].sender
        detailTitleLabel.text =  array[indexPathRow].title
        
        ifReadIsTrue(read: read)
        displayProbability(prob: array[indexPathRow].probability)
    
    }
    
    func ifReadIsTrue(read: String){
        
        if read == "true"{
            
            detailReadLabel.alpha = 1
            
        }else{
            
            detailReadLabel.alpha = 0
            
        }
    }
    
    func displayProbability(prob: String){
    
        if prob == "nil"{
        
        detailProbability.alpha = 0

        
        }else{
        
        detailProbability.alpha = 1
        detailProbability.text = prob
        
        
        }
    
    
    
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func declineTableViewMainSide (indexPathRow: Int){
    
        refToAccount.child(self.messageArray[indexPathRow].senderId).child("Notification").child(self.messageArray[indexPathRow].messageId).updateChildValues(["Status": "rejected"])
        
        
        myDeleteFunction(firstTree: "Notification", childIWantToRemove: self.messageArray[indexPathRow].messageId)
        
        messageArray.remove(at: indexPathRow)
        
        print("DeclinePRess")
        
        tableViewMainSide.reloadData()
    
    }
    
    func acceptTableViewMainSide (indexPathRow: Int){
    
            storeNotiToWhere(Where: "toMain", indexPathRow: indexPathRow)

        
        //update status(accept) to other device
        
        refToAccount.child(self.messageArray[indexPathRow].senderId).child("Notification").child(self.messageArray[indexPathRow].messageId).updateChildValues(["Status": "accepted","SenderId": self.uid!])

        
        
        // not sure if it's safe or not
        refToAccount.child(self.uid!).child("toMain").child(self.messageArray[indexPathRow].messageId).updateChildValues(["Status": "accepted"])
        
        
        myDeleteFunction(firstTree: "Notification", childIWantToRemove: self.messageArray[indexPathRow].messageId)
        

        messageArray.remove(at: indexPathRow)
        
        //tableViewMain.reloadData()
        tableViewMainSide.reloadData()
        

        
    }
    
    func dateSort(){
    
        var convertedArray: [Date] = []
        
        var dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM.dd yyyy HH:mm"// yyyy-MM-dd"
        
        for dat in toMainArray {
            
            let str = "\(dat.fullDateTimeStore)"
            
            let date = dateFormatter.date(from: str)
            if let date = date {
                
                print(date)
                convertedArray.append(date)
                
                dat.dateInFormDate = date
            
            }
        
        }
        
        
        toMainArray.sort(by: { $0.dateInFormDate?.compare($1.dateInFormDate!) == .orderedAscending })

    
    }
    
    func maybeTableViewMainSide(indexPathRow : Int, probability: String){
        
            messageArray[indexPathRow].probability = probability
        
             storeNotiToWhere(Where: "toMain", indexPathRow: indexPathRow)
        
        refToAccount.child(self.messageArray[indexPathRow].senderId).child("Notification").child(self.messageArray[indexPathRow].messageId).updateChildValues(["SenderId": self.uid!,"Probability": probability,"Status": "maybe"])
        
        
        // not sure if it's safe or not
        refToAccount.child(self.uid!).child("toMain").child(self.messageArray[indexPathRow].messageId).updateChildValues(["Status": "maybe"])
            
        refToAccount.child(self.uid!).child("toMain").child(self.messageArray[indexPathRow].messageId).updateChildValues(["Probability": probability])
        
        
        
        myDeleteFunction(firstTree: "Notification", childIWantToRemove: self.messageArray[indexPathRow].messageId)
        
      

        self.messageArray.remove(at: indexPathRow)
        
        self.tableViewMain.reloadData()
        self.tableViewMainSide.reloadData()
        

    
    
    }
    
    func moveToMainFromSide(indexPathRow: Int){
    
        storeNotiToWhere(Where: "toMain", indexPathRow: indexPathRow)
        
        
        myDeleteFunction(firstTree: "Notification", childIWantToRemove: messageArray[indexPathRow].messageId)
        
        self.messageArray.remove(at: indexPathRow)
        
       // self.tableViewMain.reloadData()
        self.tableViewMainSide.reloadData()
        


    
    }
    
    func deleteTableViewMainSide(indexPathRow : Int){
    
        self.myDeleteFunction(firstTree: "Notification", childIWantToRemove: messageArray[indexPathRow].messageId)
        
        self.messageArray.remove(at: indexPathRow)
        
        self.tableViewMainSide.reloadData()

    
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        
        if (tableView == tableViewMainSide) {
           
            let status = self.messageArray[indexPath.row].status

            
            if(status == "pending"){
            
                let decline = UITableViewRowAction(style: .destructive, title: "Decline") { (action, indexPath) in
                    // delete item at indexPath
                    
                    self.declineTableViewMainSide(indexPathRow: indexPath.row)
                    

                    }
            
                let accept = UITableViewRowAction(style: .normal, title: "Accept") { (action, indexPath) in

                    self.acceptTableViewMainSide (indexPathRow: indexPath.row)
                
                }
                
                accept.backgroundColor = UIColor.green
                
               

                return [decline, accept]
                
            }else if (status == "sendedSelf"){
            
                let waiting = UITableViewRowAction(style: .normal, title: "Waiting") { (action, indexPath) in
                    // delete item at indexPath
                    
                    
                }

            
                return[waiting]

            
            
            }else if (status == "accepted" || status == "terminated" || status == "maybe"){
            
                
                let moveToMain = UITableViewRowAction(style: .normal, title: "To Board") { (action, indexPath) in
                    
                self.moveToMainFromSide(indexPathRow: indexPath.row)
                    
                    
                }
                
                moveToMain.backgroundColor = UIColor.green
                
                return [moveToMain]

            
            
            
            }else{
            
                let delete = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in
                    // delete item at indexPath
                    
                    self.deleteTableViewMainSide(indexPathRow: indexPath.row)
                    
                }
                
                
                return [delete]
            
            
            }
            
    //tableview == tableViewMain
        }else{
           
            
                let cancel = UITableViewRowAction(style: .destructive, title: "Cancel") { (action, indexPath) in
                    // delete item at indexPath
                    //
              
                    self.cancelTableViewMain(indexPathRow: indexPath.row)
                
            }
            
            
            
            
            return [cancel]
        
        
        }
    }

    func cancelTableViewMain(indexPathRow: Int){
    
        refToAccount.child(self.toMainArray[indexPathRow].senderId).child("toMain").observeSingleEvent(of: .value, with: { (snapshot) in
            
            var tempStore = self.toDictionary(param: self.toMainArray[indexPathRow])
            
            tempStore["Status"] = "terminated"
            
            if snapshot.hasChild(self.toMainArray[indexPathRow].messageId){
                
                self.refToAccount.child(self.toMainArray[indexPathRow].senderId).child("toMain").child(self.toMainArray[indexPathRow].messageId).updateChildValues(tempStore)
                
                self.deletePressedInMainReload(indexPathRow: indexPathRow)
                
                print("User have already accepted and you delete")
                
                
                
            }else{
                
                
                self.refToAccount.child(self.toMainArray[indexPathRow].senderId).child("Notification").child(self.toMainArray[indexPathRow].messageId).updateChildValues(tempStore)
                
                self.deletePressedInMainReload(indexPathRow: indexPathRow)
                
                
                print("User HADN'T Accept and you delete")
                
                
            }
            
        })
    
    }
    
    
    func deletePressedInMainReload(indexPathRow: Int){
    
    
       self.myDeleteFunction(firstTree: "toMain", childIWantToRemove: self.toMainArray[indexPathRow].messageId)
    
        self.toMainArray.remove(at: indexPathRow)
        
        self.tableViewMain.reloadData()

    
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        if tableView == tableViewMain{
        
            return toMainArray.count
        
        }else{
        
            return messageArray.count
            
        }
    }
    
    
    func storeNotiToWhere(Where: String, indexPathRow: Int){
    
        let toMain = self.refToAccount.child(uid!).child(Where)
        
        let selectedInArray = self.messageArray[indexPathRow]
        
        var dictionaryToStore = self.toDictionary(param: selectedInArray)
        
        let reference = toMain.child(selectedInArray.messageId)
        
        dictionaryToStore["MessageId"] = reference.key
        
        reference.setValue(dictionaryToStore) {
            (error, ref) in
            
            if error != nil {
                print(error!)
            }
            else {
                print("Message saved to \(Where) successfully")
                
             self.retrieveMessagesToMain()
                
                
            }
        }
    
    }
    
    
    func separateDateTimeYearFromFullDate(fulldate : String, mode: String)->String{
    
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "MMM.dd yyyy HH:mm"
        
        let str = dateFormatter.date(from: fulldate)
        
        if mode == "Date"{
        dateFormatter.dateFormat = "MMM dd"
            
        }else if mode == "Time"{
            
        dateFormatter.dateFormat = "HH:mm"
            
        }else{
        
        dateFormatter.dateFormat = "yyyy"
            
        }
        print("This is \(str)")
        
        return (dateFormatter.string(from: str!))

    
    }
    

    
    func UTCToLocal(fullDate :String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM.dd yyyy HH:mm"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        
        let dt = dateFormatter.date(from: fullDate)
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = "MMM.dd yyyy HH:mm"
        
        return dateFormatter.string(from: dt!)
    }
    
    // func for reloading upon Viewdidload
    
//    func retrieveMessagesToSide(){
//        
//        messageArray.removeAll()
//        
//        let messageDB = refToAccount.child(uid!).child("Notification")
//        
//            messageDB.observe(.childAdded, with: { (snapshot) in
//                
//                let snapshotValue = snapshot.value as! Dictionary<String, String>
//                
//                
//                let description = snapshotValue["Description"]!
//                let sender = snapshotValue["Sender"]!
//                let date = snapshotValue["Date"]!
//                let time = snapshotValue["Time"]!
//                let messageId = snapshotValue["MessageId"]!
//                let senderId = snapshotValue["SenderId"]!
//                let status = snapshotValue["Status"]!
//                let title = snapshotValue["Title"]!
//                let read = snapshotValue["Read"]!
//                let probability = snapshotValue["Probability"]!
//
//                
//                let message = Transfer()
//                message.sender = sender
//                message.date = date
//                message.description = description
//                message.time = time
//                message.messageId = messageId
//                message.senderId = senderId
//                message.status = status
//                message.title = title
//                message.read = read
//                message.probability = probability
//
//                
//                self.messageArray.append(message)
//                print(message.senderId)
//                
//                self.tableViewMainSide.reloadData()
//        })
//        
//    }
    
    // func for reloading upon refreshing
    
    
    // MARK: - RetrieveMessages To Side 2
    
    func retrieveMessagesToSide2(){

        messageArray.removeAll()
        
        let messageDB = refToAccount.child(uid!).child("Notification")
        
        messageDB.observe(.childAdded, with: { (snapshot) in
            
            let snapshotValue = snapshot.value as! Dictionary<String, String>
            
            let description = snapshotValue["Description"]!
            let sender = snapshotValue["Sender"]!
            let place = snapshotValue["Place"]!
            let messageId = snapshotValue["MessageId"]!
            let senderId = snapshotValue["SenderId"]!
            let status = snapshotValue["Status"]!
            let title = snapshotValue["Title"]!
            let read = snapshotValue["Read"]!
            let probability = snapshotValue["Probability"]!
            var fullDateTimeStr = snapshotValue["FullDateTimeStore"]!

            print(fullDateTimeStr)
            
            fullDateTimeStr = self.UTCToLocal(fullDate: fullDateTimeStr)
            let date = self.separateDateTimeYearFromFullDate(fulldate: fullDateTimeStr, mode: "Date")
            let time = self.separateDateTimeYearFromFullDate(fulldate: fullDateTimeStr, mode: "Time")
            
            let year = self.separateDateTimeYearFromFullDate(fulldate: fullDateTimeStr, mode: "Year")
            
            let message = Transfer()
            
            message.sender = sender
            message.date = date
            message.description = description
            message.time = time
            message.messageId = messageId
            message.senderId = senderId
            message.status = status
            message.title = title
            message.read = read
            message.probability = probability
            message.year = year
            message.fullDateTimeStore = fullDateTimeStr
            message.place = place

            
            var x = 1
            
            self.messageArray.append(message)
            print(message.senderId)
            
            DispatchQueue.main.async() {
                if self.messageArray.isEmpty {
                    
                    print("no")
                    
                    self.refreshControl.endRefreshing()
                    
                }else {
                    print("yes")
                    
                    if x == 1{
                    
                    self.waitStore = self.messageArray
                    
                    var timer2 = Timer.scheduledTimer(timeInterval: 1, target: self,selector: #selector(SecondViewController.execute2), userInfo: nil, repeats: false)
                    
                        x = 2
                    }
                    
                }
            }
            

            
            
        })
        
        
        
        
    }
    
    func execute2 (){

        messageArray = waitStore.reversed()
        
        refreshControl.endRefreshing()
        print("Hellooooo")
        tableViewMainSide.reloadData()

    }

    
    func retrieveMessagesToMain(){
        
        toMainArray.removeAll()
        print(toMainArray.count)
        
        let messageDB = refToAccount.child(uid!).child("toMain")
        
        messageDB.observe(.childAdded, with: { (snapshot) in
            
            let snapshotValue = snapshot.value as! Dictionary<String, String>
            
            let description = snapshotValue["Description"]!
            let sender = snapshotValue["Sender"]!
            //let date = snapshotValue["Date"]!
            //let time = snapshotValue["Time"]!
            let messageId = snapshotValue["MessageId"]!
            let senderId = snapshotValue["SenderId"]!
            let status = snapshotValue["Status"]!
            let title = snapshotValue["Title"]!
            let probability = snapshotValue["Probability"]!
            //let year = snapshotValue["Year"]!
            let place = snapshotValue["Place"]!
            let fullDateTimeStr = snapshotValue["FullDateTimeStore"]!

            

            let date = self.separateDateTimeYearFromFullDate(fulldate: fullDateTimeStr, mode: "Date")
            let time = self.separateDateTimeYearFromFullDate(fulldate: fullDateTimeStr, mode: "Time")
            
            let year = self.separateDateTimeYearFromFullDate(fulldate: fullDateTimeStr, mode: "Year")
            
            
            let message = Transfer()
            message.sender = sender
            message.date = date
            message.description = description
            message.time = time
            message.messageId = messageId
            message.senderId = senderId
            message.status = status
            message.title = title
            message.probability = probability
            message.year = year
            message.place = place
            message.fullDateTimeStore = fullDateTimeStr

            
            self.toMainArray.append(message)
            
           var x = 1
            
            DispatchQueue.main.async() {
                if self.toMainArray.isEmpty {
                    
                    print("no")
                    
                }else {
                    print("yes11")
                    
                    if x == 1{
                    
                    var timerMain = Timer.scheduledTimer(timeInterval: 1, target: self,selector: #selector(SecondViewController.executeMain), userInfo: nil, repeats: false)
                        
                        self.dateSort()

                        x = 2
                    }
                }
            }
            

        })
        
    }
    
    func executeMain(){
    

        print("From tableView main")
        tableViewMain.reloadData()
    
    
    }
    func sortedDate(){
    
        let sortedArray = self.toMainArray.sorted{ ($0.date) > ($1.date) }
    print(sortedArray)
   
    }
    
    func myDeleteFunction(firstTree: String, childIWantToRemove: String) {
        
    refToAccount.child(uid!).child(firstTree).child(childIWantToRemove).removeValue { (error, ref) in
            if error != nil {
                print(error)
            }
        
        print("deleted")

        }
        
        tableViewMainSide.reloadData()
        //tableViewMain.reloadData()
    }
    
    
       
    func toDictionary (param: Transfer) -> [String: String]{
        
        let tempDictionary = ["SenderId": param.senderId,
                              "Description": param.description,
                              //"Time": param.time,
                              //"Date": param.date,
                              "MessageId" : param.messageId,
                              "Status" : param.status,
                              "Sender" : param.sender,
                              "Title" : param.title,
                              "Probability": param.probability,
                              //"Year": param.year,
                              "Place": param.place,
                              "FullDateTimeStore" : param.fullDateTimeStore,
                              "Img" : "Default"
                              ]
        
        return tempDictionary
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
