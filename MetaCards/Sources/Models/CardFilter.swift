//
//  CardFilter.swift
//  MetaCards
//
//  Created by Dmytro Maniakhin on 22.01.2024.
//

import SharedStuff

struct CardFilter {
    private(set) var cardTypes: Set<CardType> = []
    private(set) var cardCategories: Set<CardCategory> = []
    private var allOptionsSelected: Bool {
        cardTypes.count == CardType.allCases.count && cardCategories.count == CardCategory.allCases.count
    }

    var isEmpty: Bool {
        cardTypes.isEmpty && cardCategories.isEmpty
    }
    
    mutating func clearFilter() {
        cardTypes.removeAll()
        cardCategories.removeAll()
    }
    
    mutating func toogle(cardType: CardType) {
        if cardTypes.remove(cardType) == nil {
            cardTypes.insert(cardType)
        }
        invalidateStates()
    }
    
    mutating func toogle(cardCategory: CardCategory) {
        if cardCategories.remove(cardCategory) == nil {
            cardCategories.insert(cardCategory)
        }
        invalidateStates()
    }

    func filtered(cards: [CDCard]) -> [CDCard] {
        Self.filter(cards: cards, by: self)
    }
    
    static func filter(cards: [CDCard], by filter: CardFilter) -> [CDCard] {
        guard !filter.isEmpty else { return cards }
        return cards.filter { card in
            var result = true
            if !filter.cardTypes.isEmpty {
                result = filter.cardTypes.contains(card.cardType)
            }
            if result && !filter.cardCategories.isEmpty {
                let cardCategories = card.categories
                
                result = false
                for cardCategory in cardCategories {
                    if filter.cardCategories.contains(cardCategory) {
                        result = true
                        break
                    }
                }
            }
            
            return result
        }
    }
    
    // MARK: - Private methods
    
    private mutating func invalidateStates() {
        if allOptionsSelected {
            clearFilter()
        }
    }
}

extension CardFilter: Equatable { }
extension CardFilter: Codable { }
