//
//  WeatherManager.swift
//  CouchCoach
//
//  Created by Andrew Pham on 3/9/21.
//  Copyright © 2021 GetFit. All rights reserved.
//

import Foundation

struct Weather {
    var city                    : String?
    var temp                    : Double?
    var condition               : String?
    var conditionDesc           : String?
}

class WeatherManager {
    static let shared = WeatherManager()
    func retrieveWeather(lat: Double, lon: Double, completionHandler: @escaping (Weather?, Error?) -> Void) -> Void {
        
        let apikey = "97c73ef201bd0ea04ce450da672706bf"
        let baseUrl = "http://api.openweathermap.org/data/2.5/weather?lat=\(lat)&lon=\(lon)&appid=\(apikey)&units=imperial"
        
        let url = URL(string:baseUrl)
        
        var request = URLRequest(url: url!)
        request.httpMethod = "GET"
        
        var weather = Weather()
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            do {
                
                guard let data = data else {
                    return
                }
                
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                
                guard let resp = json as? NSDictionary else { return }
            
                guard let main = resp.value(forKey: "main") as? NSDictionary else {return}
           
                guard let con = resp.value(forKey: "weather") as? [NSDictionary] else {return}
      
                
                weather.city = resp.value(forKey: "name") as? String
                weather.condition = con[0].value(forKey: "main") as? String
                weather.conditionDesc = con[0].value(forKey: "description") as? String
                weather.temp = main.value(forKey: "temp") as? Double
            
                completionHandler(weather, nil)
            } catch {
                print("Caught error")
                completionHandler(nil, error)

            }
            }.resume()
        
    }
    
}

//(lat: 33.684566, lon:-117.826508)
