//
//  CardDetailView.swift
//  MetaCards
//
//  Created by Dmytro Maniakhin on 12.01.2024.
//

import SwiftUI

struct CardDetailView: View {
    @EnvironmentObject private var viewModel: CardDetailViewModel
    @Binding var isFullScreen: Bool
    
    var body: some View {
        mainView()
    }
    
    // MARK: - Private methods
    
    @ViewBuilder private func mainView() -> some View {
        switch viewModel.detailViewType {
        case .metacard:
            metacardView()
        case .textual:
            textualView()
        }
    }
    
    private func metacardView() -> some View {
        let viewModel = viewModel.createMetacardViewModel()
        return MetaCardDetailView()
            .environmentObject(viewModel)
    }
    
    private func textualView() -> some View {
        let viewModel = viewModel.createTextualViewModel()
        return TextualCardDetailView(fullScreen: $isFullScreen)
            .environmentObject(viewModel)
    }
}
