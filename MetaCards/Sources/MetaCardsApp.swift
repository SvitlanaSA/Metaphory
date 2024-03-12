//
//  MetaCardsApp.swift
//  MetaCards
//
//  Created by Svetlana Stegnienko on 12.04.2023.
//

import SwiftUI
import SharedStuff

@main
struct MetaCardsApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) private var delegate
    @StateObject var mainListViewModel = MainViewModel()
    @StateObject var settingsViewModel = SettingsViewModel()

    var body: some Scene {
        WindowGroup {
            MainView()
                .onAppear {
                    setupUI()
                }
                .environment(\.managedObjectContext, PersistenceControllerProvider.controller.viewContext)
                .environmentObject(mainListViewModel)
                .environmentObject(settingsViewModel)
        }
    }
    
    // MARK: - Private methods
    
    private func setupUI() {
        let navigationBarAppearance = UINavigationBarAppearance()

        let backButtonAppearance = UIBarButtonItemAppearance(style: .plain)
        backButtonAppearance.focused.titleTextAttributes = [.foregroundColor: UIColor.clear]
        backButtonAppearance.disabled.titleTextAttributes = [.foregroundColor: UIColor.clear]
        backButtonAppearance.highlighted.titleTextAttributes = [.foregroundColor: UIColor.clear]
        backButtonAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.clear]

        navigationBarAppearance.backButtonAppearance = backButtonAppearance
        navigationBarAppearance.titleTextAttributes = [.foregroundColor:  UIColor.black ]
        navigationBarAppearance.backgroundColor = UIColor.white.withAlphaComponent(0.1)
        UINavigationBar.appearance().standardAppearance = navigationBarAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = navigationBarAppearance
    }
}

