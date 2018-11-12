//
//  RegisterViewController.swift
//  inviti
//
//  Created by Gop on 10/6/2560 BE.
//  Copyright © 2560 gopGorppol. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD


class RegisterViewController: UIViewController, UITextFieldDelegate {
    
    let refToUserInfo = FIRDatabase.database().reference().child("UserInfo")
    let refToFindUserName = FIRDatabase.database().reference().child("FindUserName")
    var usernameWithReplacement = ""
    
    @IBOutlet weak var userNameTextField: UITextField!
    
    @IBOutlet weak var passWordTextField: UITextField!
    
    @IBOutlet weak var emailTextField: UITextField!
    
    
    @IBOutlet weak var message: UILabel!
    
    @IBAction func backButton(_ sender: Any) {
        
    self.navigationController?.popViewController(animated: true)
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func registerButton(_ sender: Any) {
        
        if userNameTextField.text?.isEmpty ?? true {
            
            message.text = "Please enter a Username"
            
        } else {
            
            SVProgressHUD.show()
            
            userNameCheckForSame()
            
            SVProgressHUD.dismiss()
            
            
        }
        
        
        
    }
    
    func registerationToFirebase (){
        
        FIRAuth.auth()?.createUser(withEmail: emailTextField.text!, password: passWordTextField.text!, completion: { (user, error) in
            
            if error != nil {
                print(error!)
                
                self.message.text = "Register failed invalid"
                
            }
                
            else {
                //success
                print("Registration sucesssful!")
                
                self.message.text = "Register successful!"
                
                self.loginToFirebase()
                
                
            }
            
            
        })
        
        
        
    }
    
    func loginToFirebase(){
        
        FIRAuth.auth()?.signIn(withEmail: emailTextField.text!, password: passWordTextField.text!, completion: { (user, error) in
            if error != nil {
                print(error!)
            }
            else {
                print("login successful")
                
                self.registerToUserInfo()
                //self.performSegue(withIdentifier: "loginToHome", sender: self)
            }
        })
        
    }
    
    
    func registerToUserInfo () {
        
        let uid = FIRAuth.auth()?.currentUser?.uid
        
        let tempDictionary = [
            "Id" : uid!,
            "Username" : userNameTextField.text!
        ]
        
        refToUserInfo.child(usernameWithReplacement).setValue(tempDictionary)
        
        refToFindUserName.child(uid!).setValue(["Username" : userNameTextField.text!])
        
        self.performSegue(withIdentifier: "registerToHome", sender: self)
        
    }
    
    func userNameCheckForSame(){
        
        //check for special character
        
        let characterset = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789.")
        let text = userNameTextField.text
        
        if text?.rangeOfCharacter(from: characterset.inverted) != nil {
            print("string contains special characters")
            message.text = "No special character such as [ ] /...etc"
            
            return
        
        }
        
        // replace . with %2E
        
         let username = userNameTextField.text!.replacingOccurrences(of: ".", with: "%2E", options: .literal, range: nil)
        
        print("This is \(username)")
        
        usernameWithReplacement = username
        
   
        refToUserInfo.observeSingleEvent(of: .value, with: { (snapshot) in
            
            if snapshot.hasChild(username){
                
                print("There's Already this Id")
                self.message.text = "There's already this ID"
                
            }else{
                
                self.registerationToFirebase()
                
                print("OK Id Unique")
            }
            
            
        })
        
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userNameTextField.delegate = self
        passWordTextField.delegate = self
        
        self.hideKeyboardWhenTappedAround()
        
        
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
