//
//  UIDeviceExtension.swift
//  MetaCards
//
//  Created by Dmytro Maniakhin on 24.01.2024.
//

import UIKit

public extension UIDevice {
    static let isIphone = UIDevice.current.userInterfaceIdiom == .phone
}
