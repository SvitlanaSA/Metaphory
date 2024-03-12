//
//  MetaCardsWidget.swift
//  MetaCardsWidget
//
//  Created by Svetlana Stegnienko on 03.08.2023.
//

import WidgetKit
import SwiftUI
import Intents
//import Firebase

@main
struct MetaCardsWidget: Widget {
    let kind: String = "MetaCardsWidget"

    init() {
//        FirebaseApp.configure()
    }
    
    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: MetaCardsCategoriesIntent.self, provider: Provider()) { entry in
            WidgetMainView(viewModel: entry)
        }
        .configurationDisplayName("Metaphorical cards")
        .description("Setup your widget.")
        .containerBackgroundRemovable(true)
        .contentMarginsDisabled()
        .supportedFamilies([
            .systemSmall,
            .systemMedium,
            .systemLarge,
            .systemExtraLarge,
        ])
    }
}
