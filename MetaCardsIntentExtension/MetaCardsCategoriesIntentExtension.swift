//
//  MetaCardsCategoriesIntent.swift
//  MetaCards
//
//  Created by Svetlana Stegnienko on 12.12.2023.
//

import SharedStuff

extension MetaCardsCategoriesIntent {
    var cardTypes: [CardType] {
        IntentHandler.cardTypes(from: self.Category)
    }
    
    var frequencyType: FrequencyType? {
        IntentHandler.frequencyType(from: self.Time)
    }
    
    var cardCategories: [CardCategory] {
        return cardCategories(for: cardTypes)
    }

    var cards: [CDCard] {
        let cards = fetchCards(for: cardTypes)
        return filtered(cards: cards, byCategories: SubCategory)
    }

    // MARK: - Private methods

    private func cardCategories(for cardTypes: [CardType]) -> [CardCategory] {
        guard !cardTypes.isEmpty else { return CardCategory.allCases }
        let cards = fetchCards(for: cardTypes)
        return uniqueCardCategories(for: cards)
    }

    private func fetchCards(for cardTypes: [CardType]) -> [CDCard] {
        var format = "\(#keyPath(CDCard.cdLocked)) == NO"
        if !cardTypes.isEmpty {
            format += " AND ("
            for (index, cardType) in cardTypes.enumerated() {
                format += "\(#keyPath(CDCard.cdCardType)) == \(cardType.rawValue)"
                if index != cardTypes.count - 1 {
                    format += " OR "
                }
            }
            format += ")"
        }
        return PersistenceControllerProvider.controller.entityManager.fetchEntities(predicate: format)
    }
    
    private func uniqueCardCategories(for cards: [CDCard]) -> [CardCategory] {
        var categories = Set<CardCategory>()
        for card in cards {
            categories.formUnion(card.categories)
        }
        
        return Array(categories)
    }
    
    private func filtered(cards: [CDCard], byCategories: [Selection]?) -> [CDCard] {
        guard let subCategories = byCategories else { return cards }
        let categories: [CardCategory] = subCategories.compactMap {
            IntentHandler.cardCategory(from: $0)
        }
        guard !subCategories.isEmpty else { return cards }

        let filteredCards = cards.filter { card in
            return !card.categories.intersection(categories).isEmpty
        }

        return filteredCards.count == 0 ? cards : filteredCards
    }
}
