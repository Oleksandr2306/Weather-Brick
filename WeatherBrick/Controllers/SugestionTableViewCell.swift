//
//  SugestionTableViewCell.swift
//  WeatherBrick
//
//  Created by Oleksandr Melnyk on 14.09.2022.
//  Copyright © 2022 VAndrJ. All rights reserved.
//

import UIKit

final class SugestionTableViewCell: UITableViewCell {

    @IBOutlet weak private var cityLabel: UILabel!
    @IBOutlet weak private var countryLabel: UILabel!
    @IBOutlet weak private var coordinatesLabel: UILabel!

    func configure(city: String, country: String, latitude: Double, longitude: Double) {
        cityLabel.text = city
        countryLabel.text = country
        coordinatesLabel.text = "Lat: \(latitude); Lon: \(longitude)"
        
        self.layer.borderWidth = 0
        self.layer.cornerRadius = 10
    }
}
