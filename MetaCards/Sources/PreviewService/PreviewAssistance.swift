//
//  PreviewAssistance.swift
//  MetaCards
//
//  Created by Svetlana Stegnienko on 24.01.2024.
//
import SharedStuff
import CoreData

struct PreviewAssistance {
    static let instance = PreviewAssistance()
    private(set) var persistenceController: PersistenceController = PersistenceController.previewInstance

    func fetchTestedFolder(predicate format: String = "") -> CDFolder {
        fetchTestedEntities(predicate: format).first ?? createEmptyFolder()
    }
    
    func fetchTestedCard(predicate format: String = "") -> CDCard {
        fetchTestedEntities(predicate: format).first ?? createEmptyCard()
    }
    
    func fetchTestedEntities<Entity>(predicate format: String = "", sortDescriptors: [NSSortDescriptor] = []) -> [Entity]
    where Entity: NSManagedObject {
        return persistenceController.entityManager.fetchEntities(predicate: format, sortDescriptors: sortDescriptors)
    }
    
    func fetchTestedFavoriteFolderAndAddAllCards() -> CDFolder {
        let format = "\(#keyPath(CDFolder.cdFavorite)) == YES"
        let folder = fetchTestedFolder(predicate: format)
        let cards: [CDCard] = fetchTestedEntities()
        for card in cards {
            let folderItem = persistenceController.entityManager.insert(card: card, in: folder, at: folder.cdItems?.count ?? 0)
            folderItem?.cdRemovable = true
        }
        
        return folder
    }

    // MARK: - Private methods
    
    private init() {}
    
    private func createEmptyCard() -> CDCard {
        let result = CDCard(controller: persistenceController)
        result.title = "Empty card"
        return result
    }
    
    private func createEmptyFolder() -> CDFolder {
        let result = CDFolder(controller: persistenceController)
        result.title = "cFolderTitleQuote"
        return result
    }
}
