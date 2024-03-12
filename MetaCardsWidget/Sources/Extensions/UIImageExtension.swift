//
//  UIImageExtension.swift
//  MetaCardsWidgetExtension
//
//  Created by Dmytro Maniakhin on 29.01.2024.
//

import UIKit
import SharedStuff

extension UIImage {
    func properScaled() -> UIImage {
        let imageSizeSquare = size.width * size.height
        let maxAvailableImageSizeSquare = UIDevice.isIphone ? 5_193_840.0 : 8_056_990.0
        var result = self
        if maxAvailableImageSizeSquare < imageSizeSquare {
            let scaleFactor = sqrt(maxAvailableImageSizeSquare / imageSizeSquare)
            let newSize = CGSize(
                width: size.width * scaleFactor,
                height: size.height * scaleFactor
            )
            result = self.scalePreservingAspectRatio(targetSize: newSize)
        }
        
        return result
    }
}
