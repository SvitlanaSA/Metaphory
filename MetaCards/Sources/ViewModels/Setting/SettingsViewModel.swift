//
//  SettingsViewModel.swift
//  MetaCards
//
//  Created by Dmytro Maniakhin on 01.12.2023.
//

import Foundation
import StoreKit
import SwiftUI

class SettingsViewModel: ObservableObject {
    @Published private(set) var notificationSettingsViewModel: NotificationSettingsViewModel
    
    init(notificationSettingsViewModel: NotificationSettingsViewModel = NotificationSettingsViewModelImp()) {
        self.notificationSettingsViewModel = notificationSettingsViewModel
        
        notificationSettingsViewModel.invalidateNotificationsPoolIfNeeded()
    }

    @Published var selectedID: SettingContent.ID?

    func restorePurchases() {
        Task {
            try await StoreKit.AppStore.sync()
        }
    }

    var settingList: [SettingContent] {
        return [SettingContent(imageName: "book.and.wrench", title: SettingTitle.workingwithCards),
                SettingContent(imageName: "bell", title: SettingTitle.notificationSettings),
                SettingContent(imageName: "platter.2.filled.ipad", title: SettingTitle.widgetSettings),
                SettingContent(imageName: "homekit", title: SettingTitle.buyPrintedDecks),
                SettingContent(imageName: "arrow.clockwise", title: SettingTitle.restorePurchase),
                SettingContent(imageName: "globe", title: SettingTitle.language)]
    }
}
