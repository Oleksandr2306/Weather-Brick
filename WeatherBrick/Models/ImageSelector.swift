//
//  ImageSelector.swift
//  WeatherBrick
//
//  Created by Oleksandr Melnyk on 23.09.2022.
//  Copyright © 2022 VAndrJ. All rights reserved.
//

import UIKit
import Foundation

final class ImageSelector {
    
    private enum brickImages {
        case raining
        case normal
        case fog
        case hot
        case snowing
        case windy
        case fail
        
        var image: UIImage? {
            switch self {
            case .raining:
                return UIImage(named: "raining")
            case .normal:
                return UIImage(named: "normal")
            case .fog:
                return UIImage(named: "normal")
            case .hot:
                return UIImage(named: "hot")
            case .snowing:
                return UIImage(named: "snowing")
            case .windy:
                return UIImage(named: "normal")
            case .fail:
                return UIImage(named: "rope")
            }
        }
    }
    
    func setBrickImage(for image: UIImageView, with weatherCondition: WeatherData) {
        
        image.layer.removeAllAnimations()
        image.alpha = 1
        
        switch weatherCondition.weather[0].id {
        case 0...200 :
            image.image = brickImages.hot.image
        case 200...599 :
            image.image = brickImages.raining.image
        case 600...699 :
            image.image = brickImages.snowing.image
        case 700...762 :
            //fog
            image.image = brickImages.normal.image
            animateFog(for: image)
        case 763...799 :
            //wind
            image.image = brickImages.normal.image
            animateWind(for: image)
        case 800...900 :
            image.image = brickImages.normal.image
        default:
            image.image = brickImages.normal.image
        }
        
        if image.image == nil {
            image.image = brickImages.fail.image
        }
        
    }
    
    func fail(for image: UIImageView) {
        image.image = brickImages.fail.image
    }
    
    private func animateFog(for image: UIImageView) {
        UIView.animateKeyframes(withDuration: 2, delay: 0, options: [.calculationModeLinear], animations: {
            image.alpha = 0.4
        }, completion: nil)
    }
    
    private func animateWind(for image: UIImageView) {
        UIView.animateKeyframes(withDuration: 3, delay: 0.5, options: [.repeat, .autoreverse], animations: {
            image.layer.anchorPoint = CGPoint(x: 1, y: 0.5)
            image.transform = CGAffineTransform(rotationAngle: 0.1)
        }, completion: nil)
    }
    
}
