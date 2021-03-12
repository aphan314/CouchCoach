////
////  CurrentWeather.swift
////  CouchCoach
////
////  Created by Andrew Pham on 3/9/21.
////  Copyright © 2021 GetFit. All rights reserved.
////
//
//import Foundation
//
//class CurrentWeather{
//    var lat: Double = 0.0
//    var lon: Double = 0.0
//    var temp: Double = 0.0
//    var condition: String = ""
//    var conditionDesc: String = ""
//    var city: String = ""
//    
//    init()
//    {
//        self.lat = Double(LocationManager.shared.lastLocation?.coordinate.latitude ?? 0)
//        self.lon = Double(LocationManager.shared.lastLocation?.coordinate.longitude ?? 0)
//        
//        let w = WeatherManager.shared.retrieveWeather(lat:self.lat, lon:self.lon)
//        
//        city = w.city ?? "Unknown"
//        temp = w.temp ?? 0
//        condition = w.condition ?? "Clear"
//        conditionDesc = w.conditionDesc ?? "Clear Skies"
//        
//    }
//    
//    func updateWeather() {
//        self.lat = Double(LocationManager.shared.lastLocation?.coordinate.latitude ?? 0)
//        self.lon = Double(LocationManager.shared.lastLocation?.coordinate.longitude ?? 0)
//        
//        let w = WeatherManager.shared.retrieveWeather(lat:self.lat, lon:self.lon)
//        
//        city = w.city ?? "Unknown"
//        temp = w.temp ?? 0
//        condition = w.condition ?? "Clear"
//        conditionDesc = w.conditionDesc ?? "Clear Skies"
//        
//    }
//    
//    func getCity() -> String {
//        return city
//    }
//    
//    func getTemp() -> Double {
//        return temp
//    }
//    
//    func getCond() -> String {
//        return condition
//    }
//    
//    func getCondDesc() -> String{
//        return conditionDesc
//    }
//
//}
