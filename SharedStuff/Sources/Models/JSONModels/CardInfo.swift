//
//  CardInfo.swift
//  MetaCards
//
//  Created by Dmytro Maniakhin on 18.12.2023.
//

import Foundation

struct CardInfo {
    var identifierInfo: CardIdentifierInfo?
    
    var title: String = ""
    var categories: [String] = []
    var frontImageLink: String = ""
    var frontImageThumbnailName: String = ""

    var cardTypeIdentifer: String {
        var result = ""
        if identifierInfo?.identifierType == "Metacard" {
            result = "cCardTypeMetaCards"
        } else if identifierInfo?.identifierType == "Affirmation" {
            result = "cCardTypeAffirmations"
        } else if identifierInfo?.identifierType == "Quote" {
            result = "cCardTypeQuates"
        }

        return result
    }
}
