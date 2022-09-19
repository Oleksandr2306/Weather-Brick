//
//  CityModel.swift
//  WeatherBrick
//
//  Created by Oleksandr Melnyk on 14.09.2022.
//  Copyright © 2022 VAndrJ. All rights reserved.
//

import Foundation


import Foundation

struct CityObject: Codable {
    var name: String
    var country: String
    var coord: CoordCity
}

struct CoordCity: Codable {
    var lat: Double
    var lon: Double
}
