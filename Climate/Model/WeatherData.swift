//
//  weatherData.swift
//  Climate
//
//  Created by Ashwini Prabhu on 4/17/20.
//  Copyright © 2020 experiment. All rights reserved.
//

import Foundation

struct WeatherData: Codable {
    let name: String
    let main: Main
    let weather: [Weather]
}

struct Main: Codable {
    let temp: Double
}

struct Weather: Codable {
    let description: String
    let id: Int
}
