//
//  LocationManager.swift
//  WeatherBrick
//
//  Created by Oleksandr Melnyk on 22.09.2022.
//  Copyright © 2022 VAndrJ. All rights reserved.
//

import Foundation
import CoreLocation

protocol LocationMonitoring: AnyObject {
    func locationDidFailWithError(error: Error)
    func locationDidUpdateToLocation(coordinates: CLLocationCoordinate2D)
}

final class LocationManager: NSObject, CLLocationManagerDelegate {
    
    private lazy var manager = CLLocationManager()
    weak var delegate: LocationMonitoring?
    
    func requestUserPermission() {
        manager.requestWhenInUseAuthorization()
    }
    
    func requestLocation() {
        manager.requestLocation()
    }
    
    init(manager: CLLocationManager = CLLocationManager()) {
        super.init()
        self.manager.delegate = self
        manager.delegate = self
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let coordinates = locations.last?.coordinate else { return }
        self.delegate?.locationDidUpdateToLocation(coordinates: coordinates)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        self.delegate?.locationDidFailWithError(error: error)
    }
    
}
