//
//  MainViewModel.swift
//  MetaCards
//
//  Created by Dmytro Maniakhin on 18.01.2024.
//

import SwiftUI
import Combine
import SharedStuff

extension MainViewModel {
    enum DetailViewType {
        case gridView
        case placeholder
    }
}

class MainViewModel: ObservableObject {
    @Published private(set) var detailViewType: DetailViewType = .placeholder
    private(set) var folderListViewModel: FolderListViewModel
    private(set) var cardsGridViewModel: CardsGridViewModel

    private var cancellable: AnyCancellable?
    private var selectedFolder: CDFolder? {
        didSet {
            if oldValue != selectedFolder {
                updateContentData(for: selectedFolder)
            }
        }
    }

    init(folderListViewModel: FolderListViewModel = FolderListViewModel(),
         cardsGridViewModel: CardsGridViewModel = CardsGridViewModel()) {
        self.folderListViewModel = folderListViewModel
        self.cardsGridViewModel = cardsGridViewModel

        subscribeUpdates(from: folderListViewModel)
    }
    
    // MARK: - Private methods
    
    private func subscribeUpdates(from viewModel: FolderListViewModel) {
        cancellable = folderListViewModel.$selectedFolder.sink(receiveValue: { [weak self] selectedFolder in
            self?.selectedFolder = selectedFolder
        })
    }
    
    func updateContentData(for selectedFolder: CDFolder?) {
        detailViewType = nil != selectedFolder ? .gridView : .placeholder

        cardsGridViewModel.updateContent(for: selectedFolder)
    }
}
