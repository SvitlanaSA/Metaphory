//
//  IntentHandler.swift
//  MetaCardsIntentExtension
//
//  Created by Svetlana Stegnienko on 06.12.2023.
//

import Intents
import SharedStuff

class IntentHandler: INExtension, MetaCardsCategoriesIntentHandling {
    
    var cardTypeOptions: [Selection] {
        let handlerClass = IntentHandler.self
        var list = CardType.allCases.map(handlerClass.selection(for:))
        list.insert(handlerClass.selectionForAllCardType(), at: 0)
        return list
    }
    
    func provideCategoryOptionsCollection(for intent: MetaCardsCategoriesIntent, with completion: @escaping (INObjectCollection<Selection>?, Error?) -> Void) {
        completion(INObjectCollection(items: cardTypeOptions), nil)
    }
    
    func provideSubCategoryOptionsCollection(for intent: MetaCardsCategoriesIntent) async throws -> INObjectCollection<Selection> {
        let list = intent.cardCategories.map(Self.selection(for:))
        return INObjectCollection(items: list)
    }
    
    func provideTimeOptionsCollection(for intent: MetaCardsCategoriesIntent) async throws -> INObjectCollection<Selection> {
        let list = FrequencyType.allCases.map(Self.selection(for:))
        return INObjectCollection(items: list)
    }
    
    func defaultCategory(for intent: MetaCardsCategoriesIntent) -> Selection? {
        cardTypeOptions.first
    }
    
    override func handler(for intent: INIntent) -> Any {
        return self
    }
    
    static func selectionForAllCardType() -> Selection {
        Selection(identifier: cSelectionAllCardTypeIdentifier, display: cSelectionAllCardTypeIdentifier.localizedString)
    }
    
    static func selection(for cardType: CardType) -> Selection {
        Selection(identifier: cardType.identifier, display: cardType.identifier.localizedString)
    }
    
    static func selection(for cardCategory: CardCategory) -> Selection {
        Selection(identifier: cardCategory.identifier, display: cardCategory.identifier.localizedString)
    }
    
    static func selection(for frequencyType: FrequencyType) -> Selection {
        Selection(identifier: frequencyType.rawValue, display: frequencyType.rawValue.localizedString)
    }
    
    static func cardTypes(from selection: Selection?) -> [CardType] {
        guard let identifier = selection?.identifier else { return [] }
        var result = [CardType]()
        if let cardType = CardType(identifier: identifier) {
            result.append(cardType)
        } else if identifier == cSelectionAllCardTypeIdentifier {
            result = CardType.allCases
        }
        
        return result
    }
    
    static func cardCategory(from selection: Selection?) -> CardCategory? {
        CardCategory(identifier: selection?.identifier ?? "")
    }
    
    static func frequencyType(from selection: Selection?) -> FrequencyType? {
        FrequencyType(rawValue: selection?.identifier ?? "")
    }
}
