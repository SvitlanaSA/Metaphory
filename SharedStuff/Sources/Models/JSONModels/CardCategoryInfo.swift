//
//  CardCategoryInfo.swift
//  MetaCards
//
//  Created by Dmytro Maniakhin on 12.01.2024.
//

import Foundation

struct CardCategoryInfo: Codable {
    var categoryIdentifier: String
    var cardIdentifiers: [String]
}
