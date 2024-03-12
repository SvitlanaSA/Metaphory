//
//  CardNavigationView.swift
//  MetaCards
//
//  Created by Dmytro Maniakhin on 20.12.2023.
//

import SwiftUI
import SharedStuff

struct CardNavigationView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var viewModel: CardNavigationViewModel
    @State private var fullScreenPresented: Bool = false
    @State private var infoSheetPresented: Bool = false

    var body: some View {
        mainView()
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {

                    infoButton()
                    FavoriteButton(filled: viewModel.favoriteButtonFilled) {
                        viewModel.toogleFavoriteState()
                    }
                    .foregroundStyle(Color.favoriteColor)
                }
            }
            .toolbar(fullScreenPresented ? .hidden : .automatic, for: .navigationBar)
    }
    
    // MARK: - Private methods

    @ViewBuilder private func infoButton() -> some View {
        if viewModel.infoButtonVisible {
            InfoButton {
                infoSheetPresented.toggle()
            }
            .sheet(isPresented: $infoSheetPresented) {
                TechniquesSheet()
            }
        }
    }

    private func mainView() -> some View {
        contentView()
            .ignoresSafeArea()
    }
    
    @ViewBuilder func contentView() -> some View {
        ZStack {
            backgroundContent()
                cardDetailView() {
                    fullScreenPresented.toggle()
                }
            navigationButtonsView()
        }
    }
    
    private func backgroundContent() -> some View {
        fullScreenPresented ? Color(.black).ignoresSafeArea() : Color.white.ignoresSafeArea()
    }
    
    private func cardDetailView(contentTapAction: @escaping () -> ()) -> some View {
        let cardsEnumerated = viewModel.cards.enumerated().map { $0 }
        return TabView(selection: $viewModel.selectedCardIndex) {
            ForEach(cardsEnumerated, id: \.element) { index, item in
                cardDetailView(for: item).tag(index)
            }
        }
        .tabViewStyle(.page(indexDisplayMode: .never))
    }

    private func cardDetailView(for card: CDCard) -> some View {
        let viewModel = viewModel.dequeCardDetailViewModel(for: card)
        return CardDetailView(isFullScreen: $fullScreenPresented)
            .environmentObject(viewModel)
    }

    private func navigationButtonsView() -> some View {
        NavigationButtonsView(
            previousButtonDisabled: viewModel.isPreviousButtonDisabled,
            nextButtonDisabled: viewModel.isNextButtonDisabled
        )
    }
}

#Preview("Афірмації") {
    let persistenceController = PreviewAssistance.instance.persistenceController
    let format = "\(#keyPath(CDFolder.cdIndex)) == 1"
    let folder = PreviewAssistance.instance.fetchTestedFolder(predicate: format)
    let cards = folder.cards
    let cardIndex = (0..<cards.count).randomElement()!
    let viewModel = CardNavigationViewModel(entityManager: persistenceController.entityManager, index: cardIndex, in: cards)
    
    return NavigationStack {
        CardNavigationView()
            .environmentObject(viewModel)
    }
}

#Preview("Метакарти") {
    let persistenceController = PreviewAssistance.instance.persistenceController
    let format = "\(#keyPath(CDFolder.cdIndex)) == 4"
    let folder = PreviewAssistance.instance.fetchTestedFolder(predicate: format)
    let cards = folder.cards
    let cardIndex = (0..<cards.count).randomElement()!
    let viewModel = CardNavigationViewModel(entityManager: persistenceController.entityManager, index: cardIndex, in: cards)
    
    return NavigationStack {
        CardNavigationView()
            .environmentObject(viewModel)
    }
}
