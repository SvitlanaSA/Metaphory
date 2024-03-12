//
//  FolderListView.swift
//  MetaCards
//
//  Created by Dmytro Maniakhin on 18.01.2024.
//

import SwiftUI
import SharedStuff

struct FolderListView: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    @EnvironmentObject private var viewModel: FolderListViewModel

    var body: some View {
        ZStack(alignment: .center) {
            if UIDevice.isIphone {
                backgroundContent()
            } else {
                LinearGradient(gradient: Gradient(colors: [Color(red: 104/255, green: 140/255, blue: 157/255),
                    Color(red: 231/255, green: 226/255, blue: 221/255),
                    Color(red: 200/255, green: 131/255, blue: 128/255)]), startPoint: .top, endPoint: .bottom)

            }
            VStack(alignment: .center) {
                if viewModel.settingButtonVisible {
                    settingsButton()
                }
                listView()
            }.padding(.top, UIDevice.isIphone ? 20 : 1)
            .padding(.horizontal, UIDevice.isIphone ? 25 : 5)
        }
        .ignoresSafeArea(edges: UIDevice.isIphone ? [.top, .bottom] : [.bottom])

        .onAppear() {
            viewModel.viewContext = managedObjectContext
        }
    }

    // MARK: - Private methods

    private func listView() -> some View {

        List(viewModel.folders, selection: $viewModel.selectedFolderID)
        { folder in
            folderRowView(for: folder)
                .id(folder.id)
        }
        .listStyle(.plain)
        .buttonStyle(.plain)
        .ignoresSafeArea(edges: [.bottom])
        .tint(Color.backgroundBlueColor)
        .clipShape(RoundedRectangle(cornerRadius: UIDevice.isIphone ? 10 : 0))
    }

    private func folderRowView(for folder: CDFolder) -> some View {
        let viewModel = FolderViewModel(folder: folder)
        return FolderRowView(viewModel: viewModel)
        .background(.thickMaterial, in: RoundedRectangle(cornerRadius: 30))
        .listRowBackground(Color.clear)
        .shadow(color: .black.opacity(0.1), radius:2)
        .listRowSeparator(.hidden)
        .listRowInsets(.init(top: UIDevice.isIphone ? 10 : 5, leading: 0, bottom: UIDevice.isIphone ? 10 : 5, trailing: 0))
        .listStyle(.plain)

        .frame(maxHeight: self.viewModel.listRowMaxHeight)
    }

    @ViewBuilder private func backgroundContent() -> some View {
        Image("backnew")
            .resizable()
            .ignoresSafeArea(edges: .all)
            .scaledToFill()
            .frame(minWidth: 0, maxWidth: .infinity)
            .clipped()
    }

    private func settingsButton() -> some View {
        HStack {
            Spacer()
            SettingButton {
                viewModel.showSettings()
            }
            .font(.defaultApp(size: 36))
            .foregroundColor(.foregroundColor)
            .padding(.top, 30)
            .padding(.trailing, 10)
            .shadow(color: .white.opacity(0.2), radius: 1)
        }
        .sheet(isPresented: $viewModel.showingSettingSheet) {
            RootSettingsView()
        }
    }
}

#Preview {
    let persistenceController = PersistenceController.previewInstance
    let viewModel = FolderListViewModel()
    return FolderListView()
        .environment(\.managedObjectContext, persistenceController.viewContext)
        .environmentObject(viewModel)
}
