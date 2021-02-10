//
//  MaliaFirstViewController.swift
//  CouchCoach
//
//  Created by Miguel Barba on 1/28/21.
//  Copyright © 2021 GetFit. All rights reserved.
//

import UIKit

class MaliaFirstViewController: UIViewController {

    @IBOutlet weak var YTTableView: UITableView!
    
    var videos : [Video] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        YTTableView.delegate = self
        YTTableView.dataSource = self
        YTTableView.register(UINib(nibName: "CustomYTCell", bundle: nil), forCellReuseIdentifier: "CustomYTCell")
        YTTableView.separatorStyle = .none
        
        // Do any additional setup after loading the view.
       retrieveSearchResults(q: "puppies", completionHandler: {(response, error) in
            if let response = response{
                self.videos = response
                DispatchQueue.main.async{
                    self.YTTableView.reloadData()
                }
            }
        })
        
    }
}

extension MaliaFirstViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return videos.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        return 175
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomYTCell", for: indexPath) as! YTTableViewCell
        
        cell.titleLabel.text = videos[indexPath.row].videoTitle
        cell.channelLabel.text = videos[indexPath.row].channelTitle
        cell.publishedLabel.text = videos[indexPath.row].published
        cell.urlLabel.text = videos[indexPath.row].getVideoUrl()
        
        return cell
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


