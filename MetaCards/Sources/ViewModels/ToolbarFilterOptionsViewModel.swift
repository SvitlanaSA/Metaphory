//
//  ToolbarFilterOptionsViewModel.swift
//  MetaCards
//
//  Created by Svetlana Stegnienko on 13.01.2024.
//

import Combine
import SharedStuff

class ToolbarFilterOptionsViewModel: ObservableObject {
    private var cardFilterModel = CardFilterModel()
    private var folder: CDFolder?
    private var cancelableOnCardFilterUpdates: AnyCancellable?
    @Published private(set) var filterOptionsViewModel: FilterOptionsViewModel?

    func updateContent(for folder: CDFolder?) {
        self.folder = folder
        setupFilterOptionsViewModel()
    }
    
    // MARK: - Private methods
    
    private func setupFilterOptionsViewModel() {
        guard let folder else { return }
        
        let filterOptionsViewModel = FilterOptionsViewModel(cards: folder.cards)
        self.filterOptionsViewModel = filterOptionsViewModel
        cancelableOnCardFilterUpdates = filterOptionsViewModel.$cardFilter.sink(receiveValue: { [weak self] cardFilter in
            self?.store(cardFilter: cardFilter)
        })
        if let storedCardFilter = cardFilterModel.cardFilter(folderUUID: folder.uuid) {
            filterOptionsViewModel.apply(cardFilter: storedCardFilter)
        }
    }
            
    private func store(cardFilter: CardFilter) {
        guard let folder else { return }
        let filter = cardFilter.isEmpty == true ? nil : cardFilter
        cardFilterModel.store(filter, for: folder.uuid)
    }
}
