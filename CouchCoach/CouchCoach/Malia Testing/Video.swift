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
    var thumbnail : String
    var published : String
    var videoId : String
    var tags : [String]
    
    init(){
        self.videoTitle = ""
        self.channelTitle = ""
        self.published = ""
        self.videoId = ""
        self.tags = []
        self.thumbnail = ""
    }
    
    func getVideo() -> String{
        return self.videoTitle
    }
    
    func getchannelTitle() -> String{
        return self.channelTitle
    }
    
    func getVideoUrl() -> String{ // format: https: //www.youtube.com/watch?v=[videoId]&ab_channel=[channelTitle]
        return "www.youtube.com/watch?v=\( self.videoId )&ab_channel=\(self.channelTitle.replacingOccurrences(of: " ", with:"%20"))"
    }
    
    func getThumbnail() -> String{
        return self.thumbnail
    }
    
}
