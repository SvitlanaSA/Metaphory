//
//  CDFolder+CoreDataProperties.swift
//  SharedStuff
//
//  Created by Svetlana Stegnienko on 29.01.2024.
//
//

import Foundation
import CoreData


extension CDFolder {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDFolder> {
        return NSFetchRequest<CDFolder>(entityName: "Folder")
    }

    @NSManaged public var cdFavorite: Bool
    @NSManaged public var cdFullDescription: String?
    @NSManaged public var cdIndex: Int64
    @NSManaged public var cdMerchantID: String?
    @NSManaged public var cdSubTitle: String?
    @NSManaged public var cdTitle: String?
    @NSManaged public var cdUUID: UUID?
    @NSManaged public var cdLocked: Bool
    @NSManaged public var cdItems: NSSet?

}

// MARK: Generated accessors for cdItems
extension CDFolder {

    @objc(addCdItemsObject:)
    @NSManaged public func addToCdItems(_ value: CDFolderItem)

    @objc(removeCdItemsObject:)
    @NSManaged public func removeFromCdItems(_ value: CDFolderItem)

    @objc(addCdItems:)
    @NSManaged public func addToCdItems(_ values: NSSet)

    @objc(removeCdItems:)
    @NSManaged public func removeFromCdItems(_ values: NSSet)

}

extension CDFolder : Identifiable {

}
