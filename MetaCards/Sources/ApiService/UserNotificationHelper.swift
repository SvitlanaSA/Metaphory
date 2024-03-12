//
//  UserNotificationHelper.swift
//  MetaCards
//
//  Created by Dmytro Maniakhin on 07.12.2023.
//

import UIKit
import SharedStuff

class UserNotificationHelper: NSObject {
    static let shared: UserNotificationHelper = {
        return UserNotificationHelper()
    }()
    
    private var center = UNUserNotificationCenter.current()
    private let allCommonCalendarComponents: Set<Calendar.Component> = [.year, .month, .day, .hour, .minute, .second, . nanosecond, .calendar, .timeZone]
    
    func getNotificationSettings(completionHandler: @escaping (UNNotificationSettings) -> Void) {
        center.getNotificationSettings(completionHandler: completionHandler)
    }
    
    func requestAuthorization(options: UNAuthorizationOptions = [], completionHandler: @escaping (Bool, Error?) -> Void) {
        center.requestAuthorization(options: options, completionHandler: completionHandler)
    }
    
    func scheduleNotifications(with settings: NotificationSettingsModelProtocol) {
        let time = settings.selectedTime
        let filter = settings.cardFilter
        let startTime = preparedDate(from: time)
        let cards = availableCards(filteredBy: filter)
        let requests = notificationRequests(for: cards, startAt: startTime)
        
        /// From documentation:
        ///     An app can have only a limited number of scheduled notifications; the system keeps the soonest-firing 64 notifications
        ///     (with automatically rescheduled notifications counting as a single notification) and discards the rest.
        ///
        /// So here I try to add more oldest requests firstly and then System left only nearest newest requests
        for request in requests.reversed() {
            center.add(request)
        }
    }
    
    func removeScheduledNotifications() {
        center.removeAllPendingNotificationRequests()
    }
    
    // MARK: - Private methods
    
    private override init() {
        super.init()
        center.delegate = self
    }
    
    private func preparedDate(from date: Date) -> Date {
        let calendar = Calendar.current
        let expectedDateComponents = calendar.dateComponents([.hour, .minute], from: date)

        var dateComponents = calendar.dateComponents(allCommonCalendarComponents, from: Date())
        dateComponents.hour = expectedDateComponents.hour
        dateComponents.minute = expectedDateComponents.minute
        dateComponents.second = 0
        dateComponents.nanosecond = 0

        return calendar.date(from: dateComponents) ?? Date()
    }
    
    private func availableCards(limitedCount: Int = 128, filteredBy filter: CardFilter) -> [CDCard] {
        let manager = PersistenceControllerProvider.controller.entityManager
        let format = "\(#keyPath(CDCard.cdLocked)) == NO"
        var cards: [CDCard] = manager.fetchEntities(predicate: format)
        cards = filter.filtered(cards: cards).shuffled()
        if cards.count > limitedCount {
            cards = Array(cards.dropLast(cards.count - limitedCount))
        }
        return cards
    }
    
    private func notificationRequests(for cards: [CDCard], startAt time: Date) -> [UNNotificationRequest] {
        var date = time
        var result = [UNNotificationRequest]()
        for card in cards {
            let content = notificationContent(for: card)
            let trigger = notificationTrigger(for: date, nextDate: &date)
            let request = UNNotificationRequest(
                identifier: UUID().uuidString,
                content: content,
                trigger: trigger
            )
            result.append(request)
        }
        return result
    }
    
    private func notificationContent(for card: CDCard) -> UNNotificationContent {
        let content = UNMutableNotificationContent()
        content.title = "cNotificationContentTitle".localizedString
        content.categoryIdentifier = notificationRequestIdentifier(for: card)
        content.userInfo = notificationContentUserInfo(for: card)
        content.body = notificationContentBody(for: card)
        
        return content
    }
    
    private func notificationContentUserInfo(for card: CDCard) -> [AnyHashable : Any] {
        return [
            UNNotificationRequestContentIdentifierString : card.title,
            UNNotificationRequestContentTitleString : card.title.localizedString,
        ]
    }
    
    private func notificationContentBody(for card: CDCard) -> String {
        var result = ""
        if card.cardType == .metaCards {
            result = "cNotificationContentMetacardBody".localizedString
        } else if isTitleTrancationExpected(for: card) {
            result = "cNotificationContentCardLongPressHint".localizedString
        } else {
            result = card.title.localizedString
        }
        
        return result
    }
    
    private func notificationTrigger(for date: Date, nextDate: inout Date) -> UNNotificationTrigger {
        let calendar = Calendar.current
        let dateComponents = calendar.dateComponents(allCommonCalendarComponents, from: date)
//#if DEBUG
//        nextDate = calendar.date(byAdding: .second, value: 20, to: date) ?? date
//#else
        nextDate = calendar.date(byAdding: .day, value: 1, to: date) ?? date
//#endif
        return UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
    }
    
    private func notificationRequestIdentifier(for card: CDCard) -> String {
        var result = UNNotificationRequestIdentifierUsualCategoryString
        if card.cardType == .metaCards ||
            isTitleTrancationExpected(for: card) {
            result = UNNotificationRequestIdentifierExpandableCategoryString
        }
        
        return result
    }
    
    private func isTitleTrancationExpected(for card: CDCard) -> Bool {
        let title = card.title.localizedString
        let textLimit = UIDevice.isIphone ? 70 : 100
        return title.count > textLimit
    }
}

extension UserNotificationHelper: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification) async -> UNNotificationPresentationOptions {
        [.list, .badge, .banner]
    }
}
