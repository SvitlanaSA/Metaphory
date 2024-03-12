//
//  CardIdentifiersInfo.swift
//  MetaCards
//
//  Created by Dmytro Maniakhin on 15.01.2024.
//

import Foundation

struct CardIdentifiersInfo: Codable {
    var count: Int
    var frontImageLinkBase: String
    var frontImageLinkExtension: String
    var frontImageThumbnailBase: String
    var identifierInfo: CardIdentifierInfo
}
