//
//  PersistenceControllerProtocol.swift
//  MetaCards
//
//  Created by Dmytro Maniakhin on 13.12.2023.
//

import CoreData

public protocol PersistenceControllerProtocol {
    var persistentContainer: NSPersistentContainer { get }
    var viewContext: NSManagedObjectContext { get }
    var entityManager: DataBaseEntityManager { get }
    
    func entity(for entityName: CDEntityName) -> NSEntityDescription?
}

public extension PersistenceControllerProtocol {
    var viewContext: NSManagedObjectContext {
        persistentContainer.viewContext
    }
    
    var entityManager: DataBaseEntityManager {
        DataBaseEntityManager(persistenceController: self)
    }
    
    func entity(for entityName: CDEntityName) -> NSEntityDescription? {
        NSEntityDescription.entity(forEntityName: entityName.rawValue, in: viewContext)
    }
}
