//
//  FirstController.swift
//  inviti
//
//  Created by Gop on 10/6/2560 BE.
//  Copyright © 2560 gopGorppol. All rights reserved.
//

import UIKit
import Firebase



extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ scoreText: UITextField) -> Bool {
        view.endEditing(true)
        return true
    }
    
}

class LogInController: UIViewController,UITextFieldDelegate {

    @IBOutlet weak var emailTextField: UITextField!

    @IBOutlet weak var titleView: UIView!
    
    @IBOutlet weak var passWordTextField: UITextField!
    
    
    @IBAction func registerButton(_ sender: Any) {
        
        self.performSegue(withIdentifier: "loginToRegister", sender: self)

        
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailTextField.delegate = self
        passWordTextField.delegate = self
        // Do any additional setup after loading the view, typically from a nib.
        
        self.hideKeyboardWhenTappedAround()
        
        

    }

    @IBAction func loginButton(_ sender: Any) {
        
        FIRAuth.auth()?.signIn(withEmail: emailTextField.text!, password: passWordTextField.text!, completion: { (user, error) in
            if error != nil {
                print(error!)
            }
            else {
                print("login successful")
                
                
                self.performSegue(withIdentifier: "loginToHome", sender: self)
            }
        })
        
    }
    

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

