//
//  MaliaFirstViewController.swift
//  CouchCoach
//
//  Created by Miguel Barba on 1/28/21.
//  Copyright © 2021 GetFit. All rights reserved.
//

import UIKit
import FirebaseFirestore // to access user tags
import FirebaseAuth //**
import TTGTagCollectionView //**

class MaliaFirstViewController: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    var searchHobby = [String]()
    var searching = false
    var tags = [String]() //**
    
    override func viewWillAppear(_ animated: Bool) {
        //** add starting here
        let db = Firestore.firestore()

        let docRef = db.collection("users").document(Auth.auth().currentUser!.uid)
        
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let arr = document.data()?["tags"] ?? []
                print(arr)
                self.tags = arr as! [String]
                print(self.tags)
                //self.collectionView.addTags(arr as? [String], with:self.config)
                self.tableView.reloadData()
            }
        }
        //** to here
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //** add starting here
        let db = Firestore.firestore()

        let docRef = db.collection("users").document(Auth.auth().currentUser!.uid)
        
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let arr = document.data()?["tags"] ?? []
                print(arr)
                self.tags = arr as! [String]
                print(self.tags)
                //self.collectionView.addTags(arr as? [String], with:self.config)
                self.tableView.reloadData()
            }
        }
        //** to here
    }
}

extension MaliaFirstViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        if searching{
            return searchHobby.count
        }
        else{
            return tags.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        if searching{
            cell?.textLabel?.text = searchHobby[indexPath.row]
        }else{
            cell?.textLabel?.text = tags[indexPath.row]
        }
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(identifier: "MaliasSecond") as? YTTableResults
        if searching{
            vc?.term = searchHobby[indexPath.row]
        }
        else{
            vc?.term = tags[indexPath.row]
        }
        //print("sending term \(vc!.term)")
        self.navigationController?.pushViewController(vc!, animated: true)
    }
}

extension MaliaFirstViewController: UISearchBarDelegate{
    func searchBar(_ searchBar:UISearchBar, textDidChange searchText: String){
        searchHobby = tags.filter({$0.lowercased().prefix(searchText.count) == searchText.lowercased()})
        searching = true
        tableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searching = false
        searchBar.text = ""
        tableView.reloadData()
    }
}
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */



