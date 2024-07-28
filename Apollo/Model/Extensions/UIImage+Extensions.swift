//
//  UIImage+Extensions.swift
//  Apollo
//
//  Created by Matoi on 26.06.2024.
//

import UIKit

extension UIImage {
    static func solidFill(with color: UIColor) -> UIImage {
        let lightModeImage = Self.generatePixel(ofColor: color, userInterfaceStyle: .light)
        let darkModeImage = Self.generatePixel(ofColor: color, userInterfaceStyle: .dark)
        lightModeImage.imageAsset?.register(darkModeImage, with: UITraitCollection(userInterfaceStyle: .dark))
    
        return lightModeImage
    }
    
    static private func generatePixel(ofColor color: UIColor, userInterfaceStyle: UIUserInterfaceStyle) -> UIImage {
        
        var image: UIImage!
        
        if #available(iOS 13.0, *) {
            UITraitCollection(userInterfaceStyle: userInterfaceStyle).performAsCurrent {
                image = .generatePixel(ofColor: color)
            }
        } else {
            image = .generatePixel(ofColor: color)
        }
        
        return image
    }
    
    static private func generatePixel(ofColor color: UIColor) -> UIImage {
        let pixel = CGRect(x: 0.0, y: 0.0, width: 1.0, height: 1.0)
        UIGraphicsBeginImageContext(pixel.size)
        defer { UIGraphicsEndImageContext() }
        guard let context = UIGraphicsGetCurrentContext() else {
            return UIImage()
        }
        context.setFillColor(color.cgColor)
        context.fill(pixel)
        return UIGraphicsGetImageFromCurrentImageContext() ?? UIImage()
    }
}
