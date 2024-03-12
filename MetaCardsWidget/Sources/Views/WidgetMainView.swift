//
//  WidgetMainView.swift
//  MetaCardsWidgetExtension
//
//  Created by Dmytro Maniakhin on 10.01.2024.
//

import WidgetKit
import Intents
import SwiftUI
import SharedStuff

struct WidgetMainView : View {
    @State var viewModel: WidgetMainViewModelProtocol
    
    var body: some View {
        switch viewModel.viewType {
        case .metacard:
            metacardView()
        case .textual:
            textualView()
        case .placeholder:
            placeholderView()
        }
    }
    
    // MARK: - Private methods
    
    private func metacardView() -> some View {
        let viewModel = viewModel.createMetacardViewModel()
        return WidgetMetacardView(viewModel: viewModel)
    }
    
    private func textualView() -> some View {
        let viewModel = viewModel.createTextualViewModel()
        return WidgetTextualView(viewModel: viewModel)
    }
    
    private func placeholderView() -> some View {
        Image("demand")
            .resizable()
            .scaledToFill()
            .containerBackground(for: .widget) {
            }
    }
}

#Preview("Random card view", as: .systemLarge, widget: {
    MetaCardsWidget()
}, timeline: {
    PersistenceControllerProvider.previewMode = true
    let intent = MetaCardsCategoriesIntent()
    let entry = WidgetEntryFactory.getRandomEntry(for: intent)
    return [entry]
})

#Preview("Snapshot view", as: .systemLarge, widget: {
    MetaCardsWidget()
}, timeline: {
    PersistenceControllerProvider.previewMode = true
    let intent = MetaCardsCategoriesIntent()
    let entry = WidgetEntryFactory.getSnapshotEntry(for: intent)
    return [entry]
})

#Preview("Placeholder view", as: .systemSmall, widget: {
    MetaCardsWidget()
}, timeline: {
    WidgetEntryFactory.getPlaceholderEntry()
})
