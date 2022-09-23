//
//  WeatherModel.swift
//  WeatherBrick
//
//  Created by Oleksandr Melnyk on 12.09.2022.
//  Copyright © 2022 VAndrJ. All rights reserved.
//

import Foundation

struct WeatherData: Decodable {
    let city: String
    let main: Main
    let weather: [Weather]
    let sys: Sys
    
    enum CodingKeys: String, CodingKey {
        case city = "name"
        case main
        case weather
        case sys
    }
}

struct Main: Decodable {
    let temperature: Double
    
    enum CodingKeys: String, CodingKey {
        case temperature = "temp"
    }
}

struct Weather: Decodable {
    let condition: String
    let id: Int
    
    enum CodingKeys: String, CodingKey {
        case condition = "main"
        case id
    }
}

struct Sys: Decodable {
    let country: String
}
