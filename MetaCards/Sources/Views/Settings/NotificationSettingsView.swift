//
//  NotificationSettingsView.swift
//  MetaCards
//
//  Created by Dmytro Maniakhin on 01.12.2023.
//

import SwiftUI

struct NotificationSettingsView: View {
    @EnvironmentObject var viewModel: NotificationSettingsViewModel
    
    private let appDidBecomeActive = NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)
    
    var body: some View {
        mainBodyView()
            .onAppear() {
                viewModel.setupInitialStates()
                viewModel.validateStates()
            }
            .onReceive(appDidBecomeActive) { _ in
                viewModel.validateStates()
            }
    }
    
    // MARK: - Private methods
    
    private func mainBodyView() -> some View {
        VStack(alignment: .leading, spacing: 10.0) {
            showDailyCardView()
            if viewModel.isDeniedMessageVisible {
                deniedMessageView()
            } else if viewModel.isDateControlsVisible {
                dateControlsView()
                filterControlsView()
            }
            Spacer()
        }
        .padding(.all)
        .frame(maxWidth: .infinity)
        .background(Color.settingColor)
    }
    
    private func showDailyCardView() -> some View {
        Toggle(isOn: $viewModel.isShowDailyCardOn) {
            Text("Show daily card")
                .font(.defaultApp(size: 20))
                .bold()
                .foregroundStyle(Color.foregroundColor)
        }
        .disabled(viewModel.isShowDailyCardDisabled)
    }
    
    private func deniedMessageView() -> some View {
        VStack(alignment: .leading) {
            Text("Notifications are disabled in app ")
                .font(.defaultApp(size: 20))
                .bold()
                .foregroundStyle(Color.foregroundColor)
            if let URL = URL(string: UIApplication.openSettingsURLString) {
                Link("Settings", destination: URL)
            } else {
                Text("Settings")
            }
        }
    }
    
    private func dateControlsView() -> some View {
        DatePicker(selection: $viewModel.selectedTime, displayedComponents: .hourAndMinute) {
            Text("Every day at ")
                .font(.defaultApp(size: 20))
                .bold()
                .foregroundStyle(Color.foregroundColor)
        }
    }
    
    private func filterControlsView() -> some View {
        HStack {
            Text("cNotificationSettingsCardsParticipation")
                .font(.defaultApp(size: 20))
                .bold()
                .foregroundStyle(Color.foregroundColor)
            if let filterOptionsViewModel = viewModel.filterOptionsViewModel {
                Spacer()
                FilterOptionsView(presented: $viewModel.filterOptionsPopupPresented)   {
                    FilterButton(filled: viewModel.filterButtonFilled) {
                        viewModel.filterOptionsPopupPresented.toggle()
                    }
                    .disabled(viewModel.filterOptionsPopupPresented)
                }
                .environmentObject(filterOptionsViewModel)
            }
        }
    }
}

//#Preview {
//}
struct NotificationSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        NotificationSettingsView()
            .previewDisplayName("enabledSettings")
            .environmentObject(enabledSettings())
        
        NotificationSettingsView()
            .previewDisplayName("disabledSettings")
            .environmentObject(disabledSettings())

        NotificationSettingsView()
            .previewDisplayName("deniedSettings")
            .environmentObject(deniedSettings())
    }
    
    static func deniedSettings() -> NotificationSettingsViewModel {
        let settings = NotificationSettingsViewModel(settingsModel: StubSettingsModel())
        settings.isDeniedMessageVisible = true
        settings.isShowDailyCardDisabled = true
        settings.isShowDailyCardOn = false
        return settings
    }
    
    static func disabledSettings() -> NotificationSettingsViewModel {
        let settings = NotificationSettingsViewModel(settingsModel: StubSettingsModel())
        settings.isShowDailyCardDisabled = true
        settings.isShowDailyCardOn = false
        return settings
    }
    
    static func enabledSettings() -> NotificationSettingsViewModel {
        let settings = NotificationSettingsViewModel(settingsModel: StubSettingsModel())
        settings.isShowDailyCardOn = true
        settings.isDateControlsVisible = true
        return settings
    }
    
    struct StubSettingsModel: NotificationSettingsModelProtocol {
        var cardFilter = CardFilter()
        var selectedTime: Date = Date()
        var isShowDailyCardOn: Bool = false
    }
}
