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
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.alignment = .center
        collectionView.delegate = self

        TagTextField.text = ""
        view.addSubview(collectionView)
        
        
        config.backgroundColor = .systemBlue
        config.textColor = .white
        
        
        

    }
    
    func textTagCollectionView(_ textTagCollectionView: TTGTextTagCollectionView!, didTapTag tagText: String!, at index: UInt, selected: Bool, tagConfig config: TTGTextTagConfig!) {
        collectionView.removeTag(at: index)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = CGRect(x: 0, y: 200, width: view.frame.size.width, height: 300)
    }
    
    @IBAction func addTagButton(_ sender: Any) {
        if TagTextField.text!.isEmpty {return}
        let arr = [TagTextField.text!]
        collectionView.addTags(arr, with: config)
        TagTextField.text = ""
    }
    
    
    @IBAction func completeTagCollection(_ sender: Any) {
        let db = Firestore.firestore()
        let arr = collectionView.allTags()
        db.collection("users").document(Auth.auth().currentUser!.uid).updateData(["tags":arr as Any])
         
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
