//
//  File.swift
//  Metaphory
//
//  Created by Svetlana Stegnienko on 13.02.2024.
//

import SwiftUI

enum SettingTitle: String {
    case workingwithCards = "cWorkingwithCards"
    case notificationSettings = "cNotificationSettings"
    case widgetSettings = "cWidgetSettings"
    case buyPrintedDecks = "cBuyPrintedDecks"
    case restorePurchase = "cRestorePurchase"
    case language = "cLanguage"
}

struct SettingContent: Identifiable {
    let id = UUID()
    var imageName: String
    var title: SettingTitle
}
