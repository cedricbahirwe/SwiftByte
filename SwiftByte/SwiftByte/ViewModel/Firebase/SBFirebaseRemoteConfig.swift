//
//  SBFirebaseRemoteConfig.swift
//  SwiftByte
//
//  Created by Cédric Bahirwe on 16/01/2023.
//

import FirebaseRemoteConfig

protocol RemoteConfigsProtocol: AnyObject {
    func fetchRemoteValues() async
    func string(for key: RemoteConfigsFlag) -> String?
    func bool(for key: RemoteConfigsFlag) -> Bool?
}

final class SBFirebaseRemoteConfig {

    private let fetchTimeout: Double = 10.0 // seconds
    private var firebaseRemoteConfig: RemoteConfig!

    init() {
        firebaseRemoteConfig = RemoteConfig.remoteConfig()
        let settings = RemoteConfigSettings()
        settings.minimumFetchInterval = fetchTimeout
        firebaseRemoteConfig.configSettings = settings
    }
}

extension SBFirebaseRemoteConfig: RemoteConfigsProtocol {
    func fetchRemoteValues() async {
        do {
            let timeoutInterval = TimeInterval(fetchTimeout)
            let status = try await firebaseRemoteConfig.fetch(withExpirationDuration: timeoutInterval)
            
            if status == .success {
                _ = try await firebaseRemoteConfig.activate()
            }
        } catch {
            debugPrint("Remote config not fetched:", error.localizedDescription)
        }
    }

    func string(for key: RemoteConfigsFlag) -> String? {
        firebaseRemoteConfig[key.rawValue].stringValue
    }

    func bool(for key: RemoteConfigsFlag) -> Bool? {
        firebaseRemoteConfig[key.rawValue].boolValue
    }
}

final class RemoteConfigs {
    private init() { }
    class var shared: RemoteConfigsProtocol {
        SBFirebaseRemoteConfig()
    }
}

enum RemoteConfigsFlag: String {
    case latestAppVersion = "latest_app_version"
}
