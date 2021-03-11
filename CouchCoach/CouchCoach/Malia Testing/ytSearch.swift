//
//  ytSearch.swift
//  CouchCoach
//
//  Created by Malia German on 2/2/21.
//  Copyright © 2021 GetFit. All rights reserved.
//

import Foundation

extension YTTableResults {
    
    func retrieveSearchResults(q: String, completionHandler: @escaping([Video]?, Error?) -> Void){
        
        // ["date","rating", "relevance", "title", "videoCount", "viewCount"]
        let order = "relevance"
        let additional = ["%20tutorial","%20how%20to","%20guide","%20class","%20learn", "%20project", "%20teach","%20for%20beginners","%20project%20for%20beginners"]
        // ["moderate", "none", "strict"]
        let safeSearch = "moderate"
        let maxResult = 25
        
        // YouTube API Key:
        let apiKey =  ""
        
        // url
        let baseURL = "https://www.googleapis.com/youtube/v3/search?type=video&part=snippet&q=\(q)\(additional.randomElement() ?? "")&order=\(order)&safeSearch=\(safeSearch)&maxResult=\(maxResult)&key=\(apiKey)"
        
        let url = URL(string : baseURL)
        
        // creating request
        var request = URLRequest(url: url!)
        //request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.httpMethod = "GET"
        
        // initialize session and task
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error{
                completionHandler(nil, error)
            }
            do{
                // read data as json
                let json = try JSONSerialization.jsonObject(with: data!, options: [])
                // main dictionary
                guard let resp = json as? NSDictionary else {return}
                //print(resp)
                //print("sent")
                // items
                guard let items = resp.value(forKey: "items") as? NSArray else { return }
                //print(items)
                var Videos: [Video] = []
                var video: Video
                // accessing each video
                for item in items {
                    guard let itemInfo = item as? NSDictionary else {return}
                    
                    video = Video()
                    
                    // ID
                    let idStuff = itemInfo.value(forKey: "id") as! NSDictionary
                    if(idStuff.value(forKey: "kind") as! String == "youtube#video"){
                        video.videoId = idStuff.value(forKey: "videoId") as! String
                    }
                    
                    
                    // Snippet
                    let snippetStuff = itemInfo.value(forKey: "snippet") as! NSDictionary
                    video.channelTitle = snippetStuff.value(forKey: "channelTitle") as! String
                    video.videoTitle = snippetStuff.value(forKey: "title") as! String
                    video.published = snippetStuff.value(forKey: "publishedAt") as! String
                    // getting url thumbnails
                    let thumbnails = snippetStuff.value(forKey: "thumbnails") as! NSDictionary
                    let defaultThumbnail = thumbnails.value(forKey: "default") as! NSDictionary
                    video.thumbnail = defaultThumbnail.value(forKey: "url") as! String
                    Videos.append(video)
                }
            completionHandler(Videos, nil)
            
        } catch{
            print("Caught Error")
            completionHandler(nil, error)
        }
    }.resume()}
}
