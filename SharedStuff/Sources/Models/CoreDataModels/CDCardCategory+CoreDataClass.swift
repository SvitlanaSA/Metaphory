//
//  CDCardCategory+CoreDataClass.swift
//  MetaCards
//
//  Created by Dmytro Maniakhin on 12.12.2023.
//
//

import CoreData

@objc(CDCardCategory)
public class CDCardCategory: NSManagedObject {
    static let entityName = CDEntityName("CardCategory")
    
    convenience init(controller: PersistenceControllerProtocol) {
        if let entity = controller.entity(for: Self.entityName) {
            self.init(entity: entity, insertInto: controller.viewContext)
        } else {
            self.init(context: controller.viewContext)
        }
    }
    
    public var cardCategory: CardCategory {
        get {
            CardCategory(rawValue: cdCategory) ?? .healthAndWellBeing
        }
        set {
            objectWillChange.send()
            cdCategory = newValue.rawValue
        }
    }
}
