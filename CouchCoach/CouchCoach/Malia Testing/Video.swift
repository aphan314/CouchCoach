//
//  Videos.swift
//  CouchCoach
//
//  Created by Malia German on 2/3/21.
//  Copyright © 2021 GetFit. All rights reserved.
//

import Foundation

class Video{
    var videoTitle : String
    var channelTitle : String
    var thumbnails : [ String : String ]
    var published : String
    var videoId : String
    var tags : [String]
    
    init(){
        self.videoTitle = ""
        self.thumbnails = ["" : ""]
        self.channelTitle = ""
        self.published = ""
        self.videoId = ""
    }
    
    func getVideo() -> String{
        return self.videoTitle
    }
    
    func getchannelTitle() -> String{
        return self.channelTitle
    }
    
    func getVideoUrl() -> URL?{ // format: https: //www.youtube.com/watch?v=[videoId]&ab_channel=[channelTitle]
        return
    }
    
    func getThumbnails() -> [String : String]{
        return self.thumbnails
    }
    
}
