//
//  URLExtension.swift
//  MetaCards
//
//  Created by Dmytro Maniakhin on 14.12.2023.
//

import Foundation

extension URL {
    static func storeURL(for appGroup: String, databaseName: String) -> URL? {
        guard let contaner = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: appGroup) else {
            print("Error: unable to create URL for \(appGroup) group identifier")
            return nil
        }
        return contaner.appendingPathComponent("\(databaseName).sqlite")
    }
}
