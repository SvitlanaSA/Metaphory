//
//  CDFolderItem+CoreDataProperties.swift
//  MetaCards
//
//  Created by Dmytro Maniakhin on 15.01.2024.
//
//

import Foundation
import CoreData


extension CDFolderItem {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDFolderItem> {
        return NSFetchRequest<CDFolderItem>(entityName: "FolderItem")
    }

    @NSManaged public var cdFolderIndex: Int64
    @NSManaged public var cdRemovable: Bool
    @NSManaged public var cdFolder: CDFolder?
    @NSManaged public var cdCard: CDCard?

}

extension CDFolderItem : Identifiable {

}
