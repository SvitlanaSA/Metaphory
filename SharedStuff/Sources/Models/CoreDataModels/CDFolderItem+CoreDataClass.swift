//
//  CDFolderItem+CoreDataClass.swift
//  MetaCards
//
//  Created by Dmytro Maniakhin on 15.01.2024.
//
//

import Foundation
import CoreData

@objc(CDFolderItem)
public class CDFolderItem: NSManagedObject {
    static let entityName = CDEntityName("FolderItem")
    
    convenience init(controller: PersistenceControllerProtocol) {
        if let entity = controller.entity(for: Self.entityName) {
            self.init(entity: entity, insertInto: controller.viewContext)
        } else {
            self.init(context: controller.viewContext)
        }
    }
    
    var folderIndex: Int {
        get {
            Int(cdFolderIndex)
        }
        set {
            objectWillChange.send()
            cdFolderIndex = Int64(newValue)
        }
    }
    
    var folderFavorite: Bool {
        cdFolder?.cdFavorite ?? false
    }
}
