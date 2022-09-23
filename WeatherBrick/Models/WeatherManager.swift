//
//  WeatherManager.swift
//  WeatherBrick
//
//  Created by Oleksandr Melnyk on 12.09.2022.
//  Copyright © 2022 VAndrJ. All rights reserved.
//

import Foundation
import CoreLocation

protocol WeatherDisplaying: AnyObject {
    func didUpdateData(data: WeatherData)
    func didFailWithError(error: Error)
}

class WeatherManager {
    weak var delegate: WeatherDisplaying?
    
    func fetchData(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        guard let url = urlConstructor(baseString: Constants.baseURL, key: Constants.key, latitude: latitude, longitude: longitude) else { return }
        performRequest(url)
    }
    
    func fetchData(city: String) {
        let cityString = city.replacingOccurrences(of: " ", with: "+")
        guard let url = urlConstructor(baseString: Constants.baseURL, key: Constants.key, city: cityString) else { return }
        performRequest(url)
    }
    
    private func urlConstructor(baseString: String, key: String, latitude: CLLocationDegrees, longitude: CLLocationDegrees) -> URL? {
        let urlString = "\(baseString)?appid=\(key)&units=metric&lat=\(latitude)&lon=\(longitude)"
        return URL(string: urlString)
    }
    
    private func urlConstructor(baseString: String, key: String, city: String) -> URL? {
        let urlString = "\(baseString)?appid=\(key)&units=metric&q=\(city)"
        return URL(string: urlString)
    }
    
    private func performRequest(_ url: URL) {
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: url) { (data, response, error) in
            guard error == nil else {
                self.delegate?.didFailWithError(error: error!)
                return
            }
            if let safeData = data {
                guard let weather = self.parseJSON(safeData) else {
                    print("Something goes wrong while parsing JSON")
                    return
                }
                self.delegate?.didUpdateData(data: weather)
            }
        }
        task.resume()
    }
    
    private func parseJSON(_ data: Data) -> WeatherData? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(WeatherData.self, from: data)
            
            return decodedData
        } catch {
            delegate?.didFailWithError(error: error)
            
            return nil
        }
    }
}
