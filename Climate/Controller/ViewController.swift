//
//  ViewController.swift
//  Climate
//
//  Created by Ashwini Prabhu on 4/17/20.
//  Copyright © 2020 experiment. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, UISearchBarDelegate {

    @IBOutlet weak var resetButton: UIButton!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var temperature: UILabel!
    @IBOutlet weak var conditionImage: UIImageView!
    @IBOutlet weak var placeLabel: UILabel!
    
    var weatherManager = WeatherManager()
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.view.backgroundColor = .black
        setViewBackground()
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        
        weatherManager.delegate = self
        searchBar.delegate = self
    }
    
    func setViewBackground(){
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        let calendar = Calendar.current
        let now = Date()
        let sixMorn = calendar.date(
         bySettingHour: 6,
         minute: 0,
         second: 0,
         of: now)!

        let sixEve = calendar.date(
         bySettingHour: 17,
         minute: 0,
         second: 0,
         of: now)!

        if now >= sixMorn && now <= sixEve
        {
         backgroundImage.image = UIImage(named: "morning")
        }else{
           backgroundImage.image = UIImage(named: "night")
        }
        searchBar.backgroundColor = UIColor.white
        resetButton.tintColor = UIColor.white
        conditionImage.tintColor = UIColor.white
        placeLabel.textColor = UIColor.white
        temperature.textColor = UIColor.white

        backgroundImage.contentMode = UIView.ContentMode.scaleAspectFill
        view.insertSubview(backgroundImage, at: 0)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print("searchText \(searchText)")
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("searchText \(searchBar.text)")
        if let place = searchBar.text {
            weatherManager.fetchWeather(city: place)
        }
        
        searchBar.text = ""
        searchBar.resignFirstResponder()
    }
}

//Mark:- WeatherManagerDelegate

extension ViewController: WeatherManagerDelegate {
    
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: weatherModel) {
        DispatchQueue.main.async {
            self.temperature.text = weather.temperatureString
            self.conditionImage.image = UIImage(systemName: weather.conditionName)
            self.placeLabel.text = weather.cityName
        }
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
}


//Mark:- CLLocationManagerDelegate

extension ViewController: CLLocationManagerDelegate {
    
    @IBAction func locationReset(_ sender: UIButton){
        locationManager.requestLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            locationManager.stopUpdatingLocation()
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            weatherManager.fetchWeather(latitude: lat, longitude: lon)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}
