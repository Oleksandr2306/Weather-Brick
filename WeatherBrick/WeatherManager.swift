//
//  WeatherManager.swift
//  WeatherBrick
//
//  Created by Oleksandr Melnyk on 12.09.2022.
//  Copyright © 2022 VAndrJ. All rights reserved.
//

import Foundation
import CoreLocation

protocol WeatherManagerDelegate {
    func didUpdateData(data: WeatherModel)
    func didFailWithError(error: Error)
}

struct WeatherManager {
    var delegate: WeatherManagerDelegate?
    let baseURL = "https://api.openweathermap.org/data/2.5/weather?appid="
    let key = "6bd27c0e159f928e71bfeac64a4a1cf3"
    
    func fetchData(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        let urlString = "\(baseURL)\(key)&units=metric&lat=\(latitude)&lon=\(longitude)"
        guard let url = URL(string: urlString) else { return }
        performRequest(url)
    }
    
    private func performRequest(_ url: URL) {
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: url) { (data, response, error) in
            guard error == nil else { self.delegate?.didFailWithError(error: error!); return }
            if let safeData = data {
                guard let weather = parseJSON(safeData) else { return }
                self.delegate?.didUpdateData(data: weather)
            }
        }
        task.resume()
    }
    
    private func parseJSON(_ data: Data) -> WeatherModel? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(WeatherData.self, from: data)
            let temperature = decodedData.main.temp
            let name = decodedData.name
            
            return WeatherModel(name: name, temp: temperature)
        } catch {
            delegate?.didFailWithError(error: error)
            
            return nil
        }
    }
}
