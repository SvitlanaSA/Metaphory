//
//  NotificationSettingsViewModel.swift
//  MetaCards
//
//  Created by Dmytro Maniakhin on 01.12.2023.
//

import UIKit
import Combine
import SharedStuff

class NotificationSettingsViewModel: ObservableObject {
    @Published var isShowDailyCardOn = false
    @Published var isShowDailyCardDisabled = false
    @Published var isDeniedMessageVisible = false
    @Published var isDateControlsVisible = false
    @Published var selectedTime: Date
    @Published var filterButtonFilled = false
    @Published var filterOptionsPopupPresented = false
    @Published fileprivate(set) var filterOptionsViewModel: FilterOptionsViewModel?

    fileprivate var authorizationStatus = AuthorizationStatus.unknown
    fileprivate var settingsModel: NotificationSettingsModelProtocol
    fileprivate var cancelableOnCardFilterUpdates: AnyCancellable?

    init(settingsModel: NotificationSettingsModelProtocol = NotificationSettingsModel()) {
        self.settingsModel = settingsModel
        self.selectedTime = settingsModel.selectedTime
        
        debounceSelectedTimeChanges()
    }
    
    func setupInitialStates() {
        setupFilterOptionsViewModel()
    }
    func validateStates() { }
    func invalidateNotificationsPoolIfNeeded() { }
    
    // MARK: - Private methods
    
    fileprivate func debounceSelectedTimeChanges() { }
    fileprivate func setupFilterOptionsViewModel() {
        filterOptionsViewModel = FilterOptionsViewModel(cards: [])
    }
}

extension NotificationSettingsViewModel {
    enum AuthorizationStatus {
        case notDetermined
        case denied
        case authorized
        case unknown
    }
}

class NotificationSettingsViewModelImp: NotificationSettingsViewModel {
    private var disposeBag = Set<AnyCancellable>()

    override var isShowDailyCardOn: Bool {
        didSet {
            if showDailyCardOn() != isShowDailyCardOn {
                settingsModel.isShowDailyCardOn = isShowDailyCardOn
                setupUIStates()
                invalidateNotificationsPool()
            }
        }
    }
    
    override var authorizationStatus: AuthorizationStatus {
        didSet {
            switch authorizationStatus {
            case .notDetermined:
                requestAuthorization()
            case .denied, .authorized, .unknown:
                setupUIStates()
            }
        }
    }
    
    override func setupInitialStates() {
        authorizationStatus = .unknown
        setupFilterOptionsViewModel()
    }
    
    override func validateStates() {
        updateAuthorizationStatus()
    }
    
    override func invalidateNotificationsPoolIfNeeded() {
        requestAuthorizationStatus { [weak self] status in
            guard let self,
                  !self.showDailyCardDisabled(for: status),
                  self.showDailyCardOn() else { return }
            invalidateNotificationsPool()
        }
    }
    
    // MARK: - Private methods
    
    override fileprivate func debounceSelectedTimeChanges() {
        $selectedTime
            .debounce(for: 2, scheduler: RunLoop.main)
            .sink { [weak self] _ in
                guard let strongSelf = self else { return }
                let modelTimeString = strongSelf.settingsModel.formattedStringValueByTime(date: strongSelf.settingsModel.selectedTime)
                let viewModelTimeString = strongSelf.settingsModel.formattedStringValueByTime(date: strongSelf.selectedTime)

                if modelTimeString != viewModelTimeString {
                    strongSelf.settingsModel.selectedTime = strongSelf.selectedTime
                    strongSelf.invalidateNotificationsPool()
                }
            }
            .store(in: &disposeBag)
    }
    
    override fileprivate func setupFilterOptionsViewModel() {
        let cards = availableCards()
        let filterOptionsViewModel = FilterOptionsViewModel(cards: cards)
        filterOptionsViewModel.apply(cardFilter: self.settingsModel.cardFilter)
        cancelableOnCardFilterUpdates = $filterOptionsPopupPresented.sink(receiveValue: { [weak self] isPopupPresented in
            guard let self, let filter = self.filterOptionsViewModel?.cardFilter else { return }
            let storedFilter = self.settingsModel.cardFilter
            if !isPopupPresented && storedFilter != filter {
                self.settingsModel.cardFilter = filter
                self.invalidateNotificationsPool()
                self.invalidateFilterButtonFilledState()
            }
        })
        self.filterOptionsViewModel = filterOptionsViewModel
    }
    
    private func invalidateNotificationsPool() {
        if showDailyCardOn() {
            scheduleNotifications()
        } else {
            removeAllNotifications()
        }
    }
    
    private func scheduleNotifications() {
        removeAllNotifications()
        UserNotificationHelper.shared.scheduleNotifications(with: settingsModel)
    }

    private func removeAllNotifications() {
        UserNotificationHelper.shared.removeScheduledNotifications()
    }
    
    private func requestAuthorizationStatus(complition: @escaping (AuthorizationStatus) -> ()) {
        UserNotificationHelper.shared.getNotificationSettings { notificationSettings in
            let authorizationStatus: AuthorizationStatus
            switch notificationSettings.authorizationStatus {
            case .notDetermined:
                authorizationStatus = .notDetermined
            case .denied:
                authorizationStatus = .denied
            case .authorized:
                authorizationStatus = .authorized
            default:
                authorizationStatus = .unknown
            }
            DispatchQueue.main.async {
                complition(authorizationStatus)
            }
        }
    }
    
    private func updateAuthorizationStatus() {
        requestAuthorizationStatus { [weak self] status in
            self?.authorizationStatus = status
        }
    }
    
    private func requestAuthorization() {
        UserNotificationHelper.shared.requestAuthorization(options: [.alert]) { granted, error in
            if let error = error {
                print("NotificationSettingsViewModel on requestAuthorization get error: \(error)")
                return
            }
            
            self.updateAuthorizationStatus()
        }
    }
    
    private func setupUIStates() {
        isDeniedMessageVisible = deniedMessageVisible(for: authorizationStatus)
        isShowDailyCardDisabled = showDailyCardDisabled(for: authorizationStatus)
        isShowDailyCardOn = showDailyCardOn()
        isDateControlsVisible = showDailyCardOn() && !showDailyCardDisabled(for: authorizationStatus)
        selectedTime = settingsModel.selectedTime
        invalidateFilterButtonFilledState()
    }
    
    private func invalidateFilterButtonFilledState() {
        filterButtonFilled = !settingsModel.cardFilter.isEmpty
    }
    
    private func deniedMessageVisible(for status: AuthorizationStatus) -> Bool {
        status == .denied
    }

    private func showDailyCardDisabled(for status: AuthorizationStatus) -> Bool {
        status != .authorized
    }

    private func showDailyCardOn() -> Bool {
        settingsModel.isShowDailyCardOn
    }
    
    private func availableCards() -> [CDCard] {
        let manager = PersistenceControllerProvider.controller.entityManager
        let format = "\(#keyPath(CDCard.cdLocked)) == NO"
        return manager.fetchEntities(predicate: format)
    }
}
