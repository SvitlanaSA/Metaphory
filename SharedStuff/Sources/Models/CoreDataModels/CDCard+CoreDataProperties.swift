//
//  CDCard+CoreDataProperties.swift
//  SharedStuff
//
//  Created by Svetlana Stegnienko on 29.01.2024.
//
//

import Foundation
import CoreData


extension CDCard {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDCard> {
        return NSFetchRequest<CDCard>(entityName: "Card")
    }

    @NSManaged public var cdCardType: Int32
    @NSManaged public var cdTitle: String?
    @NSManaged public var cdLocked: Bool
    @NSManaged public var cdCategories: NSSet?
    @NSManaged public var cdFolderItems: NSSet?
    @NSManaged public var cdFrontImageAttachments: NSSet?

}

// MARK: Generated accessors for cdCategories
extension CDCard {

    @objc(addCdCategoriesObject:)
    @NSManaged public func addToCdCategories(_ value: CDCardCategory)

    @objc(removeCdCategoriesObject:)
    @NSManaged public func removeFromCdCategories(_ value: CDCardCategory)

    @objc(addCdCategories:)
    @NSManaged public func addToCdCategories(_ values: NSSet)

    @objc(removeCdCategories:)
    @NSManaged public func removeFromCdCategories(_ values: NSSet)

}

// MARK: Generated accessors for cdFolderItems
extension CDCard {

    @objc(addCdFolderItemsObject:)
    @NSManaged public func addToCdFolderItems(_ value: CDFolderItem)

    @objc(removeCdFolderItemsObject:)
    @NSManaged public func removeFromCdFolderItems(_ value: CDFolderItem)

    @objc(addCdFolderItems:)
    @NSManaged public func addToCdFolderItems(_ values: NSSet)

    @objc(removeCdFolderItems:)
    @NSManaged public func removeFromCdFolderItems(_ values: NSSet)

}

// MARK: Generated accessors for cdFrontImageAttachments
extension CDCard {

    @objc(addCdFrontImageAttachmentsObject:)
    @NSManaged public func addToCdFrontImageAttachments(_ value: CDFrontImageAttachment)

    @objc(removeCdFrontImageAttachmentsObject:)
    @NSManaged public func removeFromCdFrontImageAttachments(_ value: CDFrontImageAttachment)

    @objc(addCdFrontImageAttachments:)
    @NSManaged public func addToCdFrontImageAttachments(_ values: NSSet)

    @objc(removeCdFrontImageAttachments:)
    @NSManaged public func removeFromCdFrontImageAttachments(_ values: NSSet)

}

extension CDCard : Identifiable {

}
