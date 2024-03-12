//
//  MainView.swift
//  MetaCards
//
//  Created by Svetlana Stegnienko on 18.12.2023.
//

import SwiftUI
import SharedStuff

let cSplitContentWidth = 320.0

struct MainView: View {
    @EnvironmentObject private var viewModel: MainViewModel

    var body: some View {
        NavigationSplitView {
            contentSplitView()
        } detail: {
            detailSplitView()
        }
        .accentColor(Color.foregroundColor)
        .navigationSplitViewStyle(.prominentDetail)
        .navigationBarTitleDisplayMode(.inline)
    }

    // MARK: - Private methods

    private func contentSplitView() -> some View {
        FolderListView()
            .environmentObject(viewModel.folderListViewModel)
    }
    
    @ViewBuilder private func detailSplitView() -> some View {
        switch viewModel.detailViewType {
        case .gridView:
            NavigationStack {
                CardsGridView()
                    .environmentObject(viewModel.cardsGridViewModel)
            }
        case .placeholder:
            Text("Choose content")
        }
    }
}

#Preview {
    let mainListViewModel = MainViewModel()
    return MainView()
        .environment(\.managedObjectContext, PersistenceController.previewInstance.viewContext)
        .environmentObject(mainListViewModel)
}
