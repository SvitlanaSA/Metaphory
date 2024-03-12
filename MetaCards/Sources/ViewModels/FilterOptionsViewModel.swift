//
//  FilterOptionsViewModel.swift
//  Metaphory
//
//  Created by Dmytro Maniakhin on 22.02.2024.
//

import SwiftUI
import SharedStuff

class FilterOptionsViewModel: ObservableObject {
    @Published private(set) var allCardsSelected : Bool = false
    @Published private(set) var cardTypesAvailable : Bool = false
    @Published private(set) var cardTypes : [CardType] = []
    @Published private(set) var cardCategories : [CardCategory] = []
    @Published var cardFilter = CardFilter()
    private var cardCategoriesLocked : [CardCategory : Bool] = [:]
    private var cards: [CDCard]
    
    init(cards: [CDCard]) {
        self.cards = cards
        
        setupUIStates()
    }
    
    var canPerformFiltering: Bool {
        cardTypes.count > 1 || cardCategories.count > 1
    }
    
    func selectedItem(for cardType: CardType) -> Bool {
        return cardFilter.cardTypes.contains(cardType)
    }
    
    func selectedItem(for cardCategory: CardCategory) -> Bool {
        return cardFilter.cardCategories.contains(cardCategory)
    }
    
    func lockedItem(for cardType: CardType) -> Bool {
        return false
    }
    
    func lockedItem(for cardCategory: CardCategory) -> Bool {
        return cardCategoriesLocked[cardCategory] ?? false
    }
    
    func allCardsAction() {
        cardFilter.clearFilter()
        updateAllCardsSelected()
    }
    
    func selectAction(for cardType: CardType) {
        cardFilter.toogle(cardType: cardType)
        updateAllCardsSelected()
    }
    
    func selectAction(for cardCategory: CardCategory) {
        cardFilter.toogle(cardCategory: cardCategory)
        updateAllCardsSelected()
    }
    
    func apply(cardFilter: CardFilter) {
        self.cardFilter = CardFilter(cardTypes: cardFilter.cardTypes.filter {
            cardTypes.contains($0)
        }, cardCategories: cardFilter.cardCategories.filter {
            cardCategories.contains($0)
        })
        updateAllCardsSelected()
    }
    
    // MARK: - Private methods
    
    private func setupUIStates() {
        updateCardTypes(for: cards)
        updateCardCategories(for: cards)
        updateCardCategoriesLocked(for: cards)
        updateAllCardsSelected()
    }
    
    private func updateCardTypes(for cards: [CDCard]) {
        let allCardTypes = cards.map { $0.cardType }
        cardTypes = CardType.allCases.filter { cardType in
            allCardTypes.contains(cardType)
        }
        cardTypesAvailable = cardTypes.count > 1
    }
    
    private func updateCardCategories(for cards: [CDCard]) {
        let allCardCategories = cards.flatMap { $0.categories }
        cardCategories = CardCategory.allCases.filter { cardCategory in
            allCardCategories.contains(cardCategory)
        }
    }
    
    private func updateCardCategoriesLocked(for cards: [CDCard]) {
        cardCategoriesLocked = [:]
        for cardCategory in cardCategories {
            var locked = true
            for card in cards {
                guard card.categories.contains(cardCategory) else { continue }
                locked = card.locked
                if !locked {
                    break
                }
            }
            cardCategoriesLocked[cardCategory] = locked
        }
    }
    
    private func updateAllCardsSelected() {
        allCardsSelected = cardFilter.isEmpty
    }
}
