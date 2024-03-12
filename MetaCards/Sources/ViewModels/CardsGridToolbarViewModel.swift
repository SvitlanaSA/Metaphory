//
//  CardsGridToolbarViewModel.swift
//  MetaCards
//
//  Created by Dmytro Maniakhin on 18.01.2024.
//

import UIKit
import Combine
import SharedStuff

class CardsGridToolbarViewModel: ObservableObject {
    @Published private var folder: CDFolder?
    private(set) var toolbarFilterOptionsViewModel: ToolbarFilterOptionsViewModel = { ToolbarFilterOptionsViewModel()
    }()

    var folderTitle: String {
        folder?.title ?? ""
    }
    var filterButtonVisible: Bool  {
        toolbarFilterOptionsViewModel.filterOptionsViewModel?.canPerformFiltering ?? false
    }
    var filterButtonDisabled: Bool  {
        0 == folder?.cdItems?.count ?? 0
    }
    var filterButtonFilled: Bool  {
        !(toolbarFilterOptionsViewModel.filterOptionsViewModel?.allCardsSelected ?? true)
    }
    var shuffleButtonDisabled: Bool  {
        0 == folder?.cdItems?.count ?? 0
    }
    var settingButtonVisible: Bool  {
        return !UIDevice.isIphone
    }

    var infoButtonVisible: Bool  {
        if let folder  {
            return folder.cards.first?.cardType == .metaCards && !folder.cdFavorite
        } else {
            return false
        }
    }

    func updateContent(for folder: CDFolder?) {
        self.folder = folder
        toolbarFilterOptionsViewModel.updateContent(for: folder)
    }
}
