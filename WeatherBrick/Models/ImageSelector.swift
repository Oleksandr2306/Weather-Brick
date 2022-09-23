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
    
    private var image = UIImage()
    
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
                guard let image = UIImage(named: "raining") else { return UIImage() }
                return image
            case .normal:
                guard let image = UIImage(named: "normal") else { return UIImage() }
                return image
            case .fog:
                guard let image = UIImage(named: "normal") else { return UIImage() }
                return image
            case .hot:
                guard let image = UIImage(named: "hot") else { return UIImage() }
                return image
            case .snowing:
                guard let image = UIImage(named: "snowing") else { return UIImage() }
                return image
            case .windy:
                guard let image = UIImage(named: "normal") else { return UIImage() }
                return image
            case .fail:
                guard let image = UIImage(named: "fail") else { return UIImage() }
                return image
            }
        }
    }
    
    func setBrickImage(for image: UIImageView, with weatherCondition: WeatherData) {
        image.layer.removeAllAnimations()
        image.alpha = 1

        switch weatherCondition.weather[0].id {
        case 0...200 :
            image.image = brickImages.hot.image
            break
        case 200...599 :
            image.image = brickImages.raining.image
            break
        case 600...699 :
            image.image = brickImages.snowing.image
            break
        case 700...762 :
            //fog
            image.image = brickImages.normal.image
            animationFog(image: image)
            break
        case 763...799 :
            //wind
            image.image = brickImages.normal.image
            animationWind(image: image)
            break
        case 800...900 :
            image.image = brickImages.normal.image
            break
        default:
            image.image = brickImages.normal.image
            break
        }
    }
    
    func fail(for image: UIImageView) {
        image.image = brickImages.fail.image
    }
    
    private func animationFog(image: UIImageView) {
        UIView.animateKeyframes(withDuration: 2, delay: 0, options: [.calculationModeLinear], animations: {
            image.alpha = 0.4
        }, completion: nil)
    }
    
    private func animationWind(image: UIImageView) {
        UIView.animateKeyframes(withDuration: 3, delay: 0.5, options: [.repeat, .autoreverse], animations: {
            image.layer.anchorPoint = CGPoint(x: 1, y: 0.5)
            image.transform = CGAffineTransform(rotationAngle: 0.1)
        }, completion: nil)
    }
    
}
