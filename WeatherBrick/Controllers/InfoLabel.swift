//
//  InfoWindow.swift
//  WeatherBrick
//
//  Created by Oleksandr Melnyk on 18.09.2022.
//  Copyright © 2022 VAndrJ. All rights reserved.
//

import Foundation
import UIKit

final class InfoLabel: UILabel {
    
    var isOpen = false
    private let title = "INFO:\n\n"
    private var normalText =
        """
        Brick is wet - raining\n
        Brick is dry - sunny \n
        Brick is hard to see - fog\n
        Brick with cracks - very hot \n
        Brick with snow - snow\n
        Brick is swinging- windy\n
        Brick is gone - no Internet
        """
    
    lazy var darkLabelInfo: UILabel = {
        let darkLabelInfo = UILabel()
        darkLabelInfo.isHidden = false
        darkLabelInfo.frame = CGRect(x: 0, y: 0, width: 277, height: 372)
        darkLabelInfo.layer.backgroundColor = UIColor(red: 0.984, green: 0.373, blue: 0.161, alpha: 1).cgColor
        darkLabelInfo.layer.cornerRadius = 15
        darkLabelInfo.translatesAutoresizingMaskIntoConstraints = false
        return darkLabelInfo
    }()
    
    lazy var windowOpen: UILabel = {
        let labelOpenInfo = UILabel()
        labelOpenInfo.layer.backgroundColor = UIColor(red: 1, green: 0.6, blue: 0.375, alpha: 1).cgColor
        labelOpenInfo.layer.cornerRadius = 15
        labelOpenInfo.numberOfLines = 0
        labelOpenInfo.textAlignment = .center
        let attrs = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 18)]
        let attributedString = NSMutableAttributedString(string: title, attributes: attrs)
        labelOpenInfo.font = UIFont(name: "SF Pro Display Light", size: 15)
        let normalString = NSMutableAttributedString(string: normalText)
        attributedString.append(normalString)
        labelOpenInfo.attributedText = attributedString
        return labelOpenInfo
    }()
    
}
