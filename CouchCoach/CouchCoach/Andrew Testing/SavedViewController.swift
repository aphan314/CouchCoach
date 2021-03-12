//
//  SavedViewController.swift
//  CouchCoach
//
//  Created by Andrew Pham on 3/12/21.
//  Copyright © 2021 GetFit. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class SavedViewController: UIViewController {
    
    @IBOutlet weak var savedTableView: UITableView!
    
    let recCellIdentifier = "savCell"
    var recommendations: [NSDictionary] = []
    var recommendationList: [Recommendation] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        savedTableView.delegate = self
        savedTableView.dataSource = self
    }
    
    override func viewWillAppear( _ animated: Bool) {
        let db = Firestore.firestore()
        let docRef = db.collection("users").document(Auth.auth().currentUser!.uid)
        self.recommendationList = []
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                self.recommendations = document.data()?["yelp_saved"] as! [NSDictionary]
                for recommend in self.recommendations {
                    var recommendation = Recommendation()
                    recommendation.id = recommend.value(forKey: "id") as? String
                    recommendation.name = recommend.value(forKey: "name") as? String
                    recommendation.info = recommend.value(forKey: "address") as? String
                    recommendation.detail = recommend.value(forKey: "rating") as? String
                    recommendation.url = recommend.value(forKey: "website") as? String
                    recommendation.thumbnail = recommend.value(forKey: "image_url") as? String
                    self.recommendationList.append(recommendation)
                }
                self.savedTableView.reloadData()
            }
        }
    }
}


extension SavedViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recommendationList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if let cell = tableView.dequeueReusableCell(withIdentifier: "savCell", for: indexPath) as? SavCell {
            
            cell.configureWith(recommendationList[indexPath.row], delegate: self)
            cell.deleteButton.tag = indexPath.row
            return cell
            
            
        }
        return UITableViewCell()
    }
    
   
    
}


extension SavedViewController: SavedViewControllerDelegate {
    
    
    func deleteButtonPressed(with: Any) {
        recommendationList.remove(at: (with as! UIButton).tag)
        recommendations.remove(at: (with as! UIButton).tag)
        
        let db = Firestore.firestore()
        let docRef = db.collection("users").document(Auth.auth().currentUser!.uid)
        
        docRef.updateData(["yelp_saved":recommendations ])
        
        
        self.savedTableView.reloadData()
    }
    

    
    func visitWebsite(_ link: String) {
        guard let url = URL(string: link) else {
            return
        }
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    
}
