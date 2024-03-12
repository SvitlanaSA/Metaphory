//
//  MetaCardDetailViewModel.swift
//  MetaCards
//
//  Created by Dmytro Maniakhin on 11.01.2024.
//

import SwiftUI
import Combine
import SharedStuff
import PDFKit

class MetaCardDetailViewModel: ObservableObject {
    private let attachmentResourceHelper: AttachmentResourceHelperProtocol
    @ObservedObject private var card: CDCard
    private var cancellable: Cancellable?
    @Published var image: UIImage?
    
    var title: String {
        card.title.localizedString
    }
    
    var hasAdditionalValue: Bool {
        !title.isEmpty
    }

    init(attachmentResourceHelper: AttachmentResourceHelperProtocol = AttachmentResourceHelper(),
         card: CDCard) {
        self.attachmentResourceHelper = attachmentResourceHelper
        self.card = card
        
        setupImageWithStoredValue()
    }

    func createPDFDocument(image: UIImage) -> PDFDocument {
        let document = PDFDocument()

        guard let cgImage = image.cgImage else { return document }

        let image = UIImage(cgImage: cgImage, scale: image.scale, orientation: .downMirrored)

        guard let imagePDF = PDFPage(image: image) else { return document }

        document.insert(imagePDF, at: document.pageCount)

        return document
    }

    func fetchImage() {
        guard let attachment = card.cdFrontImageAttachments?.anyObject() as? CDFrontImageAttachment else { return }
        cancellable = attachmentResourceHelper.fetchResource(for: attachment) { [weak self] result in
            guard let self else { return }
            self.cancellable = nil
            self.card.managedObjectContext?.saveContext()

            switch result {
            case .success(let image):
                self.image = image
            case .failure(let error):
                debugPrint(error)
            }
        }
    }
    
    func finalizeWorkflow() {
        cancellable?.cancel()
        cancellable = nil
        card.managedObjectContext?.saveContext()
    }
    
    // MARK: - Private methods
    
    private func setupImageWithStoredValue() {
        guard let attachment = card.cdFrontImageAttachments?.anyObject() as? CDFrontImageAttachment else { return }
        image = attachmentResourceHelper.storedResource(for: attachment)
    }
}
