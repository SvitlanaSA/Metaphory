//
//  TextualCardDetailViewModel.swift
//  MetaCards
//
//  Created by Dmytro Maniakhin on 12.01.2024.
//

import SwiftUI
import SharedStuff

class TextualCardDetailViewModel: ObservableObject {
    @ObservedObject private var card: CDCard
    var title: String {
        card.title
    }
    
    var imageName: String = ""

    init(card: CDCard) {
        self.card = card
        
        let hashValue = title.hashValue
        imageName = randomImageName(for: hashValue)
    }

    func backgroundColor() -> Color {
        return Color.affirmationBackgroundColor
    }

    func fontName() -> String {
        return "STHeitiSC-Light"
    }

    // MARK: - Private methods
    
    private func randomImageName(for hashValue: Int) -> String {
        return "settingImage"
    }
}
