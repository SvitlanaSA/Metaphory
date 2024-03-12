//
//  CDFolder+CoreDataClass.swift
//  MetaCards
//
//  Created by Dmytro Maniakhin on 15.01.2024.
//
//

import Foundation
import CoreData

@objc(CDFolder)
public class CDFolder: NSManagedObject {
    static let entityName = CDEntityName("Folder")
    
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

    public var folderName: FolderName {
        FolderName(identifier: title) ?? .quote
    }

    public var subtitle: String {
        get {
            cdSubTitle ?? ""
        }
        set {
            objectWillChange.send()
            cdSubTitle = newValue
        }
    }

    public var fullDescription: String {
        get {
            cdFullDescription ?? ""
        }
        set {
            objectWillChange.send()
            cdFullDescription = newValue
        }
    }

    public var merchantID: String {
        get {
            cdMerchantID ?? ""
        }
        set {
            objectWillChange.send()
            cdMerchantID = newValue
        }
    }

    public var locked: Bool {
        get {
            cdLocked
        }
        set {
            if cdLocked != newValue {
                objectWillChange.send()
                cdLocked = newValue
                self.updateLockStatusForCards()
            }
        }
    }

    public var index: Int {
        get {
            Int(cdIndex)
        }
        set {
            objectWillChange.send()
            cdIndex = Int64(newValue)
        }
    }

    public var uuid: UUID {
        get {
            cdUUID ?? UUID()
        }
        set {
            objectWillChange.send()
            cdUUID = newValue
        }
    }
    
    public var cards: [CDCard] {
        return (cdItems?.compactMap({ $0 as? CDFolderItem }) ?? [])
            .sorted { $0.folderIndex < $1.folderIndex }
            .compactMap { $0.cdCard }
    }
    
    public func shuffleItems() {
        guard var folderItems = cdItems?.compactMap({ $0 as? CDFolderItem }) else { return }
        folderItems = folderItems.filter{$0.cdCard?.locked == false}
        let shuffledIndexes = folderItems.shuffled().map { $0.folderIndex }
        for (index, folderItem) in folderItems.enumerated() {
            folderItem.folderIndex = shuffledIndexes[index]
        }
    }
}

public extension CDFolder {
    static func mainViewFetchRequest() -> NSFetchRequest<CDFolder> {
        let result = CDFolder.fetchRequest()
        result.sortDescriptors = [
            NSSortDescriptor(keyPath: \CDFolder.cdIndex, ascending: true),
        ]
        return result
    }
}



