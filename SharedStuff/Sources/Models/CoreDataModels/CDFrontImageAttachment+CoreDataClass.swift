//
//  CDFrontImageAttachment+CoreDataClass.swift
//  MetaCards
//
//  Created by Dmytro Maniakhin on 15.12.2023.
//
//

import Foundation
import CoreData

@objc(CDFrontImageAttachment)
public class CDFrontImageAttachment: NSManagedObject {
    static let entityName = CDEntityName("FrontImageAttachment")
    
    convenience init(controller: PersistenceControllerProtocol) {
        if let entity = controller.entity(for: Self.entityName) {
            self.init(entity: entity, insertInto: controller.viewContext)
        } else {
            self.init(context: controller.viewContext)
        }
    }
}
