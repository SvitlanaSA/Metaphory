//
//  WidgetMetacardView.swift
//  MetaCardsWidgetExtension
//
//  Created by Dmytro Maniakhin on 11.01.2024.
//

import WidgetKit
import SwiftUI
import SharedStuff

struct WidgetMetacardView: View {
    @State var viewModel: WidgetMetacardViewModelProtocol

    var body: some View {
        mainView()
            .containerBackground(for: .widget) {
                Color.black
            }
    }
    
    // MARK: - Private methods
    
    private func mainView() -> some View {
        ZStack (alignment: .bottomTrailing) {
            VStack {
                Image(uiImage: viewModel.image)
                    .resizable()
                    .scaledToFit()
            }
            .frame(maxWidth: .infinity)

            refreshButton()
        }
    }

    private func refreshButton() -> some View {
        Button(intent: RefreshDataAppIntent()) {
            Image(systemName: "arrow.clockwise")
                .font(.system(size: 22))
                .foregroundStyle(Color("darkGreyColor"))
        }
        .tint(.clear)
    }
}

#Preview(as: .systemLarge, widget: {
    MetaCardsWidget()
}, timeline: {
    PersistenceControllerProvider.previewMode = true
    let intent = MetaCardsCategoriesIntent()
    intent.Category = IntentHandler.selection(for: .metaCards)
    let entry = WidgetEntryFactory.getRandomEntry(for: intent)
    return [entry]
})
