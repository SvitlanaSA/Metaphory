//
//  CardCategory.swift
//  MetaCards
//
//  Created by Dmytro Maniakhin on 12.12.2023.
//

import Foundation

public enum CardCategory: Int32 {
    case shadows                 = 0
    case colorInkonPaper
    case cartoon
    case manifestation
    case touchTheSoul
    case horizon
    case fairytale
    case watercolor
    case HarmonyHues
    case healthAndWellBeing
    case selfLove
    case successAndAbundance
    case inspirationAndCreativity
    case loveAndRelationships
    case lifeAndWisdom
    case positivityAndMindfulness
    case successAndMotivation

    public var identifier: String {
        switch self {
            case .shadows:
                "cFolderTitleShadows"
            case .colorInkonPaper:
                "cFolderTitleColorInkonPaper"
            case .cartoon:
                "cFolderTitleCartoon"
            case .manifestation:
                "cFolderTitleManifestation"
            case .touchTheSoul:
                "cFolderTitleTouchTheSoul"
            case .horizon:
                "cFolderTitleHorizon"
            case .fairytale:
                "cCardCategoryFairytale"
            case .watercolor:
                "cCardCategoryWatercolor"
            case .HarmonyHues:
                "cCardCategoryHarmonyHues"
            case .healthAndWellBeing:
                "cCardCategoryHealthAndWellBeing"
            case .selfLove:
                "cCardCategorySelf-Love"
            case .successAndAbundance:
                "cCardCategorySuccessAndAbundanceAffirmations"
            case .inspirationAndCreativity:
                "cCardCategoryInspirationAndCreativity"
            case .loveAndRelationships:
                "cCardCategoryRelationships"
            case .lifeAndWisdom:
                "cCardCategoryLifeAndWisdom"
            case .positivityAndMindfulness:
                "cCardCategoryPositivityAndMindfulness"
            case .successAndMotivation:
                "cCardCategorySuccessAndMotivation"
        }
    }
    
    public init?(identifier: String) {
        guard let type = Self.allCases.first(where: { $0.identifier == identifier }) else {
            return nil
        }
        self = type
    }
}

extension CardCategory: Codable { }
extension CardCategory: CaseIterable { }
extension CardCategory: Identifiable {
    public var id: Self {
        self
    }
}
