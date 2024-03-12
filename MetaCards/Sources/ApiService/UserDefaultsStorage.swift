//
//  UserDefaultsStorage.swift
//  MetaCards
//
//  Created by Dmytro Maniakhin on 05.12.2023.
//

import Foundation

@propertyWrapper
struct UserDefaultsStorage<Value: Codable> {
    private let key: String
    var defaultValue: Value
    private let storage: UserDefaults
    
    init(key: String, defaultValue: Value, storage: UserDefaults = .standard) {
        self.key = key
        self.defaultValue = defaultValue
        self.storage = storage
    }
    
    var wrappedValue: Value {
        get {
            guard let data = storage.object(forKey: key) as? Data,
                  let value = try? JSONDecoder().decode(Value.self, from: data) else { return defaultValue }
            return value
        }
        set {
            guard let encoded = try? JSONEncoder().encode(newValue) else { return }
            storage.set(encoded, forKey: key)
        }
    }
}
