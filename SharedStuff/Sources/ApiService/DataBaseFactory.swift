//
//  DataBaseFactory.swift
//  MetaCards
//
//  Created by Dmytro Maniakhin on 12.12.2023.
//

import UIKit

struct DataBaseFactory {
    private let entityManager: DataBaseEntityManager
    private var jsonDecoder: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return decoder
    }
    
    init(entityManager: DataBaseEntityManager) {
        self.entityManager = entityManager
    }
    
    // TODO: Rework and read initial data from JSON
    func createAndSetupDataIfNeeded() {
        guard !hasAnyData() else { return }
        
        addAllCardCategories()
        createFoldersFromJSON()
        
        entityManager.viewContext.saveContext()
    }
    
    // MARK: - Private methods
    
    // TODO: Maybe we should add more complex check later
    private func hasAnyData() -> Bool {
        let fetchRequest = CDCardCategory.fetchRequest()
        do {
            let countOfCardCategories = try entityManager.viewContext.count(for: fetchRequest)
            return countOfCardCategories > 0
        } catch { }
        return false
    }
    
    private func addAllCardCategories() {
        for category in CardCategory.allCases {
            if nil == entityManager.fetchCardCategory(for: category) {
                let cardCategory = entityManager.createCardCategory()
                cardCategory.cardCategory = category
            }
        }
    }
    
    private func createFoldersFromJSON() {
        let cardInfos = makeCardInfos()
        var folderInfos = readFoldersInfoFromJSON()
        folderInfos = setup(folderInfos: folderInfos, by: cardInfos)
        
        for (index, folderInfo) in folderInfos.enumerated() {
            let folder = createAndAddFolder(for: folderInfo)
            folder.index = index
        }
    }
    
    private func makeCardInfos() -> [String : CardInfo] {
        let cardIdentifiersInfos = readCardIdentifiersInfoFromJSON()
        var cardInfos = cardInfo(from: cardIdentifiersInfos)
        let cardCategoryInfos = readCardCategoryInfoFromJSON()
        
        cardInfos = setup(categories: cardCategoryInfos, to: cardInfos)
        
        return cardInfos
    }
    
    private func cardInfo(from cardIdentifiers: [CardIdentifiersInfo]) -> [String : CardInfo] {
        var result = [String : CardInfo]()
        for info in cardIdentifiers {
            for index in 1...info.count {
                var identifierInfo = info.identifierInfo
                identifierInfo.number = index
                identifierInfo.identifier = identifierInfo.makeIdentifier()
                
//                print("\"\(identifierInfo.identifier)\",")
//                print("\"\(identifierInfo.identifier)\" = \"\";")
                
                var cardInfo = CardInfo(identifierInfo: identifierInfo, title: identifierInfo.identifier)
                cardInfo = setupFrontImageLink(to: cardInfo, from: info)
                cardInfo = setupFrontImageThumbnailName(to: cardInfo, from: info)
                result[identifierInfo.identifier] = cardInfo
            }
        }
        return result
    }
    
    private func readCardIdentifiersInfoFromJSON() -> [CardIdentifiersInfo] {
        let assetData = NSDataAsset.proper(named: .databaseCardIdentifiersJSONAssetName)
        guard let data = assetData?.data else { return [] }
        let decoder = jsonDecoder
        var result = [CardIdentifiersInfo]()
        do {
            result = try decoder.decode([CardIdentifiersInfo].self, from: data)
        } catch {
            print("Error occures when read json file \(error)")
        }
        
        return result
    }

    private func readCardCategoryInfoFromJSON() -> [CardCategoryInfo] {
        let assetData = NSDataAsset.proper(named: .databaseCardCategoriesJSONAssetName)
        guard let data = assetData?.data else { return [] }
        let decoder = jsonDecoder
        var result = [CardCategoryInfo]()
        do {
            result = try decoder.decode([CardCategoryInfo].self, from: data)
        } catch {
            print("Error occures when read json file \(error)")
        }
        
        return result
    }
    
    private func readFoldersInfoFromJSON() -> [FolderInfo] {
        let assetData = NSDataAsset.proper(named: .databaseFoldersJSONAssetName)
        guard let data = assetData?.data else { return [] }
        let decoder = jsonDecoder
        var result = [FolderInfo]()
        do {
            result = try decoder.decode([FolderInfo].self, from: data)
        } catch {
            print("Error occures when read json file \(error)")
        }
        
        return result
    }
    
    private func setup(categories: [CardCategoryInfo], to cardInfos: [String : CardInfo]) -> [String : CardInfo] {
        var result = [String : CardInfo]()
        for (cardIdentifier, cardInfo) in cardInfos {
            guard let categoryInfo = categories.first (where: {
                $0.cardIdentifiers.contains { $0 == cardIdentifier }
            }) else { continue }
            
            var localCardInfo = cardInfo
            localCardInfo.categories.append(categoryInfo.categoryIdentifier)
            result[cardIdentifier] = localCardInfo
        }
        
        return result
    }
    
    private func setupFrontImageLink(to cardInfo: CardInfo, from cardIdentifiersInfo: CardIdentifiersInfo) -> CardInfo {
        var result = cardInfo
        if let identifierInfo = result.identifierInfo,
           !cardIdentifiersInfo.frontImageLinkBase.isEmpty {
            let number = identifierInfo.number
            result.frontImageLink = "\(cardIdentifiersInfo.frontImageLinkBase)\(number).\(cardIdentifiersInfo.frontImageLinkExtension)"
        }
        
        return result
    }

    private func setupFrontImageThumbnailName(to cardInfo: CardInfo, from cardIdentifiersInfo: CardIdentifiersInfo) -> CardInfo {
        var result = cardInfo
        if let identifierInfo = result.identifierInfo,
           !cardIdentifiersInfo.frontImageThumbnailBase.isEmpty {
            let number = identifierInfo.number
            result.frontImageThumbnailName = "\(cardIdentifiersInfo.frontImageThumbnailBase)\(number)"
        }
        
        return result
    }

    private func setup(folderInfos: [FolderInfo], by cardInfos: [String : CardInfo]) -> [FolderInfo] {
        var result = folderInfos
        for (_, cardInfo) in cardInfos {
            guard let folderInfoIndex = result.firstIndex(where: { folderInfo in
                folderInfo.cardIdentifierType == cardInfo.identifierInfo?.identifierType &&
                folderInfo.cardIdentifierAddition == cardInfo.identifierInfo?.identifierAddition
            }) else { continue }
            
            result[folderInfoIndex].cards.append(cardInfo)
        }
        
        return result
    }
    
    private func createAndAddFolder(for folderInfo: FolderInfo) -> CDFolder {
        let folder = entityManager.createFolder()
        folder.title = folderInfo.title
        folder.subtitle = folderInfo.subtitle
        folder.cdFavorite = folderInfo.favorite
        folder.fullDescription = folderInfo.fullDescription
        folder.merchantID = folderInfo.merchantID
        folder.locked = folderInfo.locked

        for cardInfo in folderInfo.cards {
            let card = createCard(for: cardInfo)

            let folderItem = entityManager.insert(
                card: card, in: folder,
                at: cardInfo.identifierInfo?.number ?? 0)
            folderItem?.cdRemovable = false
        }
        folder.updateLockStatusForCards()

        return folder
    }

    private func createCard(for cardInfo: CardInfo) -> CDCard {
        let card = entityManager.createCard()
        card.cdTitle = cardInfo.title
        card.cardType = CardType(identifier: cardInfo.cardTypeIdentifer) ?? .metaCards
        for identifier in cardInfo.categories {
            guard let categoryType = CardCategory(identifier: identifier),
                  let cardCategory = entityManager.fetchCardCategory(for: categoryType) else { continue }
            card.addToCdCategories(cardCategory)
        }
        
        card.cdFrontImageAttachments = NSSet(array: frontImageAttachments(for: cardInfo))
        
        return card
    }
    
    private func frontImageAttachments(for cardInfo: CardInfo) -> [CDFrontImageAttachment] {
        var result = [CDFrontImageAttachment]()
        if !cardInfo.frontImageLink.isEmpty {
            let link = cardInfo.frontImageLink
            let attachment: CDFrontImageAttachment
            if let fetchedAttachment = entityManager.fetchFrontImageAttachment(forRemoteValue: link) {
                attachment = fetchedAttachment
            } else {
                attachment = entityManager.createFrontImageAttachment()
                attachment.cdRemoteValue = link
                attachment.cdImageThumbnailName = cardInfo.frontImageThumbnailName
            }
            result.append(attachment)
        }
        
        return result
    }
}
