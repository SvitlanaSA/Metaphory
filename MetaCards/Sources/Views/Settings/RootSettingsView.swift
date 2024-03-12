//
//  RootSettingsView.swift
//  MetaCards
//
//  Created by Svetlana Stegnienko on 14.04.2023.
//
import SwiftUI

struct RootSettingsView: View {
    @EnvironmentObject private var viewModel: SettingsViewModel

    var body: some View {
        NavigationStack {
            List(viewModel.settingList, id: \.id)
            { value in
                settingItemView(value: value)
            }
            .padding(.top, 0)
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)

            .foregroundStyle(Color.foregroundColor)
            .ignoresSafeArea(edges: .bottom)
            .scrollContentBackground(.hidden)
            .background {
                ZStack (alignment: .bottomTrailing) {
                    Color.settingColor.ignoresSafeArea()
                    Image("settingImage")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 120)
                        .padding(.trailing, 30)

                }.ignoresSafeArea()
            }
        }
        .tint(Color.foregroundColor)
    }

    
    // MARK: - Private methods

    private func listRow(value: SettingContent) -> some View {
        HStack{
            Image(systemName: value.imageName)
                .padding(.horizontal, 10)
            if value.title == .widgetSettings {
                VStack(alignment: .leading) {
                    Text(value.title.rawValue.localizedString)
                        .font(.defaultApp(size: 18))
                        .padding(.horizontal, 10)


                    Text("strongly remomended to try".localizedString)
                        .font(.defaultApp(size: 15))
                        .padding(.horizontal, 10)
                }
            } else {
                Text(value.title.rawValue.localizedString)
                    .font(.defaultApp(size: 18))
                    .padding(.all, 10)
            }


            Spacer()
        }
    }

    @ViewBuilder private func settingItemView(value: SettingContent) -> some View  {
        if value.title == .restorePurchase {
            Button(action: {
                viewModel.restorePurchases()
            }, label: {
                listRow(value: value)
                    .id(value.id)
            })
        } else {
            NavigationLink {
                switch value.title {
                    case .workingwithCards:
                        TechniqueSettingView()
                            .environmentObject(TechniqueSettingViewModel())
                    case .language:
                        LanguageView()
                    case .widgetSettings:
                        WidgetSettingView()
                    case .buyPrintedDecks:
                        CardSourceSettingView()
                            .environmentObject(CardSourceSettingViewModel())
                    default:
                        NotificationSettingsView()
                            .environmentObject(viewModel.notificationSettingsViewModel)
                }
            } label: {
                listRow(value: value)
                    .id(value.id)
            }
        }
    }
}

struct RootSettingsView_Previews: PreviewProvider {
    static let settingsViewModel = SettingsViewModel(notificationSettingsViewModel: NotificationSettingsViewModel())

    static var previews: some View {
        RootSettingsView()
            .environmentObject(settingsViewModel)
    }
}
