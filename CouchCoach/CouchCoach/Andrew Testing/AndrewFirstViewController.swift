//
//  AndrewFirstViewController.swift
//  CouchCoach
//
//  Created by Miguel Barba on 1/28/21.
//  Copyright © 2021 GetFit. All rights reserved.
//

import UIKit
import TTGTagCollectionView
import FirebaseFirestore
import FirebaseAuth

class AndrewFirstViewController: UIViewController, TTGTextTagCollectionViewDelegate {
    
    
    
    @IBOutlet weak var TagTextField: UITextField!
    let collectionView = TTGTextTagCollectionView()
    let config = TTGTextTagConfig()
    
    @IBOutlet weak var saveNotif: UILabel!
    
    override func viewDidLoad() {
        collectionView.alignment = .center
        collectionView.delegate = self
        saveNotif.alpha = 0
        TagTextField.text = ""
        view.addSubview(collectionView)
        
        config.backgroundColor = UIColor(red:245/255, green: 188/255, blue: 191/255, alpha: 1)
        config.backgroundColor = .systemBlue
        config.textColor = .black
        
        let db = Firestore.firestore()
        
        let docRef = db.collection("users").document(Auth.auth().currentUser!.uid)
        
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let arr = document.data()?["tags"] ?? []
                self.collectionView.addTags(arr as? [String], with:self.config)
                
            }
        }
        super.viewDidLoad()

        
    }
    
    
    
    func textTagCollectionView(_ textTagCollectionView: TTGTextTagCollectionView!, didTapTag tagText: String!, at index: UInt, selected: Bool, tagConfig config: TTGTextTagConfig!) {
        collectionView.removeTag(at: index)
    }
    
    @IBAction func done(_ sender: UITextField) {
        sender.resignFirstResponder()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = CGRect(x: 0, y: 250, width: view.frame.size.width, height: 100)
    }
    
    @IBAction func addTagButton(_ sender: Any) {
        config.backgroundColor = UIColor(red:245/255, green: 188/255, blue: 191/255, alpha: 1)
        if TagTextField.text!.isEmpty {return}
        let arr = [TagTextField.text!]
        collectionView.addTags(arr, with: config)
        TagTextField.text = ""
    }
    
    
    func uniq<S : Sequence, T : Hashable>(source: S) -> [T] where S.Iterator.Element == T {
        var buffer = [T]()
        var added = Set<T>()
        for elem in source {
            if !added.contains(elem) {
                buffer.append(elem)
                added.insert(elem)
            }
        }
        return buffer
    }
    
    @IBAction func completeTagCollection(_ sender: Any) {
        let db = Firestore.firestore()
        let arr = collectionView.allTags()
        let uarr = uniq(source: arr ?? [])
        
        collectionView.removeAllTags()
        config.backgroundColor = .systemBlue
        collectionView.addTags(uarr, with: config)
        db.collection("users").document(Auth.auth().currentUser!.uid).updateData(["tags":uarr as Any])
        
        saveNotif.alpha = 1
        
        UIView.animate(withDuration: 2, animations:{
            self.saveNotif.alpha = 0
        })
         
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
