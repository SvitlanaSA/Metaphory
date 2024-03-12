//
//  ManagedObjectContextExtension.swift
//  MetaCards
//
//  Created by Dmytro Maniakhin on 13.12.2023.
//

import CoreData

public extension NSManagedObjectContext {
    func saveContext() {
        guard hasChanges else { return }

        do {
            try save()
        } catch let error as NSError {
            print("Error: \(error), \(error.userInfo)")
        }
    }
}
