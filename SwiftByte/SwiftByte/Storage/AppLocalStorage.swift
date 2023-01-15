//
//  AppLocalStorage.swift
//  SwiftByte
//
//  Created by Cédric Bahirwe on 20/12/2022.
//

import Foundation

protocol LocalSaving {
    func save<T: Codable>(element: T)
    func get<T: Codable>() -> T
}

final class AppLocalStorage {

    private let LocalKeys = SBKeys.self

    private let userDefaults = UserDefaults.standard

    private static var _shared: AppLocalStorage?
    static let shared: AppLocalStorage = {
        if _shared == nil {
            _shared = AppLocalStorage()
        }
        return _shared!
    }()

    private init() { }

    /// Save the user object to local storage
    func saveUser(_ value: SBUser) throws {
        let data = try encodeData(value)
        userDefaults.setValue(data, forKey: .userSession)
    }

    /// Get the cached user object
    func getUser() -> SBUser? {
        decodeData(key: .userSession, as: SBUser.self)
    }

    /// Store the Last Sync date if it does not exist
    func storeSyncDate() {
        let syncDateKey = LocalKeys.lastSyncDate
        if userDefaults.value(forKey: syncDateKey) != nil { return }
        userDefaults.setValue(Date(), forKey: syncDateKey)
    }

    /// Remove the existing last sync date, so it can be stored on the next app launch
    func clearSyncDate() {
        userDefaults.setValue(nil, forKey: .lastSyncDate)
    }

    /// Check whether 1 month period has been reached since last sync date
    /// - Parameter date: the last sync date
    /// - Returns: true is the sync date has been reached
    func isSyncDateReached() -> Bool {

        if let lastSyncDate = userDefaults.value(forKey: .lastSyncDate) as? Date {
            // To check if 30 Days have passed
            return Date().timeIntervalSince(lastSyncDate) / 86400 > 30
        }

        return false
    }

    func clearAll() {
        // No Strong reference 
        LocalKeys.allCases.forEach { [weak self] in
            guard let self = self else { return }
            self.userDefaults.removeObject(forKey: $0.rawValue)
        }
    }
}

private extension  AppLocalStorage {
    func encodeData<T>(_ value: T) throws -> Data where T: FirestoreEntity {
        return try JSONEncoder().encode(value)
    }

    func decodeData<T: Decodable>(key: SBKeys, as type: T.Type) -> T? {
        guard let data = userDefaults.object(forKey: key.rawValue) as? Data else {
            return nil
        }
        do {
            return  try JSONDecoder().decode(type, from: data)
        } catch let error {
            print("Couldn't decode the data of type \(type): ", error.localizedDescription)
        }
        return nil
    }

    func decodeDatasArray<T: Codable>(key: SBKeys, type:  Array<T>.Type) -> [T] {
        guard let data = userDefaults.object(forKey: key.rawValue) as? Data else {
            return []
        }
        do {
            return  try JSONDecoder().decode(type, from: data)
        } catch let error {
            print("Couldn't decode the data of type \(type): ", error.localizedDescription)
        }
        return []
    }
}
