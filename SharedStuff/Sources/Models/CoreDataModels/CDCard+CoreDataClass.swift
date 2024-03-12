//
//  CDCard+CoreDataClass.swift
//  MetaCards
//
//  Created by Dmytro Maniakhin on 12.12.2023.
//
//

import UIKit
import CoreData

@objc(CDCard)
public class CDCard: NSManagedObject {

    static let entityName = CDEntityName("Card")

    public convenience init(controller: PersistenceControllerProtocol) {
        if let entity = controller.entity(for: Self.entityName) {
            self.init(entity: entity, insertInto: controller.viewContext)
        } else {
            self.init(context: controller.viewContext)
        }
    }

    public var title: String {
        get {
            cdTitle ?? ""
        }
        set {
            objectWillChange.send()
            cdTitle = newValue
        }
    }

    public var cardType: CardType {
        get {
            CardType(rawValue: cdCardType) ?? .metaCards
        }
        set {
            objectWillChange.send()
            cdCardType = newValue.rawValue
        }
    }

    public var locked: Bool {
        get {
            cdLocked
        }
        set {
            objectWillChange.send()
            cdLocked = newValue
        }
    }

    public var categories: Set<CardCategory> {
        Set(cdCategories?.compactMap {
            ($0 as? CDCardCategory)?.cardCategory
        } ?? [])
    }

    public var favoriteFolderItem: CDFolderItem? {
        cdFolderItems?
            .compactMap { $0 as? CDFolderItem }
            .first { $0.folderFavorite }
    }
}

