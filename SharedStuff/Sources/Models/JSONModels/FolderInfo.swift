//
//  FolderInfo.swift
//  MetaCards
//
//  Created by Dmytro Maniakhin on 15.01.2024.
//

import Foundation

struct FolderInfo: Codable {
    enum CodingKeys: CodingKey {
        case title
        case subtitle
        case fullDescription
        case cardIdentifierType
        case cardIdentifierAddition
        case favorite
        case merchantID
        case locked
    }

    var title: String = ""
    var subtitle: String = ""
    var fullDescription: String = ""
    var cardIdentifierType: String = ""
    var cardIdentifierAddition: String = ""
    var favorite: Bool = false
    var merchantID: String = ""
    var locked: Bool = true

    var cards: [CardInfo] = []
}
