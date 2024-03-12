//
//  NotificationSettingsModel.swift
//  MetaCards
//
//  Created by Dmytro Maniakhin on 05.12.2023.
//

import Foundation

protocol NotificationSettingsModelProtocol {
    var isShowDailyCardOn: Bool { get set }
    var selectedTime: Date { get set }
    var cardFilter: CardFilter { get set }

    func formattedStringValueByTime(date: Date) -> String
}

extension NotificationSettingsModelProtocol {
    func formattedStringValueByTime(date: Date) -> String {
        return ""
    }
}

struct NotificationSettingsModel: NotificationSettingsModelProtocol {
    @UserDefaultsStorage(key: "NotificationSettings.isShowDailyCardOn", defaultValue: false) var isShowDailyCardOn: Bool
    @UserDefaultsStorage(key: "NotificationSettings.selectedTime", defaultValue: defaultSelectedTime()) var selectedTime: Date
    @UserDefaultsStorage(key: "NotificationSettings.cardFilter", defaultValue: CardFilter()) var cardFilter: CardFilter

    func formattedStringValueByTime(date: Date) -> String {
        return date.formatted(date: .omitted, time: .shortened)
    }
    
    // MARK: - Private methods

    static private func defaultSelectedTime() -> Date {
        let calendar = Calendar.current
        let calendarComponents: Set<Calendar.Component> = [.year, .month, .day, .hour, .minute, .second, . nanosecond, .timeZone]
        var components = calendar.dateComponents(calendarComponents, from: Date())
        components.hour = 12
        components.minute = 00
        components.second = 0
        components.nanosecond = 0

        return calendar.date(from: components) ?? Date()
    }
}
