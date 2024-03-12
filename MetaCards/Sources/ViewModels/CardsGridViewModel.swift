//
//  CardsGridViewModel.swift
//  MetaCards
//
//  Created by Svetlana Stegnienko on 20.12.2023.
//

import Combine
import SharedStuff

class CardsGridViewModel: ObservableObject {
    @Published private(set) var cards: [CDCard] = []
    @Published var showDescriptionSheet = false
    var folder: CDFolder?
    private(set) var cardsGridToolbarViewModel: CardsGridToolbarViewModel
    private var cardNavigationViewModel: CardNavigationViewModel?
    private var cancelableOnCardFilterUpdates: AnyCancellable?
    private var cardFilterModel = CardFilterModel()

    init(cardsGridToolbarViewModel: CardsGridToolbarViewModel = CardsGridToolbarViewModel()) {
        self.cardsGridToolbarViewModel = cardsGridToolbarViewModel
        
        subscribeOnCardFilterUpdates()
    }
    
    var title: String {
        folder?.title ?? ""
    }
    
    func invalidateStatesOnViewAppear() {
        updateStates(for: folder)
    }
    
    func updateContent(for folder: CDFolder?) {
        updateStates(for: folder)
        cardsGridToolbarViewModel.updateContent(for: folder)
    }
    
    func setupCardsApplyingFilters() {
        var cards = folder?.cards ?? []
        if let folderUUID = folder?.uuid,
           let cardFilter = cardFilterModel.cardFilter(folderUUID: folderUUID) {
            cards = cardFilter.filtered(cards: cards)
        }
        self.cards = cards.sorted(by: { left, right in
            (left.locked ? 1 : 0) < (right.locked ? 1 : 0)
        })
    }
    
    func mixCards() {
        guard let folder else { return }
        folder.shuffleItems()
        setupCardsApplyingFilters()
    }
    
    func cardNavigationViewModel(for card: CDCard) -> CardNavigationViewModel? {
        let cards = cards.filter {$0.locked == false}
        guard let cardIndex = cards.firstIndex(of: card) else { return nil }
        if let viewModel = cardNavigationViewModel {
            if viewModel.selectedCardIndex == cardIndex && viewModel.cards == cards {
                return viewModel
            }
        }
        
        let manager = PersistenceControllerProvider.controller.entityManager
        let viewModel = CardNavigationViewModel(entityManager: manager, index: cardIndex, in: cards)
        cardNavigationViewModel = viewModel
        return viewModel
    }
    
    // MARK: - Private methods

    private func updateStates(for folder: CDFolder?) {
        self.folder = folder

        self.setupCardsApplyingFilters()
    }
    
    private func subscribeOnCardFilterUpdates() {
        let publisher = NotificationCenter.default.publisher(for: CardFilterModel.filterUpdatedNotificationName)
            
        cancelableOnCardFilterUpdates = publisher.sink { [weak self] notification in
            guard let folderUUID = notification.userInfo?[CardFilterModel.filterUpdatedNotificationFolderUUIDKey] as? UUID,
                  let self else { return }
            
            if folderUUID == self.folder?.uuid {
                self.setupCardsApplyingFilters()
            }
        }
    }
}
