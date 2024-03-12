//
//  FolderListViewModel.swift
//  MetaCards
//
//  Created by Dmytro Maniakhin on 18.01.2024.
//

import SwiftUI
import Combine
import CoreData
import SharedStuff

class FolderListViewModel: NSObject, ObservableObject {
    @Published private(set) var folders = [CDFolder]() {
        didSet {
            updateSelectedFolder()
        }
//        get {
//            folders.sorted { left, right in
//              //  left.
//            }
//        }
    }
    @Published var selectedFolderID: CDFolder.ID? {
        didSet {
            updateSelectedFolder()
        }
    }
    @Published var showingSettingSheet = false
    @Published var showingDescriptionSheet = false
    @Published private(set) var selectedFolder: CDFolder? = nil
    private var cancellable: AnyCancellable?

    private var folderFRC: NSFetchedResultsController<CDFolder>?
    
    var viewContext: NSManagedObjectContext? {
        didSet {
            if oldValue != viewContext {
                setupFetchedResultsController()
                updatePurchaseInfo()
            }
        }
    }

    var settingButtonVisible: Bool {
        UIDevice.isIphone
    }

    var listRowMaxHeight: CGFloat {
        return 220
    }

    func showDecriptionView() {
        showingDescriptionSheet.toggle()
    }

    func showSettings() {
        showingSettingSheet.toggle()
    }
    
    // MARK: - Private methods

    private func sortFolders() {
        folders = folders.sorted { left, right in
            return (left.locked ? 1 : 0) < (right.locked ? 1 : 0)
        }
        guard var insertIndex =  folders.firstIndex (where: { $0.folderName == .affirmations}) else {return}
        guard let favoriteFolder = folders.first(where: {$0.cdFavorite}) else {return}
        insertIndex = insertIndex == folders.count ? insertIndex - 1 : insertIndex

        folders.removeAll(where: {$0.cdFavorite})
        folders.insert(favoriteFolder, at: (insertIndex))
    }

    private func setupFetchedResultsController() {
        guard let viewContext else { return }
        let fetchRequest = CDFolder.mainViewFetchRequest()
        folderFRC = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: viewContext,
            sectionNameKeyPath: nil,
            cacheName: nil)
        
        folderFRC?.delegate = self
        do {
            try folderFRC?.performFetch()
            updateFoldersFromFetchedResultsController()
        } catch {
        }
    }
    
    private func updateFoldersFromFetchedResultsController() {
        folders = folderFRC?.fetchedObjects ?? []
        sortFolders()
        selectFirstFolderIfNeeded()
    }
    
    private func selectFirstFolderIfNeeded() {
        if !UIDevice.isIphone {
            selectedFolderID = folders.first?.id
        }
    }

    private func updatePurchaseInfo() {
        guard folders.count > 0 else {return}
        var purchaseIDs = folders.compactMap { folder in
            return folder.merchantID.count > 0 ? folder.merchantID : nil
        }
        purchaseIDs = Array(Set(purchaseIDs))

        Store.instance.updateProducts(with: purchaseIDs)

        cancellable =  Store.instance.$purchasedNonConsumables.sink(receiveValue: { [weak self] purchasedItems in
            guard let folders = self?.folders else {return}
            for folder in folders {
                folder.locked = purchasedItems.first(where: { $0.id == folder.merchantID }) == nil &&  folder.folderName != .favorite
                }

            self?.sortFolders()
            folders.first?.managedObjectContext?.saveContext()
        })
    }

    private func updateSelectedFolder() {
        selectedFolder = folders.first(where: {return $0.id == selectedFolderID})
    }
}

extension FolderListViewModel: NSFetchedResultsControllerDelegate {
}
