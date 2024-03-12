//
//  WidgetEntry.swift
//  MetaCardsWidgetExtension
//
//  Created by Dmytro Maniakhin on 10.01.2024.
//

import UIKit
import WidgetKit
import SharedStuff

struct WidgetEntry: TimelineEntry {
    var date: Date
    private let card: CDCard?
    
    init(date: Date = Date(), card: CDCard?) {
        self.date = date
        self.card = card
    }
    
    // MARK: - Private methods
    
    private func metacardViewModel(for card: CDCard) -> WidgetMetacardViewModel {
        let helper: AttachmentResourceHelperProtocol = PersistenceControllerProvider.previewMode ? StubAttachmentResourceHelper() : AttachmentResourceHelper()
        return WidgetMetacardViewModel(attachmentResourceHelper: helper, card: card)
    }
}

extension WidgetEntry: WidgetMainViewModelProtocol {
    var viewType: WidgetViewType {
        guard let card else { return .placeholder }
        if card.cardType == .metaCards {
            return .metacard
        }
        return .textual
    }
    
    func createMetacardViewModel() -> WidgetMetacardViewModelProtocol {
        guard let card else { return StubWidgetMetacardViewModel() }
        return metacardViewModel(for: card)
    }
    
    func createTextualViewModel() -> WidgetTextualViewModelProtocol {
        guard let card else { return StubWidgetTextualViewModel() }
        return WidgetTextualViewModel(card: card)
    }
}
