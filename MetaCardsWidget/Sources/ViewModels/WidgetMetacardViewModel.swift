//
//  WidgetMetacardViewModel.swift
//  MetaCardsWidgetExtension
//
//  Created by Dmytro Maniakhin on 11.01.2024.
//

import UIKit
import SwiftUI
import Combine
import SharedStuff

protocol WidgetMetacardViewModelProtocol {
    var title: String { get }
    var image: UIImage { get }
}

struct WidgetMetacardViewModel {
    private let attachmentResourceHelper: AttachmentResourceHelperProtocol
    @ObservedObject private var card: CDCard
    
    init(attachmentResourceHelper: AttachmentResourceHelperProtocol = AttachmentResourceHelper(),
         card: CDCard) {
        self.attachmentResourceHelper = attachmentResourceHelper
        self.card = card
    }
}

extension WidgetMetacardViewModel: WidgetMetacardViewModelProtocol {
    var title: String {
        card.title
    }
    
    var image: UIImage {
        guard let attachment = card.cdFrontImageAttachments?.anyObject() as? CDFrontImageAttachment,
              let result = attachmentResourceHelper.storedResource(for: attachment) else {
            return UIImage.proper(named: "backgroundCard")!
        }
        return result.properScaled()
    }
}

struct StubWidgetMetacardViewModel: WidgetMetacardViewModelProtocol {
    var title = ""
    var image = UIImage.proper(named: "backgroundCard")!
}
