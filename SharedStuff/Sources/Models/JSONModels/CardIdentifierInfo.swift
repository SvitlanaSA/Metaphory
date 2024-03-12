//
//  CardIdentifierInfo.swift
//  MetaCards
//
//  Created by Dmytro Maniakhin on 12.01.2024.
//

import Foundation

struct CardIdentifierInfo: Codable {
    enum CodingKeys: CodingKey {
        case identifierRoot
        case identifierType
        case identifierAddition
    }

    var identifierRoot: String = ""
    var identifierType: String = ""
    var identifierAddition: String = ""

    var number: Int = 0
    var delimeter: String = "_"
    var identifier: String = ""
    
    func makeIdentifier() -> String {
        var identifier = identifierRoot + delimeter + identifierType
        if !identifierAddition.isEmpty {
            identifier += delimeter + identifierAddition
        }
        identifier += delimeter + "\(number)"
        
        return identifier
    }
}
