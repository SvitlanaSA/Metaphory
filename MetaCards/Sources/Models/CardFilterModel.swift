//
//  CardFilterModel.swift
//  MetaCards
//
//  Created by Dmytro Maniakhin on 23.01.2024.
//

import SharedStuff

extension CardFilterModel {
    static let filterUpdatedNotificationName = Notification.Name("MyNotification")
    static let filterUpdatedNotificationFolderUUIDKey = "FolderUUIDKey"
    static let filterUpdatedNotificationCardFilterKey = "CardFilterKey"
}

struct CardFilterModel {
    @UserDefaultsStorage(key: "CardFilterModel.cardFilters", defaultValue: [:]) private var storedCardFilters: [UUID : CardFilter]

    func cardFilter(folderUUID: UUID) -> CardFilter? {
        storedCardFilters[folderUUID]
    }
    
    mutating func store(_ cardFilter: CardFilter?, for folderUUID: UUID) {
        if storedCardFilters[folderUUID] != cardFilter {
            storedCardFilters[folderUUID] = cardFilter
            notifyAboutUpdates(of: cardFilter, for: folderUUID)
        }
    }
    
    // MARK: - Private methods
    
    private func notifyAboutUpdates(of cardFilter: CardFilter?, for folderUUID: UUID) {
        var userInfo: [AnyHashable : Any] = [
            Self.filterUpdatedNotificationFolderUUIDKey : folderUUID,
        ]
        userInfo[Self.filterUpdatedNotificationCardFilterKey] = cardFilter
        NotificationCenter.default.post(name: Self.filterUpdatedNotificationName,
                                        object: self,
                                        userInfo: userInfo)
    }
}
