//
//  ProfileViewController.swift
//  CouchCoach
//
//  Created by Andrew Pham on 3/11/21.
//  Copyright © 2021 GetFit. All rights reserved.
//

import Foundation
import UIKit

class ProfileViewController: UITableViewController {
    
    let logoutSegueIdentifier = "logoutProf"
    
    
    func displayAlert(title: String, message: String) {
        // create the alert
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)

        // add an action (button)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))

        // show the alert
        self.present(alert, animated: true, completion: nil)
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String?, sender: Any?) -> Bool {
        var logoutStatus = true
        if let id = identifier{
            if id == logoutSegueIdentifier {
                AuthenticationManager.shared.logout { result in
                    switch result {
                    case true:
                        logoutStatus = true
                    case false:
                        self.displayAlert(title: "Error", message: "Try Logging out again")
                        logoutStatus = false
                    }
            }
                return logoutStatus
        }
        }
        return true
    }
    
    
}

