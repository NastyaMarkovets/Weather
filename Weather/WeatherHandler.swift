//
//  weatherHandler.swift
//  Weather
//
//  Created by Alexandr Yanski on 26.09.2018.
//  Copyright © 2018 Lonely Tree Std. All rights reserved.
//

import UIKit
import MBProgressHUD

protocol WeatherForecastDelegate: AnyObject {
    func updateIconList(index: Int, name: String)
    func updateForecastTime(index: Int, name: String)
    func updateForecastTemp(index: Int, name: Double)

}

class WeatherHandler: NSObject {
    
    var openWeather = WeatherModel()
    var countryName = String()
    
    weak var delegate: WeatherForecastDelegate?
    
    func updateTime() -> String {
        let nowTime = Int(Date().timeIntervalSince1970)
        let timeToString = openWeather.timeFromUnix(unixTime: nowTime)
        return "At \(timeToString) it is"
    }
    
    func updateCityAndCountry(weatherJSON: NSDictionary) -> String {
        if let cityDict = weatherJSON["city"] as? NSDictionary {
            if let country = cityDict["country"] as? String {
                countryName = country
            } else {
                countryName = "none"
            }
            if let cityName = cityDict["name"] as? String {
                return "\(cityName), \(countryName)"
            } else {
                return "Unknown location."
            }
        }
        return "Unknown location."
    }
    
    func updateTemp(weatherJSON: NSDictionary) -> String {
        if let listDict = weatherJSON["list"] as? NSArray {
            if let firstObject = listDict[0] as? NSDictionary {
                if let main = firstObject["main"] as? NSDictionary {
                    if let temp = main["temp"] as? Double {
                        let temperature = openWeather.convertTemperature(county: countryName, temperature: temp)
                        return "\(temperature)°"
                    }
                }
            }
        }
        return "Unknown temerature."
    }
    
    func updateHumidity(weatherJSON: NSDictionary) -> String {
        if let listDict = weatherJSON["list"] as? NSArray {
            if let firstObject = listDict[0] as? NSDictionary {
                if let main = firstObject["main"] as? NSDictionary {
                    if let humidity = main["humidity"] as? Int {
                        return "\(humidity)"
                    }
                }
            }
        }
        return "Unknown humidity."
    }
    
    func updateIcon(weatherJSON: NSDictionary) {
        if let listDict = weatherJSON["list"] as? NSArray {
            if let firstObject = listDict[0] as? NSDictionary {
                if let weather = firstObject["weather"] as? NSArray {
                    if let zero = weather[0] as? NSDictionary {
                        if let icon = zero["icon"] as? String {
                            let nightTime = openWeather.isTimeNight(icon: icon)
                            openWeather.weatherIcon(stringIcon: icon, nightTime: nightTime, index: 0, weatherIcon: self.delegate!.updateIconList)
                        }
                    }
                }
            }
        }
    }
    
    func updateDiscription(weatherJSON: NSDictionary) -> String {
        if let listDict = weatherJSON["list"] as? NSArray {
            if let firstObject = listDict[0] as? NSDictionary {
                if let weather = firstObject["weather"] as? NSArray {
                    if let zero = weather[0] as? NSDictionary {
                        if let description = zero["description"] as? String {
                            return "\(description)"
                        }
                    }
                }
            }
        }
        return "Unknown description."
    }
    
    func updateSpeedWind(weatherJSON: NSDictionary) -> String {
        if let listDict = weatherJSON["list"] as? NSArray {
            if let firstObject = listDict[0] as? NSDictionary {
                if let wind = firstObject["wind"] as? NSDictionary {
                    if let speed = wind["speed"] as? Double {
                        return "\(speed)"
                    }
                }
            }
        }
        return "Unknown temerature."
    }
    
    func updateForecastTemp(weatherJSON: NSDictionary) {
        for index in 1...4 {
            if let listDict = weatherJSON["list"] as? NSArray {
                if let indexDict = listDict[index] as? NSDictionary {
                    if let main = indexDict["main"] as? NSDictionary {
                        if let forecastTemp = main["temp"] as? Double {
                            let temperature = openWeather.convertTemperature(county: countryName, temperature: forecastTemp)
                            self.delegate!.updateForecastTemp(index: index, name: temperature)
                        }
                    }
                }
            }
        }
    }
    
    func updateForecastTime(weatherJSON: NSDictionary) {
        for index in 1...4 {
            if let listDict = weatherJSON["list"] as? NSArray {
                if let indexDict = listDict[index] as? NSDictionary {
                    if let forecastTime = indexDict["dt"] as? Int {
                        let timeToString = openWeather.timeFromUnix(unixTime: forecastTime)
                        self.delegate!.updateForecastTime(index: index, name: timeToString)
                    }
                }
            }
        }
    }
    
    func updateForecastIcons(weatherJSON: NSDictionary) {
        for index in 1...4 {
            if let listDict = weatherJSON["list"] as? NSArray {
                if let indexDict = listDict[index] as? NSDictionary {
                    if let weather = indexDict["weather"] as? NSArray {
                        if let zero = weather[0] as? NSDictionary {
                            if let forecastIcon = zero["icon"] as? String {
                                let nightTime = openWeather.isTimeNight(icon: forecastIcon)
                                openWeather.weatherIcon(stringIcon: forecastIcon, nightTime: nightTime, index: index, weatherIcon: self.delegate!.updateIconList)
                            }
                        }
                    }
                }
            }
        }
    }
}
