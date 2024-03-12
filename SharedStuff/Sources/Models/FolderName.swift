//
//  FolderName.swift
//  MetaCards
//
//  Created by Svetlana Stegnienko on 29.01.2024.
//

import Foundation

public enum FolderName: Int32 {
    case quote                 = 0
    case affirmations
    case favorite
    case shadows
    case colorInkonPaper
    case cartoon
    case horizon
    case manifestation
    case touchTheSoul
    case fairytale
    case watercolor
    case harmonyHues

    public var identifier: String {
        switch self {
        case .quote:
            "cFolderTitleQuote"
        case .affirmations:
            "cFolderTitleAffirmations"
        case .favorite:
            "cFolderTitleFavorite"
        case .shadows:
            "cFolderTitleShadows"
        case .colorInkonPaper:
            "cFolderTitleColorInkonPaper"
        case .cartoon:
            "cFolderTitleCartoon"
        case .horizon:
            "cFolderTitleHorizon"
        case .manifestation:
            "cFolderTitleManifestation"
        case .touchTheSoul:
            "cFolderTitleTouchTheSoul"
        case .fairytale:
            "cFolderTitleFairytale"
        case .watercolor:
            "cFolderTitleWatercolor"
        case .harmonyHues:
            "cFolderTitleHarmonyHues"
        }
    }

    public init?(identifier: String) {
        guard let type = Self.allCases.first(where: { $0.identifier == identifier }) else {
            return nil
        }
        self = type
    }
}

extension FolderName: Codable { }
extension FolderName: CaseIterable { }
extension FolderName: Identifiable {
    public var id: Self {
        self
    }
}
