//
//  CardsGridToolbarView.swift
//  MetaCards
//
//  Created by Dmytro Maniakhin on 18.01.2024.
//

import SwiftUI
import SharedStuff
import Combine

struct CardsGridToolbarView: View {
    @State private var filterOptionsPopupPresented = false
    @State private var settingSheetPresented = false
    @State private var infoSheetPresented = false
    @State private var modalStateActive = false
    @EnvironmentObject private var viewModel: CardsGridToolbarViewModel
    let shufflePressed: () -> ()
    let modalStateChanged: (Bool) -> ()

    init(shufflePressed: @escaping () -> Void, modalStateChanged: @escaping (Bool) -> Void) {
        self.shufflePressed = shufflePressed
        self.modalStateChanged = modalStateChanged
    }
    
    var body: some View {
        infoButton()
        filterButton()
        shuffleButton()
        settingButton()
    }
    
    // MARK: - Private methods
    
    @ViewBuilder private func filterButton() -> some View {
        if viewModel.filterButtonVisible {
            ToolbarFilterOptionsView(presented: $filterOptionsPopupPresented)   {
                FilterButton(filled: viewModel.filterButtonFilled) {
                    filterOptionsPopupPresented.toggle()
                }
                .disabled(modalStateActive || viewModel.filterButtonDisabled)
            }
            .onChange(of: filterOptionsPopupPresented, updateModalState)
            .environmentObject(viewModel.toolbarFilterOptionsViewModel)
        }
    }
    
    private func shuffleButton() -> some View {
        ShuffleButton(action: shufflePressed)
            .disabled(modalStateActive || viewModel.shuffleButtonDisabled)
    }
    
    @ViewBuilder private func settingButton() -> some View {
        if viewModel.settingButtonVisible {
            SettingButton {
                settingSheetPresented.toggle()
            }
            .sheet(isPresented: $settingSheetPresented) {
                RootSettingsView()
            }
            .onChange(of: settingSheetPresented, updateModalState)
        }
    }

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

    private func updateModalState() {
        let value = filterOptionsPopupPresented || settingSheetPresented
        modalStateActive = value
        modalStateChanged(value)
    }
}

#Preview {
    let viewModel = CardsGridToolbarViewModel()
    let format = "\(#keyPath(CDFolder.cdIndex)) == 1"
    let folder = PreviewAssistance.instance.fetchTestedFolder(predicate: format)
    viewModel.updateContent(for: folder)

    return HStack{
        CardsGridToolbarView {
        } modalStateChanged: { _ in
        }
    }
    .background(Color(red: 24/255, green: 46/255, blue: 51/255))
    .environmentObject(viewModel)
}
