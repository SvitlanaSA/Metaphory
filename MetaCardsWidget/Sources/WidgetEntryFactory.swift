//
//  WidgetEntryFactory.swift
//  MetaCardsWidgetExtension
//
//  Created by Dmytro Maniakhin on 11.01.2024.
//

import Foundation

struct WidgetEntryFactory {
    static func getPlaceholderEntry() -> WidgetEntry {
        return WidgetEntry(card: nil)
    }
    
    static func getSnapshotEntry(for configuration: MetaCardsCategoriesIntent?) -> WidgetEntry {
        let category = configuration?.Category
        let subCategory = configuration?.SubCategory
        configuration?.Category = IntentHandler.selection(for: .quates)
        configuration?.SubCategory = nil

        let card = configuration?.cards.min { $0.title < $1.title }
        let entry = WidgetEntry(card: card)
        
        configuration?.Category = category
        configuration?.SubCategory = subCategory

        return entry
    }
    
    static func getRandomEntry(for configuration: MetaCardsCategoriesIntent?) -> WidgetEntry {
        let card = configuration?.cards.randomElement()
        return WidgetEntry(card: card)
    }
}
