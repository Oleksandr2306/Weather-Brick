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
    @IBOutlet weak var weatherBrickPosition: NSLayoutConstraint!
    private var infoWindow = InfoWindow()
    
    private lazy var weatherManager = WeatherManager()
    private lazy var locationManager = CLLocationManager()
    var city = ""
    
    private enum brickImages {
        case raining
        case normal
        case fog
        case hot
        case snowing
        case windy
        case fail
        
        var image: UIImage {
            switch self {
            case .raining:
                return UIImage(named: "raining")!
            case .normal:
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
        locationManager.delegate = self
        weatherManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector (panGestureAnimation(_:latitude:longitude:)))
        weatherBrickImage.addGestureRecognizer(panGesture)
        
        var gradientLayer: CAGradientLayer = setButtonLayer()
        infoButton.layer.insertSublayer(gradientLayer, at: 1)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? SearchViewController {
            destination.callBack = { (city: String) in
                self.weatherManager.fetchData(city: city)
            }
        }
    }
    
    @IBAction func infoButtonTapped(_ sender: Any) {
        infoWindow.isOpen.toggle()
        let modalWindow = infoWindow.windowOpen
        let infoWidnowShadow = infoWindow.darkLabelInfo
        
        weatherBrickImage.isHidden = infoWindow.isOpen
        temperatureLabel.isHidden = infoWindow.isOpen
        weatherLabel.isHidden = infoWindow.isOpen
        gpsButton.isHidden = infoWindow.isOpen
        searchButton.isHidden = infoWindow.isOpen
        cityLabel.isHidden = infoWindow.isOpen
        modalWindow.isHidden = !infoWindow.isOpen
        infoWidnowShadow.isHidden = !infoWindow.isOpen
        setWindowConstraints(window: modalWindow, shadow: infoWidnowShadow)
        
    }
    
    private func setWindowConstraints(window: UILabel, shadow: UILabel) {
        let parent = self.view!
        parent.addSubview(shadow)
        parent.addSubview(window)
        
        shadow.translatesAutoresizingMaskIntoConstraints = false
        shadow.widthAnchor.constraint(equalToConstant: view.bounds.width * 0.75).isActive = true
        shadow.heightAnchor.constraint(equalToConstant: view.bounds.height * 0.45).isActive = true
        shadow.leadingAnchor.constraint(equalTo: parent.leadingAnchor, constant: 49).isActive = true
        shadow.topAnchor.constraint(equalTo: parent.topAnchor, constant: 220).isActive = true
        
        window.translatesAutoresizingMaskIntoConstraints = false
        window.widthAnchor.constraint(equalToConstant: view.bounds.width * 0.73).isActive = true
        window.heightAnchor.constraint(equalToConstant: view.bounds.height * 0.45).isActive = true
        window.leadingAnchor.constraint(equalTo: parent.leadingAnchor, constant: 49).isActive = true
        window.topAnchor.constraint(equalTo: parent.topAnchor, constant: 220).isActive = true
    }
    
    @IBAction private func gpsButtonTapped(_ sender: UIButton!) {
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
    
    private func setBrickImage(for image: UIImageView, with weatherCondition: WeatherModel) {
        switch weatherCondition.id {
        case 0...200 :
            image.image = brickImages.hot.image
            image.layer.removeAllAnimations()
            image.alpha = 1
            break
        case 200...599 :
            image.image = brickImages.raining.image
            image.layer.removeAllAnimations()
            image.alpha = 1
            break
        case 600...699 :
            image.image = brickImages.snowing.image
            image.layer.removeAllAnimations()
            image.alpha = 1
            break
        case 700...762 :
            //fog
            image.image = brickImages.normal.image
            animationFog(image: weatherBrickImage)
            break
        case 763...799 :
            //wind
            image.image = brickImages.normal.image
            animationWind(image: weatherBrickImage)
            image.alpha = 1
            break
        case 800...900 :
            image.image = brickImages.normal.image
            image.layer.removeAllAnimations()
            image.alpha = 1
            break
        default:
            image.image = brickImages.normal.image
            image.layer.removeAllAnimations()
            image.alpha = 1
            break
        }
    }
    
    private func animationFog(image: UIImageView) {
        UIView.animateKeyframes(withDuration: 2, delay: 0, options: [.calculationModeLinear], animations: {
            image.alpha = 0.4
        }, completion: nil)
    }
    
    func animationWind(image: UIImageView) {
        UIView.animateKeyframes(withDuration: 3, delay: 0.5, options: [.repeat, .autoreverse], animations: {
            image.layer.anchorPoint = CGPoint(x: 1, y: 0.5)
            image.transform = CGAffineTransform(rotationAngle: 0.1)
        }, completion: nil)
    }
    
    @objc private func panGestureAnimation(_ panGesture: UIPanGestureRecognizer, latitude: Double, longitude: Double) {
        switch panGesture.state {
        case .began:
            if panGesture.velocity(in: weatherBrickImage).y <= 0 {
                break
            }
            weatherBrickPosition.constant = 0
        case .ended:
            if panGesture.velocity(in: weatherBrickImage).y <= 0 {
                break
            }
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

//MARK: - WeatherManagerDelegate
extension WeatherBrickViewController: WeatherManagerDelegate {
    func didUpdateData(data: WeatherModel) {
        DispatchQueue.main.async {
            self.activityIndicator.stopAnimating()
            self.setBrickImage(for: self.weatherBrickImage, with: data)
            self.weatherBrickImage.isHidden = false
            self.temperatureLabel.text = String(format: "%.1f°", data.temp)
            self.weatherLabel.text = data.condition
            self.cityLabel.text = "\(data.country), \(data.name)"
            self.gpsButton.isHidden = false
            self.searchButton.isHidden = false
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
        self.activityIndicator.startAnimating()
        self.weatherBrickImage.image = brickImages.fail.image
        self.weatherBrickImage.isHidden = false
        self.temperatureLabel.text = ""
        self.weatherLabel.text = ""
        self.cityLabel.text = ""
        self.gpsButton.isHidden = true
        self.searchButton.isHidden = true
        
        guard let location = locations.last else { return }
        locationManager.stopUpdatingLocation()
        let lat = location.coordinate.latitude
        let lon = location.coordinate.longitude
        weatherManager.fetchData(latitude: lat, longitude: lon)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        self.activityIndicator.stopAnimating()
        self.weatherBrickImage.image = brickImages.fail.image
        self.weatherBrickImage.isHidden = false
        self.temperatureLabel.text = ""
        self.weatherLabel.text = ""
        self.cityLabel.text = ""
        print(error)
    }
}

