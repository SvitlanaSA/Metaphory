//
//  CDCardCategory+CoreDataProperties.swift
//  MetaCards
//
//  Created by Dmytro Maniakhin on 14.12.2023.
//
//

import Foundation
import CoreData


extension CDCardCategory {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDCardCategory> {
        return NSFetchRequest<CDCardCategory>(entityName: "CardCategory")
    }

    @NSManaged public var cdCategory: Int32
    @NSManaged public var cdCards: NSSet?

}

// MARK: Generated accessors for cdCards
extension CDCardCategory {

    @objc(addCdCardsObject:)
    @NSManaged public func addToCdCards(_ value: CDCard)

    @objc(removeCdCardsObject:)
    @NSManaged public func removeFromCdCards(_ value: CDCard)

    @objc(addCdCards:)
    @NSManaged public func addToCdCards(_ values: NSSet)

    @objc(removeCdCards:)
    @NSManaged public func removeFromCdCards(_ values: NSSet)

}

extension CDCardCategory : Identifiable {

}
