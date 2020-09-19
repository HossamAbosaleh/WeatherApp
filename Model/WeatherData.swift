//
//  WeatherData.swift
//  WeatherApp
//
//  Created by Abo Saleh on 9/19/20.
//  Copyright © 2020 Abo Saleh. All rights reserved.
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
