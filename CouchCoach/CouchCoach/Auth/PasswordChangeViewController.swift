//
//  PasswordChangeViewController.swift
//  CouchCoach
//
//  Created by Andrew Pham on 3/11/21.
//  Copyright © 2021 GetFit. All rights reserved.
//

import UIKit
import FirebaseAuth

class PasswordChangeViewController: UIViewController {
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var currentPasswordTextField: UITextField!
    @IBOutlet weak var newPasswordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var statusMessage: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func done(_ sender: UITextField) {
        sender.resignFirstResponder()
    }
    
    @IBAction func changePassword(_ sender: Any)
    {
        guard let email = emailTextField.text, let password = currentPasswordTextField.text, let newPassword = newPasswordTextField.text,
              let confirmPassword = confirmPasswordTextField.text, !(isTextEmpty()) else {return}
        
        if password == newPassword {
            displayAlert(title: "Error", message: "Please enter a new password from the current one")
            return
        }
        
        if newPassword != confirmPassword {
            displayAlert(title: "Error", message: "Please ensure that the confirmation field is the same")
            return
        }
        
        let user = Auth.auth().currentUser
        let credential = EmailAuthProvider.credential(withEmail: email, password: password)
        user?.reauthenticate(with: credential) {
            result, error in
            if error != nil {
                let error = AuthErrorCode(rawValue: error!._code)
                switch error {
                case.wrongPassword:
                    self.displayAlert(title:"Error", message: "Incorrect Password")
                case.invalidEmail:
                    self.displayAlert(title: "Error", message: "Invalid Email")
                case.invalidCredential:
                    self.displayAlert(title: "Error", message: "Invalid Credentials")
                default:
                    self.displayAlert(title:"Error", message: "Reaunthentication Failed")
                    
                }
            }
            else {
                user?.updatePassword(to: newPassword) { (error) in
                    if error != nil {
                        let error = AuthErrorCode(rawValue: error!._code)
                        switch error {
                        case.weakPassword:
                            self.displayAlert(title:"Error", message: "Password is too weak must use at least 6 characters")
                        default:
                            self.displayAlert(title: "Error", message: "Failed to Update Password Please Try Again.")
                        }
                    }
                    else {
                        self.statusMessage.isHidden = false
                        self.statusMessage.text = "Password Succesfully Changed"
                        self.newPasswordTextField.text = ""
                        self.confirmPasswordTextField.text = ""
                        self.emailTextField.text = ""
                        self.currentPasswordTextField.text  = ""
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
        if let curEmail = emailTextField.text, curEmail.isEmpty {
            displayAlert(title: "Error", message: "Missing Current Email Field")
        }
        if let passw = currentPasswordTextField.text, passw.isEmpty {
            displayAlert(title: "Error", message: "Missing Password Field")
        }
        if let newpassw = newPasswordTextField.text, newpassw.isEmpty {
            displayAlert(title: "Error", message: "New Password  is missing")
            return true
        }
        if let confirm = confirmPasswordTextField.text, confirm.isEmpty {
            displayAlert(title: "Error", message: "Must Confirm Email")
            return true
        }
        return false
    }
}
