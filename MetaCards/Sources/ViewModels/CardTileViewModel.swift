//
//  CardTileViewModel.swift
//  MetaCards
//
//  Created by Dmytro Maniakhin on 21.12.2023.
//

import SwiftUI
import SharedStuff

struct CardTileViewModel {
    var shirtImageName: String = ""
    private var folderName: FolderName
    @State private var card: CDCard

    init(card: CDCard, folderName: FolderName) {
        let hashValue = card.title.hashValue
        self.card = card
        self.folderName = folderName
        self.shirtImageName = randomImageName(for: hashValue)
    }

    var isLocked: Bool{
        return card.locked
    }

    // MARK: - Private methods


    private func randomImageName(for hashValue: Int) -> String {
        // Make number from 1 to 12, remove later if neeeded
        //let imageNameCount = 1
        //let number = abs(hashValue % imageNameCount)

        return "imageSet/\(folderName.identifier)/" + "\(1)"

    }
}
