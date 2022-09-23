//
//  WeatherBrickViewController.swift
//  WeatherBrick
//
//  Created by Oleksandr Melnyk on 12.09.2022.
//  Copyright © 2022 VAndrJ. All rights reserved.
//

import UIKit
import CoreLocation

final class WeatherBrickViewController: UIViewController {
    
    @IBOutlet weak private var weatherBrickImage: UIImageView!
    @IBOutlet weak private var temperatureLabel: UILabel!
    @IBOutlet weak private var weatherLabel: UILabel!
    @IBOutlet weak private var cityLabel: UILabel!
    @IBOutlet weak private var gpsButton: UIButton!
    @IBOutlet weak private var searchButton: UIButton!
    @IBOutlet weak private var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak private var infoButton: UIButton!
    @IBOutlet weak private var weatherBrickPosition: NSLayoutConstraint!
    private lazy var infoWindow = InfoLabel()
    
    private lazy var imageSelector = ImageSelector()
    private lazy var weatherManager = WeatherManager()
    private lazy var locationManager = LocationManager()
    private var city = ""
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        weatherManager.delegate = self
        locationManager.requestUserPermission()
        locationManager.requestLocation()
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector (panGestureAnimation(_:)))
        weatherBrickImage.addGestureRecognizer(panGesture)
        
        let gradientLayer: CAGradientLayer = setButtonLayer()
        infoButton.layer.insertSublayer(gradientLayer, at: 1)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? SearchViewController {
            destination.callBack = { (city: String) in
                self.weatherManager.fetchData(city: city)
            }
        }
    }
    
    @IBAction func infoButtonTapped() {
        infoWindow.isOpen.toggle()
        let modalWindow = infoWindow.windowOpen
        let infoWindowShadow = infoWindow.darkLabelInfo
        
        weatherBrickImage.isHidden = infoWindow.isOpen
        temperatureLabel.isHidden = infoWindow.isOpen
        weatherLabel.isHidden = infoWindow.isOpen
        gpsButton.isHidden = infoWindow.isOpen
        searchButton.isHidden = infoWindow.isOpen
        cityLabel.isHidden = infoWindow.isOpen
        modalWindow.isHidden = !infoWindow.isOpen
        infoWindowShadow.isHidden = !infoWindow.isOpen
        setWindowConstraints(window: modalWindow, shadow: infoWindowShadow)
        
    }
    
    private func setWindowConstraints(window: UILabel, shadow: UILabel) {
        let parent = self.view!
        parent.addSubview(shadow)
        parent.addSubview(window)
        
        let labelWidth = view.bounds.width * 0.73
        let shadowWidth = view.bounds.width * 0.75
        let labelHeight = view.bounds.height * 0.45
        let labelLeadingAnchor = 49
        let labelTopAnchor = 220
        shadow.translatesAutoresizingMaskIntoConstraints = false
        shadow.widthAnchor.constraint(equalToConstant: shadowWidth).isActive = true
        shadow.heightAnchor.constraint(equalToConstant: labelHeight).isActive = true
        shadow.leadingAnchor.constraint(equalTo: parent.leadingAnchor, constant: CGFloat(labelLeadingAnchor)).isActive = true
        shadow.topAnchor.constraint(equalTo: parent.topAnchor, constant: CGFloat(labelTopAnchor)).isActive = true
                
        window.translatesAutoresizingMaskIntoConstraints = false
        window.widthAnchor.constraint(equalToConstant: labelWidth).isActive = true
        window.heightAnchor.constraint(equalToConstant: labelHeight).isActive = true
        window.leadingAnchor.constraint(equalTo: parent.leadingAnchor, constant: CGFloat(labelLeadingAnchor)).isActive = true
        window.topAnchor.constraint(equalTo: parent.topAnchor, constant: CGFloat(labelTopAnchor)).isActive = true
    }
    
    @IBAction private func gpsButtonTapped() {
        locationManager.requestLocation()
    }
    
    private func setButtonLayer() -> CAGradientLayer {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [
            UIColor(red: 1, green: 0.6, blue: 0.375, alpha: 1).cgColor,
            UIColor(red: 0.977, green: 0.315, blue: 0.106, alpha: 1).cgColor
        ]
        gradientLayer.locations = [0, 1]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.25)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 0.75)
        gradientLayer.cornerRadius = 10
        gradientLayer.frame = infoButton.bounds
        return gradientLayer
    }
    
    @objc private func panGestureAnimation(_ panGesture: UIPanGestureRecognizer) {
        if panGesture.velocity(in: weatherBrickImage).y > 0 {
            switch panGesture.state {
            case .began:
                weatherBrickPosition.constant = 0
            case .ended:
                weatherBrickPosition.constant = -32
                UIView.animate(withDuration: 0.25) {
                    self.view.layoutIfNeeded()
                }
                locationManager.requestLocation()
            default:
                break
            }
            panGesture.setTranslation(.zero, in: self.view)
        }
        
    }
    
}

//MARK: - WeatherManagerDelegate
extension WeatherBrickViewController: WeatherDisplaying {
    func didUpdateData(data: WeatherData) {
        DispatchQueue.main.async {
            self.activityIndicator.stopAnimating()
            self.imageSelector.setBrickImage(for: self.weatherBrickImage, with: data)
            self.weatherBrickImage.isHidden = false
            self.temperatureLabel.text = String(format: "%.1f°", data.main.temperature)
            self.weatherLabel.text = data.weather[0].condition
            self.cityLabel.text = "\(data.sys.country), \(data.city)"
            self.gpsButton.isHidden = false
            self.searchButton.isHidden = false
        }
    }
    
    func didFailWithError(error: Error) {
        DispatchQueue.main.async {
            self.activityIndicator.stopAnimating()
            self.imageSelector.fail(for: self.weatherBrickImage)
            self.weatherBrickImage.isHidden = false
            self.temperatureLabel.text = ""
            self.weatherLabel.text = ""
        }
    }
}

//MARK: - LocationUpdateProtocol
extension WeatherBrickViewController: LocationUpdateProtocol {
    func locationDidFailWithError(error: Error) {
        self.activityIndicator.stopAnimating()
        self.imageSelector.fail(for: self.weatherBrickImage)
        self.weatherBrickImage.isHidden = false
        self.temperatureLabel.text = ""
        self.weatherLabel.text = ""
        self.cityLabel.text = ""
    }
    
    func locationDidUpdateToLocation(latitude: Double, longitude: Double) {
        self.activityIndicator.startAnimating()
        self.weatherBrickImage.isHidden = false
        self.temperatureLabel.text = ""
        self.weatherLabel.text = ""
        self.cityLabel.text = ""
        self.gpsButton.isHidden = true
        self.searchButton.isHidden = true
        weatherManager.fetchData(latitude: latitude, longitude: longitude)
    }
}
