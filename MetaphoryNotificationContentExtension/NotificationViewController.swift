//
//  NotificationViewController.swift
//  MetaphoryNotificationContentExtension
//
//  Created by Dmytro Maniakhin on 30.01.2024.
//

import UIKit
import UserNotifications
import UserNotificationsUI
import SharedStuff

class NotificationViewController: UIViewController, UNNotificationContentExtension {
    private let attachmentResourceHelper = AttachmentResourceHelper()

    @IBOutlet weak var rootStackView: UIStackView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var label: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.isHidden = true
        label.isHidden = true

        setupDatabase()
    }
    
    func didReceive(_ notification: UNNotification) {
        if let card = card(for: notification) {
            if card.cardType == .metaCards {
                imageView.isHidden = false
                imageView.image = image(for: card)
            } else {
                label.isHidden = false
                if let title = notification.request.content.userInfo[UNNotificationRequestContentTitleString] as? String {
                    label.text = title
                } else {
                    label.text = card.title.localizedString
                }

                rootStackView.isLayoutMarginsRelativeArrangement = true
                rootStackView.layoutMargins = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
            }
        }
    }

    // MARK: - Private methods
    
    private func setupDatabase() {
        _ = PersistenceControllerProvider.controller
    }

    private func card(for notification: UNNotification) -> CDCard? {
        guard let identifier = notification.request.content.userInfo[UNNotificationRequestContentIdentifierString] as? String else { return nil }
        let entityManager = PersistenceControllerProvider.controller.entityManager
        let format = "\(#keyPath(CDCard.cdTitle)) == \"\(identifier)\""
        return entityManager.fetchEntities(predicate: format).first
    }
    
    func image(for card: CDCard) -> UIImage? {
        guard let attachment = card.cdFrontImageAttachments?.anyObject() as? CDFrontImageAttachment else { return nil }
        return attachmentResourceHelper.storedResource(for: attachment)
    }
}
