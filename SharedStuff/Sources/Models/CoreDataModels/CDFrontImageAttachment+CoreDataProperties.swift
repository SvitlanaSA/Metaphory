//
//  CDFrontImageAttachment+CoreDataProperties.swift
//  SharedStuff
//
//  Created by Dmytro Maniakhin on 29.01.2024.
//
//

import Foundation
import CoreData


extension CDFrontImageAttachment {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDFrontImageAttachment> {
        return NSFetchRequest<CDFrontImageAttachment>(entityName: "FrontImageAttachment")
    }

    @NSManaged public var cdImageData: Data?
    @NSManaged public var cdImageName: String?
    @NSManaged public var cdRemoteValue: String?
    @NSManaged public var cdImageThumbnailName: String?
    @NSManaged public var cdCards: NSSet?

}

// MARK: Generated accessors for cdCards
extension CDFrontImageAttachment {

    @objc(addCdCardsObject:)
    @NSManaged public func addToCdCards(_ value: CDCard)

    @objc(removeCdCardsObject:)
    @NSManaged public func removeFromCdCards(_ value: CDCard)

    @objc(addCdCards:)
    @NSManaged public func addToCdCards(_ values: NSSet)

    @objc(removeCdCards:)
    @NSManaged public func removeFromCdCards(_ values: NSSet)

}

extension CDFrontImageAttachment : Identifiable {

}
