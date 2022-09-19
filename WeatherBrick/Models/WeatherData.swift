//
//  WeatherModel.swift
//  WeatherBrick
//
//  Created by Oleksandr Melnyk on 12.09.2022.
//  Copyright © 2022 VAndrJ. All rights reserved.
//

import Foundation

struct WeatherData: Decodable {
    let name: String
    let main: Main
    let weather: [Weather]
    let sys: Sys
}

struct Main: Decodable {
    let temp: Double
}

struct Weather: Decodable {
    let main: String
    let id: Int
}

struct Sys: Decodable {
    let country: String
}
