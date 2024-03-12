//
//  CardNavigationViewModel.swift
//  MetaCards
//
//  Created by Dmytro Maniakhin on 21.12.2023.
//

import SharedStuff

class CardNavigationViewModel: ObservableObject {
    @Published private(set) var favoriteButtonFilled: Bool = false
    @Published var selectedCardIndex: Int {
        didSet {
            updateFavoriteButtonFilledState()
            invalidateCardDetailViewModel(for: oldValue, newIndex: selectedCardIndex)
        }
    }
    private(set) var cards: [CDCard]
    private(set) var cardViewModels: [CDCard : CardDetailViewModel] = [:]
    private let entityManager: DataBaseEntityManager

    var isPreviousButtonDisabled: Bool {
        return 0 == selectedCardIndex
    }
    

    var isNextButtonDisabled: Bool {
        return (cards.count - 1) <= selectedCardIndex
    }

    var infoButtonVisible: Bool {
        return currentCard().cardType == .metaCards
    }

    init(entityManager: DataBaseEntityManager, index: Int, in cards: [CDCard]) {
        self.entityManager = entityManager
        self.selectedCardIndex = index
        self.cards = cards

        updateFavoriteButtonFilledState()
        prepareCardDetailViewModelsForAppearence(for: index)
    }
    
    deinit {
        cancelPrepareCardDetailViewModelsForAppearence(for: selectedCardIndex)
    }
    
    func toogleFavoriteState() {
        let card = currentCard()
        let context = entityManager.viewContext
        guard let folder = entityManager.fetchFolderFavorite() else { return }
        if !entityManager.remove(card: card, from: folder) {
            let folderItem = entityManager.insert(card: card, in: folder, at: folder.cdItems?.count ?? 0)
            folderItem?.cdRemovable = true
        }
        context.saveContext()
        updateFavoriteButtonFilledState()
    }
    
    func dequeCardDetailViewModel(for card: CDCard) -> CardDetailViewModel {
        return cardViewModels[card] ?? {
            let result = CardDetailViewModel(card: card)
            cardViewModels[card] = result
            return result
        }()
    }
    
    // MARK: - Private methods
    
    static private func favoriteButtonFilledState(for card: CDCard) -> Bool {
        nil != card.favoriteFolderItem
    }

    private func currentCard() -> CDCard {
        cards[selectedCardIndex]
    }
    
    private func updateFavoriteButtonFilledState() {
        let card = currentCard()
        favoriteButtonFilled = Self.favoriteButtonFilledState(for: card)
    }
    
    private func prepareCardDetailViewModelsForAppearence(for index: Int) {
        let range = indexRange(for: index)
        for card in cards[range] {
            dequeCardDetailViewModel(for: card).prepareForAppearence()
        }
    }
    
    private func cancelPrepareCardDetailViewModelsForAppearence(for index: Int) {
        let range = indexRange(for: index)
        for card in cards[range] {
            dequeCardDetailViewModel(for: card).cancelPrepareForAppearence()
        }
    }
    
    private func invalidateCardDetailViewModel(for oldIndex: Int, newIndex: Int) {
        let oldRange = indexRange(for: oldIndex)
        let newRange = indexRange(for: newIndex)
        for index in newRange {
            if !oldRange.contains(index) {
                dequeCardDetailViewModel(for: cards[index]).prepareForAppearence()
            }
        }
        for index in oldRange {
            if !newRange.contains(index) {
                dequeCardDetailViewModel(for: cards[index]).cancelPrepareForAppearence()
            }
        }
    }
    
    private func indexRange(for index: Int) -> Range<Int> {
        let distanceOfRange = 2
        let startIndex = cards.index(index, offsetBy: -distanceOfRange, limitedBy: cards.startIndex) ?? cards.startIndex
        let endIndex = cards.index(index, offsetBy: distanceOfRange+1, limitedBy: cards.endIndex) ?? cards.endIndex
        return startIndex..<endIndex
    }
}
