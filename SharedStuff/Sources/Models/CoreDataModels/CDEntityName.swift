//
//  CDEntityName.swift
//  MetaCards
//
//  Created by Dmytro Maniakhin on 12.12.2023.
//

import Foundation

public struct CDEntityName : Hashable, Equatable, RawRepresentable {
    public var rawValue: String
    
    public init(_ rawValue: String) {
        self.rawValue = rawValue
    }
    
    public init(rawValue: String) {
        self.init(rawValue)
    }
}
