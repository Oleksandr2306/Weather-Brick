//
//  SugestionTableViewCell.swift
//  WeatherBrick
//
//  Created by Oleksandr Melnyk on 14.09.2022.
//  Copyright © 2022 VAndrJ. All rights reserved.
//

import UIKit

class SugestionTableViewCell: UITableViewCell {

    @IBOutlet weak private var cityLabel: UILabel!
    @IBOutlet weak private var countryLabel: UILabel!
    @IBOutlet weak private var coordinatesLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func setCityLabel(city: String) {
        cityLabel.text = city
    }
    
    func setCountryLabel(country: String) {
        countryLabel.text = country
    }
    
    func setCoordinatesLabel(latitude: Double, longitude: Double) {
        coordinatesLabel.text = "Lat: \(latitude); Lon: \(longitude)"
    }
    
}
