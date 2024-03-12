//
//  Provider.swift
//  MetaCardsWidgetExtension
//
//  Created by Dmytro Maniakhin on 10.01.2024.
//

import WidgetKit
import Intents

struct Provider: IntentTimelineProvider {
    typealias Intent = MetaCardsCategoriesIntent
    typealias Entry = WidgetEntry
    
    func placeholder(in context: Context) -> WidgetEntry {
        return WidgetEntryFactory.getPlaceholderEntry()
    }

    func getSnapshot(for configuration: MetaCardsCategoriesIntent, in context: Context, completion: @escaping (WidgetEntry) -> ()) {
        let entry = WidgetEntryFactory.getSnapshotEntry(for: configuration)
        completion(entry)
    }

    func getTimeline(for configuration: MetaCardsCategoriesIntent, in context: Context, completion: @escaping (Timeline<WidgetEntry>) -> Void) {
        let entry = WidgetEntryFactory.getRandomEntry(for: configuration)
        
        let nextUpdateDate = Calendar.current.date(byAdding: .minute, value: configuration.frequencyType?.convertToHours() ?? 24, to: Date())!
        let timeline = Timeline(entries: [entry], policy: .after(nextUpdateDate))
        
        completion(timeline)
    }
}
