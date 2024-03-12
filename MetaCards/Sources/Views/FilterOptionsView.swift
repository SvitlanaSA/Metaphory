//
//  FilterOptionsView.swift
//  Metaphory
//
//  Created by Dmytro Maniakhin on 22.02.2024.
//

import SwiftUI
import SharedStuff

struct FilterOptionsView<LabelView>: View where LabelView : View {
    @EnvironmentObject var viewModel: FilterOptionsViewModel
    @Binding private var isPresented: Bool
    private let labelView: () -> LabelView

    init(presented: Binding<Bool>, @ViewBuilder labelView: @escaping () -> LabelView) {
        self.labelView = labelView
        _isPresented = presented
    }
    
    var body: some View {
        labelView()
            .popover(isPresented: $isPresented,
                     attachmentAnchor: .point(.center),
                     arrowEdge: .bottom) {
                mainView()
                    .presentationCompactAdaptation(.popover)
            }
    }

    // MARK: - Private methods
    
    @ViewBuilder private func mainView() -> some View {
        List {
            firstSection()
            secondSection()
            thirdSection()
        }
        .frame(minWidth: 380.0, minHeight: minHeightListView())
    }
    
    @ViewBuilder private func firstSection() -> some View {
        Section("Filtered by:") {
            menuItemButton(title: "All cards".localizedString,
                           selected: viewModel.allCardsSelected,
                           locked: false) {
                viewModel.allCardsAction()
            }.font(.defaultApp())
        }
    }
    
    @ViewBuilder private func secondSection() -> some View {
        if viewModel.cardTypesAvailable {
            Section {
                ForEach(viewModel.cardTypes) { cardType in
                    menuItemButton(title: cardType.identifier.localizedString,
                                   selected: viewModel.selectedItem(for: cardType),
                                   locked: viewModel.lockedItem(for: cardType)) {
                        viewModel.selectAction(for: cardType)
                    }
                }
                .font(.defaultApp())
            }
        }
    }
    
    @ViewBuilder private func thirdSection() -> some View {
        Section {
            ForEach(viewModel.cardCategories) { cardCategory in
                menuItemButton(title: cardCategory.identifier.localizedString,
                               selected: viewModel.selectedItem(for: cardCategory),
                               locked: viewModel.lockedItem(for: cardCategory)) {
                    viewModel.selectAction(for: cardCategory)
                }
            }
            .font(.defaultApp())
        }
    }
    
    private func menuItemButton(title: String, selected: Bool, locked: Bool, action: @escaping () -> ()) -> some View {
        Button(action: action, label: {
            HStack {
                Image(systemName: "checkmark")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 14)
                    .padding(.horizontal, 5)
                    .opacity(selected ? 1 : 0)
                Text(title)
                    .font(.defaultApp(size: 20))
                if locked {
                    Spacer()
                    Image(systemName: "lock")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 10)
                }
            }
            .foregroundStyle(Color.foregroundColor)
        })
    }
    
    private func minHeightListView() -> CGFloat {
//#warning("Hard coded height. Need add some dynamic calculations corresponding on items count, heights, position of labelView, available heights for popup.")
        return 380
    }
}

#Preview {
    struct WrapperView: View {
        @State private var isPresented = false
        
        var body: some View {
            let folder = PreviewAssistance.instance.fetchTestedFavoriteFolderAndAddAllCards()
            let viewModel = FilterOptionsViewModel(cards: folder.cards)
            
            return FilterOptionsView(presented: $isPresented) {
                FilterButton(filled: false) {
                    isPresented.toggle()
                }
            }
            .environmentObject(viewModel)
        }
    }

    return WrapperView()
}
