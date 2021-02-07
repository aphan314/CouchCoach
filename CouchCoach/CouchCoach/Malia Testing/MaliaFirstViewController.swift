//
//  MaliaFirstViewController.swift
//  CouchCoach
//
//  Created by Miguel Barba on 1/28/21.
//  Copyright © 2021 GetFit. All rights reserved.
//

import UIKit

class MaliaFirstViewController: UIViewController {

    var videos : [Video] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        print("hello")
        print(retrieveSearchResults(q: "puppies", completionHandler: {(response, error) in
            if let response = response{
                self.videos = response
                print(self.videos[1].channelTitle)
            }
        }))
        
    }
    


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
