//
//  ToolbarFilterOptionsView.swift
//  MetaCards
//
//  Created by Svetlana Stegnienko on 13.01.2024.
//

import SwiftUI
import SharedStuff

struct ToolbarFilterOptionsView<LabelView>: View where LabelView : View {
    @EnvironmentObject var viewModel: ToolbarFilterOptionsViewModel
    @Binding private var isPresented: Bool
    private let labelView: () -> LabelView

    init(presented: Binding<Bool>, @ViewBuilder labelView: @escaping () -> LabelView) {
        self.labelView = labelView
        _isPresented = presented
    }
    
    var body: some View {
        if let filterOptionsViewModel = viewModel.filterOptionsViewModel {
            FilterOptionsView(presented: $isPresented, labelView: labelView)
                .environmentObject(filterOptionsViewModel)
        }
    }
}

#Preview {
    struct WrapperView: View {
        @State private var isPresented = false
        
        var body: some View {
            let folder = PreviewAssistance.instance.fetchTestedFavoriteFolderAndAddAllCards()
            let viewModel = ToolbarFilterOptionsViewModel()
            viewModel.updateContent(for: folder)
            
            return ToolbarFilterOptionsView(presented: $isPresented) {
                FilterButton(filled: false) {
                    isPresented.toggle()
                }
            }
            .environmentObject(viewModel)
        }
    }

    return WrapperView()
}
