//
//  ytSearch.swift
//  CouchCoach
//
//  Created by Malia German on 2/2/21.
//  Copyright © 2021 GetFit. All rights reserved.
//

import Foundation

extension MaliaFirstViewController {
    
    func retrieveSearchResults(q: String, completionHandler: @escaping([Video]?, Error?) -> Void){
        
        // ["date","rating", "relevance", "title", "videoCount", "viewCount"]
        let order = "relevance"
        // ["moderate", "none", "strict"]
        let safeSearch = "moderate"
        let maxResult = 5
        
        
        // url
        let baseURL = "https://www.googleapis.com/youtube/v3/search?part=snippet&q=\(q)&order=\(order)&safeSearch=\(safeSearch)&maxResult=\(maxResult)&key=\(apiKey)"
        
        let url = URL(string : baseURL)
        
        // creating request
        var request = URLRequest(url: url!)
        request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
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
                
                // items
                guard let items = resp.value(forKey: "items") as? [NSDictionary] else { return }
                
                var Videos: [Video] = []
                
                // accessing each video
                for item in items {
                    var video = Video()
                    video.channelTitle = item.value(forKey: "channelTitle")
                    video.videoTitle = item.value(forKey: "channelTitle")
                    video.published = item.value(forKey: "channelTitle")
                    Videos.append(video)
                }
            }
            
            completionHandler(Videos, nil)
            
        } catch{
            print("Caught Error")
            completionHandler(nil, error)
        }
    }.resume()
}
