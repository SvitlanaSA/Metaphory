//
//  BundleExtension.swift
//  SharedStuff
//
//  Created by Dmytro Maniakhin on 24.01.2024.
//

import Foundation

extension Bundle {
    class var sharedStuffBundle: Bundle? {
        Bundle(identifier: frameworkSharedStuffBundleID)
    }
}
