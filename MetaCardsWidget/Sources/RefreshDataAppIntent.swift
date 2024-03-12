//
//  RefreshDataAppIntent.swift
//  MetaCards
//
//  Created by Svetlana Stegnienko on 13.12.2023.
//

import Foundation
import AppIntents
import WidgetKit

struct RefreshDataAppIntent: AppIntent {
    
    static var title: LocalizedStringResource = "Open next page"
    static var description = IntentDescription("Refresh data")
    
    func perform() async throws -> some IntentResult {
        WidgetCenter.shared.reloadAllTimelines()
        return .result()
    }
}
