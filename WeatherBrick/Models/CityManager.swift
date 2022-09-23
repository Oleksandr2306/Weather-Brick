//
//  CityManager.swift
//  WeatherBrick
//
//  Created by Oleksandr Melnyk on 14.09.2022.
//  Copyright © 2022 VAndrJ. All rights reserved.
//

import Foundation

final class CityManager {
    
    func getCity(compelition: @escaping ([CityObject]) -> ()) {
        guard let path = Bundle.main.path(forResource: "cities", ofType: "json") else { return }
       
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
            let object = try JSONDecoder().decode([CityObject].self, from: data)
            DispatchQueue.main.async {
                compelition(object)
            }
        } catch {
            print("Can't parse cities; \(error)")
        }
        
    }
}
