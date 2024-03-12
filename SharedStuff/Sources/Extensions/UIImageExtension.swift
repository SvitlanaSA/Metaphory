//
//  UIImageExtension.swift
//  SharedStuff
//
//  Created by Dmytro Maniakhin on 24.01.2024.
//

import UIKit

public extension UIImage {
    class func proper(named: String) -> UIImage? {
        var result: UIImage?
        if let frameworkBundle = Bundle.sharedStuffBundle {
            result = UIImage(named: named, in: frameworkBundle, with: nil)
        }
        return result ?? UIImage(named: named)
    }
    
    func scalePreservingAspectRatio(targetSize: CGSize) -> UIImage {
        let widthRatio = targetSize.width / size.width
        let heightRatio = targetSize.height / size.height
        
        let scaleFactor = min(widthRatio, heightRatio)
        
        let scaledImageSize = CGSize(
            width: (size.width * scaleFactor).rounded(.towardZero),
            height: (size.height * scaleFactor).rounded(.towardZero)
        )

        let format = UIGraphicsImageRendererFormat.default()
        format.scale = self.scale
        let renderer = UIGraphicsImageRenderer(size: scaledImageSize, format: format)
        let imageRect = CGRect(origin: .zero, size: scaledImageSize)
        let scaledImage = renderer.image { _ in
            self.draw(in: imageRect)
        }
        
        return scaledImage
    }
}
