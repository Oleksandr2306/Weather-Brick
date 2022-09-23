//
//  LocationManager.swift
//  WeatherBrick
//
//  Created by Oleksandr Melnyk on 22.09.2022.
//  Copyright © 2022 VAndrJ. All rights reserved.
//

import Foundation
import CoreLocation

protocol LocationUpdateProtocol: AnyObject {
    func locationDidFailWithError(error: Error)
    func locationDidUpdateToLocation(latitude : Double, longitude: Double)
    
}

final class LocationManager: NSObject, CLLocationManagerDelegate {
    
    private lazy var manager = CLLocationManager()
    private var latitude: Double = 0
    private var longitude: Double = 0
    weak var delegate: LocationUpdateProtocol?
    
    func requestUserPermission() {
        manager.requestWhenInUseAuthorization()
    }
    
    func requestLocation() {
        manager.requestLocation()
    }
    
    init(manager: CLLocationManager = CLLocationManager()) {
        super.init()
        self.manager.delegate = self
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        manager.stopUpdatingLocation()
        latitude = location.coordinate.latitude
        longitude = location.coordinate.longitude
        self.delegate?.locationDidUpdateToLocation(latitude: self.latitude, longitude: self.longitude)
        
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        self.delegate?.locationDidFailWithError(error: error)
    }
    
}
