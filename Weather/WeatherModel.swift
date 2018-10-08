 //
//  WeatheModel.swift
//  Weather
//
//  Created by Alexandr Yanski on 06.09.2018.
//  Copyright © 2018 Lonely Tree Std. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import MBProgressHUD
import CoreLocation

protocol OpenWeatherMapDelegate: AnyObject {
    func updatheWeatherInfo(weatherJSON: NSDictionary)
    func failure()
}
 
class WeatherModel {

    weak var delegate: OpenWeatherMapDelegate?
    func setRequest(city: String, geo: CLLocationCoordinate2D) {
        let weatherUrl = "https://api.openweathermap.org/data/2.5/forecast"
        let params = ["appid" : WEATHER_KEY, "lat" : geo.latitude, "lon" : geo.longitude, "q" : city ] as [String : Any]
        request(weatherUrl, method: .get, parameters: params).responseJSON { (res) in
            print(res.request)
            if res.error != nil {
                self.delegate?.failure()
            } else {
                if let weatherJSON = res.result.value as? NSDictionary {
                    DispatchQueue.main.async {
                        self.delegate?.updatheWeatherInfo(weatherJSON: weatherJSON)
                    }
                }

                
            }
        }
    }
    
    
    func timeFromUnix(unixTime: Int) -> String {
        let timeInSecond = TimeInterval(unixTime)
        let weatherDate = Date(timeIntervalSince1970: timeInSecond)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        
        return dateFormatter.string(from: weatherDate)
    }
    
    
    func weatherIcon(stringIcon: String, nightTime: Bool, index: Int, weatherIcon:(_ index: Int, _ icon: String) -> ()) {
        
        switch stringIcon {
        case "01d":
            weatherIcon(index, "icon5-sun")
        case "02d":
            weatherIcon(index, "icon6-sunny")
        case "09d":
            weatherIcon(index, "icon2-rain")
        case _ where nightTime == true:
            weatherIcon(index, "icon1-moon")
        case "10d":
            weatherIcon(index, "icon3-rainbow")
        case "11d":
            weatherIcon(index, "icon4-storm")
        case "50d":
            weatherIcon(index, "icon7-windy")
        default:
            weatherIcon(index, "none")
        }
    }
    
    func isTimeNight(icon: String) -> Bool {
        return icon.range(of: "n") != nil
    }
    
    func convertTemperature(county: String, temperature: Double) -> Double {
        if county == "US" {
            //Фаренгейт
            return round(((temperature - 273.15) * 1.8) + 32)
        } else {
            //Цельция
            return round(temperature - 273.15)
        }
    }
}
