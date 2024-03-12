//
//  StringExtension.swift
//  MetaCards
//
//  Created by Dmytro Maniakhin on 24.01.2024.
//

import Foundation

extension String {
    public var localizedString: String {
        var result = self
        if let frameworkBundle = Bundle.sharedStuffBundle {
            result = frameworkBundle.localizedString(forKey: self, value: nil, table: "CardDataLocalizable")
        }
        if result == self {
            result = Bundle.main.localizedString(forKey: self, value: nil, table: nil)
        }
        return result
    }
}
