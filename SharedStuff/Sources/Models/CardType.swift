//
//  CardType.swift
//  MetaCards
//
//  Created by Svetlana Stegnienko on 10.01.2024.
//

import Foundation

public enum CardType: Int32 {
    case metaCards          = 0
    case affirmations       = 1
    case quates             = 2

    public var identifier: String {
        switch self {
        case .metaCards:
            "cCardTypeMetaCards"
        case .affirmations:
            "cCardTypeAffirmations"
        case .quates:
            "cCardTypeQuates"
        }
    }

    public init?(identifier: String) {
        guard let type = Self.allCases.first(where: { $0.identifier == identifier }) else {
            return nil
        }
        self = type
    }
}

extension CardType: Codable { }
extension CardType: CaseIterable { }
extension CardType: Identifiable {
    public var id: Self {
        self
    }
}
