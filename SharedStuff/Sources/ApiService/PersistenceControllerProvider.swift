//
//  PersistenceControllerProvider.swift
//  MetaCards
//
//  Created by Dmytro Maniakhin on 10.01.2024.
//

import Foundation

public enum PersistenceControllerProvider {
    public static var previewMode = false
    public static var controller: PersistenceControllerProtocol {
        previewMode ? PersistenceController.previewInstance : PersistenceController.instance
    }
}
