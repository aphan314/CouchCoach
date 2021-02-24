//
//  YTTable.swift
//  CouchCoach
//
//  Created by Malia German on 2/21/21.
//  Copyright © 2021 GetFit. All rights reserved.
//

import UIKit
import YoutubePlayer_in_WKWebView


class YTTableResults: UIViewController,  UITableViewDelegate, UITableViewDataSource, cellDelegate {

    @IBOutlet weak var YTTableView: UITableView!
    
    @IBOutlet weak var playerView: WKYTPlayerView!
    @IBOutlet weak var current: UILabel!
    
    var term = ""
    var videos : [Video] = []
    var saved : [Video] = []
    var notInt: [Video] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        current.text = "Click Watch Now to watch"
        playerView.load(withVideoId: "60-oqH-G8Ro")
        // Do any additional setup after loading the view.
        YTTableView.delegate = self
        YTTableView.dataSource = self
        YTTableView.register(UINib(nibName: "CustomYTCell", bundle: nil), forCellReuseIdentifier: "CustomYTCell")
        YTTableView.separatorStyle = .none
        
        // Do any additional setup after loading the view.
       retrieveSearchResults(q: term, completionHandler: {(response, error) in
            if let response = response{
                self.videos = response
                // filter out saved and not interested videos
                DispatchQueue.main.async{
                    self.YTTableView.reloadData()
                    self.playerView.load(withVideoId: self.videos[0].videoId)
                }

            }
        })
            }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return videos.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        return 140
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomYTCell", for: indexPath) as! YTTableViewCell
        
        //cell delegate
        cell.cellDelegate = self
        //table contents
        cell.titleLabel.text = videos[indexPath.row].videoTitle
        cell.channelLabel.text = videos[indexPath.row].channelTitle
        cell.publishedLabel.text = videos[indexPath.row].published
        cell.videoInfo = videos[indexPath.row]
        //buttons
        cell.notInterested.tag = indexPath.row
        cell.watchLater.tag = indexPath.row
        cell.watchNow.tag = indexPath.row
        return cell
    }
    
    func didPressButton(_ sender: YTTableViewCell, butt: UIButton, value:Int) {
        //print(YTTableView.indexPath(for:sender))
        print("I have pressed a button with a tag: \(butt.tag)")
        if(value == 1){
            current.text = "Removing: \(videos[butt.tag].videoTitle)"
            videos.remove(at: butt.tag)
            YTTableView.reloadData()
        }
        else if(value == 2){
            current.text = "Watch later added '\(videos[butt.tag].videoTitle)'"
            YTTableView.reloadData()
        }
        else{
            playerView.load(withVideoId: sender.videoInfo!.videoId)
            current.text = "Now watching: \(videos[butt.tag].videoTitle)"
        }
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

//}
