//
//  NSDataAssetExtension.swift
//  SharedStuff
//
//  Created by Dmytro Maniakhin on 24.01.2024.
//

import UIKit

extension NSDataAsset {
    class func proper(named: NSDataAssetName) -> NSDataAsset? {
        let result: NSDataAsset?
        if let bundle = Bundle.sharedStuffBundle {
            result = NSDataAsset(name: named, bundle: bundle)
        } else {
            result = NSDataAsset(name: named)
        }
        return result
    }
}
