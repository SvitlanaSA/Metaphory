//
//  WidgetMainViewModel.swift
//  MetaCardsWidgetExtension
//
//  Created by Dmytro Maniakhin on 11.01.2024.
//

import SwiftUI

enum WidgetViewType {
    case metacard
    case textual
    case placeholder
}

protocol WidgetMainViewModelProtocol {
    var viewType: WidgetViewType { get }
    
    func createMetacardViewModel() -> WidgetMetacardViewModelProtocol
    func createTextualViewModel() -> WidgetTextualViewModelProtocol
}
