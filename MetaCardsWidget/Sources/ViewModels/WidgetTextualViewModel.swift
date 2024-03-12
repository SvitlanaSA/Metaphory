//
//  WidgetTextualViewModel.swift
//  MetaCardsWidgetExtension
//
//  Created by Dmytro Maniakhin on 11.01.2024.
//

import SwiftUI
import SharedStuff

protocol WidgetTextualViewModelProtocol {
    var title: String { get }
    var imageName: String { get }
}

struct WidgetTextualViewModel: WidgetTextualViewModelProtocol {
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
    
    // MARK: - Private methods
    
    private func randomImageName(for hashValue: Int) -> String {
        return "widgetBack"
    }
}

struct StubWidgetTextualViewModel: WidgetTextualViewModelProtocol {
    var title: String = ""
    var imageName = "backgroundCard"
}
