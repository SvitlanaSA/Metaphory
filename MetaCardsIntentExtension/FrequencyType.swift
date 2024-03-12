//
//  frequencyEnum.swift
//  MetaCards
//
//  Created by Svetlana Stegnienko on 08.12.2023.
//

import Foundation

enum FrequencyType: String, CaseIterable {
    case every1hours = "Every 1 hours"
    case every2hours = "Every 2 hours"
    case every6hours = "Every 6 hours"
    case every12hours = "Every 12 hours"
    case everyday = "Every day"
    case everyweek = "Every week"
    
    func convertToHours() -> Int {
        switch self {
        case .every1hours:
            return 1
        case .every2hours:
            return 2
        case .every6hours:
            return 6
        case .every12hours:
            return 12
        case .everyday:
            return 24
        case .everyweek:
            return 7 * 24
        }
    }
}
