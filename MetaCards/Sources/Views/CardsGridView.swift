//
//  CardsGridView.swift
//  MetaCards
//
//  Created by Dmytro Maniakhin on 13.12.2023.
//

import SwiftUI
import SharedStuff

let cCellItemsCount = UIDevice.isIphone ? 4.0 : 8.0

struct CardsGridView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var viewModel: CardsGridViewModel
    @State private var cardNavigationViewPresented = false
    @State private var selectedCard: CDCard? = nil
    @State private var gridViewDisabled = false

    var body: some View {
        mainView()
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    toolbarView()
                }
            }
            .navigationBarTitleDisplayMode(.inline)

            .navigationTitle(viewModel.title.localizedString)
            .navigationBarTitleDisplayMode(.inline)
    }
    
    // MARK: - Private methods
    
    private func mainView() -> some View {
        ZStack {
            backgroundContent()
            gridView()
                .disabled(gridViewDisabled)
      }
    }
    
    private func backgroundContent() -> some View {
        Color.white
    }
    
    private func gridView() -> some View {
        ScrollView {
            LazyVGrid(columns: Self.defaultGridItemLayout(), alignment: .center, spacing: 5) {
                ForEach(viewModel.cards, id: \.id) { card in
                    Button {
                        if card.locked {
                            viewModel.showDescriptionSheet.toggle()
                        } else {
                            selectedCard = card
                            cardNavigationViewPresented = true
                        }
                    } label: {
                        cardTileView(for: card)
                    }
                }
            }.padding(.all, 5)
        }
        .sheet(isPresented: $viewModel.showDescriptionSheet) {
            DeckDescriptionView(viewModel: FolderViewModel(folder: self.viewModel.folder!))
                .presentationDetents([.fraction(0.8)])
                .presentationBackground(.clear)
        }
        .onAppear {
            viewModel.invalidateStatesOnViewAppear()
        }
        .navigationDestination(
            isPresented: $cardNavigationViewPresented,
            destination: {
                cardNavigationView(for: selectedCard)
            })
    }
    
    private func toolbarView() -> some View {
        CardsGridToolbarView {
            withAnimation(.interpolatingSpring(stiffness: 50, damping: 10, initialVelocity: 0.8)) {
                viewModel.mixCards()
            }
        } modalStateChanged: { isActive in
            gridViewDisabled = isActive
        }
        .environmentObject(viewModel.cardsGridToolbarViewModel)
    }

    @ViewBuilder private func cardNavigationView(for card: CDCard?) -> some View {
        if let card,
           let viewModel = viewModel.cardNavigationViewModel(for: card) {
            CardNavigationView()
                .environmentObject(viewModel)
        }
    }

    private func cardTileView(for card: CDCard) -> some View {
        let viewModel = CardTileViewModel(card: card, folderName: viewModel.folder?.folderName ?? .quote)
        return CardTileView(viewModel: viewModel)
    }
    
    static private func gridItemLayout(for count: Int) -> [GridItem] {
        Array(repeating: GridItem(.flexible(), spacing: 5), count: count)
    }
    
    static private func defaultGridItemLayout() -> [GridItem] {
        gridItemLayout(for: Int(cCellItemsCount))
    }
}

#Preview {
    let format = "\(#keyPath(CDFolder.cdIndex)) == 1"
    let folder = PreviewAssistance.instance.fetchTestedFolder(predicate: format)
    let viewModel = CardsGridViewModel()
    viewModel.updateContent(for: folder)

    return NavigationStack {
        CardsGridView()
            .environmentObject(viewModel)
            .navigationBarTitleDisplayMode(.inline)
    }
}
