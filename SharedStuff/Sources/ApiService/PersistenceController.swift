//
//  PersistenceController.swift
//  MetaCards
//
//  Created by Dmytro Maniakhin on 12.12.2023.
//

import CoreData

public struct PersistenceController: PersistenceControllerProtocol {
    public static let instance = {
        let controller = PersistenceController(inMemory: false)
        controller.createAndSetupDataIfNeeded()
        return controller
    }()
    public static let previewInstance = {
        let controller = PersistenceController()
        controller.createAndSetupDataIfNeeded()
        return controller
    }()

    public let persistentContainer: NSPersistentContainer
    private let persistentContainerName = "CoreDataModel"

    init() {
        self.init(inMemory: true)
    }
    
    // MARK: - Private methods
    
    private init(inMemory: Bool) {
        let container: NSPersistentContainer
        if let bundle = Bundle.sharedStuffBundle,
           let modelURL = bundle.url(forResource: persistentContainerName, withExtension: "momd"),
           let managedObjectModel = NSManagedObjectModel(contentsOf: modelURL) {
            container = NSPersistentContainer(name: persistentContainerName, managedObjectModel: managedObjectModel)
        } else {
            container = NSPersistentContainer(name: persistentContainerName)
        }
        
        persistentContainer = container
        configurePersistentContainer(container, inMemory: inMemory)
    }
    
    private func configurePersistentContainer(_ container: NSPersistentContainer, inMemory: Bool) {
        if let databaseURL = URL.storeURL(for: appGroupIdentifierString, databaseName: persistentContainerName) {
            let storeDescription = NSPersistentStoreDescription(url: databaseURL)
            container.persistentStoreDescriptions = [storeDescription]
        }
        
        if inMemory {
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores { persistentStoreDescription, error in
            if let error = error {
                fatalError("Unable to load persistent stores: \(error)")
            }
            if !inMemory {
                debugPrint("DataBase url = \(persistentStoreDescription.url?.absoluteString.removingPercentEncoding ?? "")")
            }
        }
    }
    
    private func createAndSetupDataIfNeeded() {
        DataBaseFactory(entityManager: entityManager).createAndSetupDataIfNeeded()
    }
}
