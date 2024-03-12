//
//  CardTileView.swift
//  MetaCards
//
//  Created by Dmytro Maniakhin on 14.12.2023.
//

import SwiftUI
import CoreData
import SharedStuff

struct CardTileView: View {
    @State private var viewModel: CardTileViewModel

    init(viewModel: CardTileViewModel) {
        _viewModel = State(wrappedValue: viewModel)
    }
    
    var body: some View {
        imageView()
    }
    
    // MARK: - Private methods
    
    private func imageView() -> some View {
        ZStack(alignment: .bottomTrailing) {
            Image(viewModel.shirtImageName)
                .resizable()
                .scaledToFit()
                .cornerRadius(2.0)

            if viewModel.isLocked {
                Image(systemName: "lock")
                    .frame(width: 11, alignment: .trailing)
                    .padding([.trailing,], 5)
                    .padding(.bottom, 5)
                    .foregroundStyle(Color.white.opacity(0.95))
                    .padding(.top, 6)
            }
        }
    }
}

#Preview {
    let format = "\(#keyPath(CDCard.cdCardType)) == \"\(CardType.metaCards.rawValue)\""
    let card = PreviewAssistance.instance.fetchTestedCard(predicate: format)
    let viewModel = CardTileViewModel(card:card, folderName: .affirmations)

    return NavigationStack {
        CardTileView(viewModel: viewModel)
    }
}
