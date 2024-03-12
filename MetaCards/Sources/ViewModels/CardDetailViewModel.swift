//
//  CardDetailViewModel.swift
//  MetaCards
//
//  Created by Dmytro Maniakhin on 12.01.2024.
//

import SwiftUI
import SharedStuff

extension CardDetailViewModel {
    enum ViewType {
        case metacard
        case textual
    }
}

class CardDetailViewModel: ObservableObject {
    private let attachmentResourceHelper: AttachmentResourceHelperProtocol
    private var card: CDCard
    private var metaCardDetailViewModel: MetaCardDetailViewModel?
    private var textualCardDetailViewModel: TextualCardDetailViewModel?
    
    var detailViewType: ViewType {
        card.cardType == .metaCards ? .metacard : .textual
    }
    
    init(attachmentResourceHelper: AttachmentResourceHelperProtocol = AttachmentResourceHelper(),
         card: CDCard) {
        self.attachmentResourceHelper = attachmentResourceHelper
        self.card = card
    }
    
    func createMetacardViewModel() -> MetaCardDetailViewModel {
        metaCardDetailViewModel ?? {
            let viewModel = MetaCardDetailViewModel(attachmentResourceHelper: attachmentResourceHelper, card: card)
            metaCardDetailViewModel = viewModel
            return viewModel
        }()
    }
    
    func createTextualViewModel() -> TextualCardDetailViewModel {
        textualCardDetailViewModel ?? {
            let viewModel = TextualCardDetailViewModel(card: card)
            textualCardDetailViewModel = viewModel
            return viewModel
        }()
    }
    
    func prepareForAppearence() {
        if detailViewType == .metacard {
            createMetacardViewModel().fetchImage()
        }
    }

    func cancelPrepareForAppearence() {
        if detailViewType == .metacard {
            createMetacardViewModel().finalizeWorkflow()
        }
    }
}
