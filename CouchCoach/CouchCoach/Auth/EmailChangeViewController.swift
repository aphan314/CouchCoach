//
//  EmailChangeViewController.swift
//  CouchCoach
//
//  Created by Andrew Pham on 3/11/21.
//  Copyright © 2021 GetFit. All rights reserved.
//

import UIKit
import FirebaseAuth
class EmailChangeViewController: UIViewController {
    @IBOutlet weak var newEmail: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var currentEmail: UITextField!
    @IBOutlet weak var confirmEmail: UITextField!
    @IBOutlet weak var statusMessage: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func done(_ sender: UITextField) {
        sender.resignFirstResponder()
        
    }
    
    @IBAction func changeEmail(_ sender: Any)
    {
        guard let email = newEmail.text, let confirm = confirmEmail.text, let passw = password.text, let curEmail = currentEmail.text, !(isTextEmpty()) else {
            return
        }
        
        if curEmail == email {
            displayAlert(title:"Error", message: "Please enter a new email different from the current one")
            return
        }
        
        if email != confirm{
            displayAlert(title: "Error", message: "Please ensure that the confirmation field is the same")
            return
        }
        let user = Auth.auth().currentUser
        let credential = EmailAuthProvider.credential(withEmail: curEmail, password: passw)
        user?.reauthenticate(with: credential) { result, error in
            if error != nil {
                let error = AuthErrorCode(rawValue: error!._code)
                    switch error {
                    case.wrongPassword:
                        self.displayAlert(title:"Error", message: "Incorrect Password")
                    case.invalidEmail:
                        self.displayAlert(title: "Error", message: "Invalid Email")
                    case.invalidCredential:
                        self.displayAlert(title:"Error", message: "Invalid Credentials")
                    default: self.displayAlert(title:"Error", message: "Reauthentication Failed")
                    }
                }
          else {
            
            
                Auth.auth().currentUser?.updateEmail(to: email) { (error) in
                    if error != nil {
                        let error = AuthErrorCode(rawValue: error!._code)
                        switch error {
                        case.emailAlreadyInUse:
                            self.displayAlert(title:"Error", message: "Email already in use")
                        case.invalidEmail:
                            self.displayAlert(title:"Error", message: "Invalid Email")
                        default:
                            self.displayAlert(title: "Error", message: "Failed to Update Email. Try Again")
                        }
                    }
                    else {
                        self.statusMessage.isHidden = false
                        self.statusMessage.text = "Email Successfully Changed to \(self.newEmail.text ?? "")"
                        self.newEmail.text = ""
                        self.confirmEmail.text = ""
                        self.password.text = ""
                        self.currentEmail.text = ""
                        print("COMPLETE")
                        
                    }
                }
          }
        }
            
    
        
        

        
        
    }
    
    func displayAlert(title: String, message: String) {
        // create the alert
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)

        // add an action (button)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))

        // show the alert
        self.present(alert, animated: true, completion: nil)
    }

    private func isTextEmpty() -> Bool {
        if let curEmail = currentEmail.text, curEmail.isEmpty {
            displayAlert(title: "Error", message: "Missing Current Email Field")
        }
        if let passw = password.text, passw.isEmpty {
            displayAlert(title: "Error", message: "Missing Password Field")
        }
        if let email = newEmail.text, email.isEmpty {
            displayAlert(title: "Error", message: "Email  is missing")
            return true
        }
        if let confirm = confirmEmail.text, confirm.isEmpty {
            displayAlert(title: "Error", message: "Must Confirm Email")
            return true
        }
        return false
    }
}
