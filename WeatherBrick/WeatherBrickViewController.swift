//
//  WeatherBrickViewController.swift
//  WeatherBrick
//
//  Created by Oleksandr Melnyk on 12.09.2022.
//  Copyright © 2022 VAndrJ. All rights reserved.
//

import UIKit
import CoreLocation

class WeatherBrickViewController: UIViewController {

    @IBOutlet weak private var weatherBrickImage: UIImageView!
    @IBOutlet weak private var temperatureLabel: UILabel!
    @IBOutlet weak private var weatherLabel: UILabel!
    @IBOutlet weak private var cityLabel: UILabel!
    @IBOutlet weak private var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak private var infoButton: UIButton!
    
    private lazy var weatherManager = WeatherManager()
    private lazy var locationManager = CLLocationManager()
    
    private enum brickImages {
        case raining
        case sunny
        case fog
        case hot
        case snowing
        case windy
        case fail
        
        var image: UIImage {
            switch self {
            case .raining:
                return UIImage(named: "raining")!
            case .sunny:
                return UIImage(named: "normal")!
            case .fog:
                return UIImage(named: "normal")!
            case .hot:
                return UIImage(named: "hot")!
            case .snowing:
                return UIImage(named: "snowing")!
            case .windy:
                return UIImage(named: "normal")!
            case .fail:
                return UIImage(named: "rope")!
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
        locationManager.requestLocation()
        weatherManager.delegate = self
        
        lazy var gradientLayer: CAGradientLayer = {
            let gradientLayer = CAGradientLayer()
            gradientLayer.colors = [
                UIColor(red: 1, green: 0.6, blue: 0.375, alpha: 1).cgColor,
                UIColor(red: 0.977, green: 0.315, blue: 0.106, alpha: 1).cgColor
            ]
            gradientLayer.locations = [0, 1]
            gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.25)
            gradientLayer.endPoint = CGPoint(x: 0.5, y: 0.75)
            return gradientLayer
        }()
        gradientLayer.frame = infoButton.bounds
        gradientLayer.cornerRadius = 10
        infoButton.layer.insertSublayer(gradientLayer, at: 1)
    }
    
    @IBAction private func gpsButtonTapped(_ sender: UIButton!) {
        locationManager.requestLocation()
    }
    
    @IBAction private func searchButtonTapped(_ sender: UIButton!) {
        
    }
    
    
}

//MARK: - WeatherManagerDelegate
extension WeatherBrickViewController: WeatherManagerDelegate {
    func didUpdateData(data: WeatherModel) {
        DispatchQueue.main.async {
            self.activityIndicator.stopAnimating()
            self.weatherBrickImage.image = brickImages.hot.image
            self.weatherBrickImage.isHidden = false
            self.temperatureLabel.text = String(format: "%.1f", data.temp)
            self.weatherLabel.text = data.name
        }
    }
    
    func didFailWithError(error: Error) {
        DispatchQueue.main.async {
            self.activityIndicator.stopAnimating()
            self.weatherBrickImage.image = brickImages.fail.image
            self.weatherBrickImage.isHidden = false
            self.temperatureLabel.text = ""
            self.weatherLabel.text = ""
            print(error)
        }
    }
}

//MARK: - CLLocationManagerDelegate
extension WeatherBrickViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        locationManager.stopUpdatingLocation()
        let lat = location.coordinate.latitude
        let lon = location.coordinate.longitude
        weatherManager.fetchData(latitude: lat, longitude: lon)
        self.activityIndicator.startAnimating()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}
