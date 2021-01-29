//
//  ViewController.swift
//  CouchCoach
//
//  Created by Miguel Barba on 1/26/21.
//  Copyright © 2021 GetFit. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController {

    // In swift there are var and let
    // var is a variable that can be changes
    // let is a constant
    var counter = 0
    let logoutSegueIdentifier = "logoutSegue"
    
    @IBOutlet weak var counterLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    
    // Kinda like an IBOutlet, except this is for when buttons are pressed
    @IBAction func ExampleButton(_ sender: UIButton) {
        counter += 1
        counterLabel.text = "Counter: \(counter)"
    }
    
    
    @IBAction func logoutButtonPressed(_ sender: Any) {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            performSegue(withIdentifier: logoutSegueIdentifier, sender: nil)
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }
    
}

