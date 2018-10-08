//
//  ViewController.swift
//  Weather
//
//  Created by Alexandr Yanski on 06.09.2018.
//  Copyright © 2018 Lonely Tree Std. All rights reserved.
//

import UIKit
import Alamofire
import MBProgressHUD
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate, OpenWeatherMapDelegate, WeatherForecastDelegate {
    
    
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var speedWindLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    
    var time1Text: String!
    var time2Text: String!
    var time3Text: String!
    var time4Text: String!
    
    var icon1: UIImage!
    var icon2: UIImage!
    var icon3: UIImage!
    var icon4: UIImage!
    
    var temp1Text: String!
    var temp2Text: String!
    var temp3Text: String!
    var temp4Text: String!
    
    var locationManager: CLLocationManager = CLLocationManager()
    
    var openWeather = WeatherModel()
    var weatherHandler = WeatherHandler()
    var hud = MBProgressHUD()
    var coords: CLLocationCoordinate2D?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Get out back button
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        //Set background
        let bg = UIImage(named: "background")
        self.view.backgroundColor = UIColor(patternImage: bg!)
        self.view.layer.contents = bg?.cgImage
        
        //Set setup

        weatherHandler.delegate = self
        openWeather.delegate = self
        locationManager.delegate = self
        
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        
        locationManager.startUpdatingLocation()
        self.activityIndicator()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    
    func activityIndicator() {
        hud.labelText = "Loading..."
        hud.dimBackground = true
        self.view.addSubview(hud)
        hud.show(animated: true)
    }
    
    @IBAction func addCity(_ sender: UIBarButtonItem) {
        displayCity()
    }
    
    func displayCity() {
        let alert = UIAlertController(title: "City", message: "Enter name city", preferredStyle: .alert)
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(cancel)
        let ok = UIAlertAction(title: "OK", style: .default) { (action) -> Void in
            if let textField = alert.textFields?.first {
                self.activityIndicator()
                self.openWeather.setRequest(city: textField.text!, geo: self.coords!)
            }
        }
            alert.addAction(ok)
            alert.addTextField { (textField) in
            textField.placeholder = "City name"
        }
        
        self.present(alert, animated: true, completion: nil)
    }
    
    
    func updateIconList(index: Int, name: String) {
        switch index {
        case 0: self.iconImageView.image = UIImage(named: name)
        case 1: self.icon1 = UIImage(named: name)
        case 2: self.icon2 = UIImage(named: name)
        case 3: self.icon3 = UIImage(named: name)
        case 4: self.icon4 = UIImage(named: name)
        default: print("Error forecast icon")
        }
    }
    
    func updateForecastTime(index: Int, name: String) {
        switch index {
        case 1: time1Text = name
        case 2: time2Text = name
        case 3: time3Text = name
        case 4: time4Text = name
        default: print("Error with convert temperature")
        }
    }
    
    func updateForecastTemp(index: Int, name: Double) {
        switch index {
        case 1: temp1Text = "\(name)"
        case 2: temp2Text = "\(name)"
        case 3: temp3Text = "\(name)"
        case 4: temp4Text = "\(name)"
        default: print("Error with convert temperature")
        }
    }
    
    func updatheWeatherInfo(weatherJSON: NSDictionary) {
        timeLabel.text = weatherHandler.updateTime()
        cityNameLabel.text = weatherHandler.updateCityAndCountry(weatherJSON: weatherJSON)
        tempLabel.text = weatherHandler.updateTemp(weatherJSON: weatherJSON)
        humidityLabel.text = weatherHandler.updateHumidity(weatherJSON: weatherJSON)
        weatherHandler.updateIcon(weatherJSON: weatherJSON)
        weatherHandler.updateForecastIcons(weatherJSON: weatherJSON)
        descriptionLabel.text = weatherHandler.updateDiscription(weatherJSON: weatherJSON)
        speedWindLabel.text = weatherHandler.updateSpeedWind(weatherJSON: weatherJSON)
        weatherHandler.updateForecastTemp(weatherJSON: weatherJSON)
        weatherHandler.updateForecastTime(weatherJSON: weatherJSON)
        
        hud.hide(animated: true)
    }
    
    func failure() {
        //No connection internet
        let networkController = UIAlertController(title: "Error", message: "No connection!", preferredStyle: .alert)
        let okButton = UIAlertAction(title: "OK", style: .default, handler: nil)
        networkController.addAction(okButton)
        self.present(networkController, animated: true, completion: nil)
        hud.hide(animated: true)
    }
    
    //MARK: - CLLocationManagerDelegate
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print(manager.location)
        let currentLocation: CLLocation = locations.last!
        if (currentLocation.horizontalAccuracy > 0) {
            //Stop updating location to save battery life
            locationManager.stopUpdatingLocation()
            
            self.coords = CLLocationCoordinate2DMake(currentLocation.coordinate.latitude, currentLocation.coordinate.longitude)
            print(coords)
            self.openWeather.setRequest(city: "", geo: self.coords!)
            hud.hide(animated: true)
            
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
        print("Can't get your location.")
        hud.hide(animated: true)
    }
    
    //MARK: - Prepare for segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "moreInfo" {
            let forecastController = segue.destination as! ForecastViewController
            
            forecastController.time1 = self.time1Text
            forecastController.time2 = self.time2Text
            forecastController.time3 = self.time3Text
            forecastController.time4 = self.time4Text
            
            forecastController.icon1Image = self.icon1
            forecastController.icon2Image = self.icon2
            forecastController.icon3Image = self.icon3
            forecastController.icon4Image = self.icon4
            
            forecastController.temp1 = self.temp1Text
            forecastController.temp2 = self.temp2Text
            forecastController.temp3 = self.temp3Text
            forecastController.temp4 = self.temp4Text
        }
    }
}

