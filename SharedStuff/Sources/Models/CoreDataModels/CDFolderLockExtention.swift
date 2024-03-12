//
//  CDFolderLockExtention.swift
//  MetaCards
//
//  Created by Svetlana Stegnienko on 29.01.2024.
//

private var freeCategories: [FolderName: [CardCategory]] = [.affirmations: [.selfLove], .quote : [.lifeAndWisdom, .positivityAndMindfulness]]

private var unlockedMetaphoricalCardPercent = 0.2

  extension CDFolder {
    func updateLockStatusForCards() {

        switch folderName {
            case .affirmations, .quote:
                let freeCategories: [CardCategory] = freeCategories[folderName] ?? []

                for card in cards {
                    let categories = card.categories
                    card.locked = categories.first {freeCategories.contains($0)} == nil && self.cdLocked
                }
            default:
                let unlockedCardCount = Int(Double(cards.count) * unlockedMetaphoricalCardPercent)
                for (index, card) in cards.enumerated() {
                    card.locked = index > unlockedCardCount && self.cdLocked
                }
        }
    }

}
