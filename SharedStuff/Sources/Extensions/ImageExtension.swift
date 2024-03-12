//
//  ImageExtension.swift
//  SharedStuff
//
//  Created by Dmytro Maniakhin on 24.01.2024.
//

import SwiftUI

public extension Image {
    static func proper(named: String) -> Image {
        if let image = UIImage.proper(named: named) {
            return Image(uiImage: image)
        }
        return Image(named)
    }
}
