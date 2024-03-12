//
//  DataBaseEntityManager.swift
//  MetaCards
//
//  Created by Dmytro Maniakhin on 16.01.2024.
//

import CoreData

public struct DataBaseEntityManager {
    let persistenceController: PersistenceControllerProtocol
    public var viewContext: NSManagedObjectContext {
        persistenceController.viewContext
    }
    
    init(persistenceController: PersistenceControllerProtocol) {
        self.persistenceController = persistenceController
    }
}

// MARK: - Creation methods
extension DataBaseEntityManager {
    func createFolder() -> CDFolder {
        let result = CDFolder(controller: persistenceController)
        result.uuid = UUID()
        return result
    }
    
    func createFolderItem() -> CDFolderItem {
        CDFolderItem(controller: persistenceController)
    }
    
    func createCardCategory() -> CDCardCategory {
        CDCardCategory(controller: persistenceController)
    }
    
    func createCard() -> CDCard {
        CDCard(controller: persistenceController)
    }
    
    func createFrontImageAttachment() -> CDFrontImageAttachment {
        CDFrontImageAttachment(controller: persistenceController)
    }
}

// MARK: - Fetch methods
public extension DataBaseEntityManager {
    func fetchEntities<Entity>(predicate format: String = "", sortDescriptors: [NSSortDescriptor] = []) -> [Entity]
    where Entity: NSManagedObject {
        let request = Entity.fetchRequest()
        if !format.isEmpty {
            request.predicate = NSPredicate(format: format)
        }
        request.sortDescriptors = sortDescriptors
        
        var result = [Entity]()
        do {
            result = try viewContext.fetch(request) as? [Entity] ?? []
        } catch { }
        
        return result
    }
    
    func fetchFolderFavorite() -> CDFolder? {
        let format = "\(#keyPath(CDFolder.cdFavorite)) == YES"
        return fetchEntities(predicate: format).first
    }
    
    func fetchCardCategory(for category: CardCategory) -> CDCardCategory? {
        let format = "\(#keyPath(CDCardCategory.cdCategory)) == \(category.rawValue)"
        return fetchEntities(predicate: format).first
    }
    
    func fetchFrontImageAttachment(forRemoteValue remoteValue: String) -> CDFrontImageAttachment? {
        let format = "\(#keyPath(CDFrontImageAttachment.cdRemoteValue)) == \"\(remoteValue)\""
        return fetchEntities(predicate: format).first
    }
}

// MARK: - CDFolder methods

public extension DataBaseEntityManager {
    func insert(card: CDCard, in folder: CDFolder, at index: Int) -> CDFolderItem? {
        let folderItem = createFolderItem()
        folderItem.cdCard = card
        folderItem.folderIndex = index
        folder.addToCdItems(folderItem)

        return folderItem
    }
    
    func remove(card: CDCard, from folder: CDFolder, forceDeletion: Bool = false) -> Bool {
        var result = false
        if let item = card.cdFolderItems?
            .compactMap( { $0 as? CDFolderItem } )
            .first(where: { $0.cdFolder == folder } ) {
            if item.cdRemovable || forceDeletion {
                item.cdFolder = nil
                item.cdCard = nil
                viewContext.delete(item)
                result = true
            }
        }
        
        return result
    }
}
