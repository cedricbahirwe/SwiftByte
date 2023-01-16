//
//  SBFirebaseRemoteConfig.swift
//  SwiftByte
//
//  Created by Cédric Bahirwe on 16/01/2023.
//

import FirebaseRemoteConfig

protocol RemoteConfigsProtocol: AnyObject {
    func fetchRemoteValues(_ completion: @escaping(Bool) -> Void)
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
    func fetchRemoteValues(_ completion: @escaping(Bool) -> Void = { _ in }) {
        let timeoutInterval = TimeInterval(fetchTimeout)
        firebaseRemoteConfig.fetch(withExpirationDuration: timeoutInterval) { status, _ -> Void in
            if status == .success {
                completion(true)
                debugPrint("Remote config fetched!")
                self.firebaseRemoteConfig.activate { (success, error) in
                    if let error = error {
                        debugPrint("Remote config failed to activate: \(error)")
                    }

                    if success == false {
                        debugPrint("Remote config failed to activate")
                    }
                }
            } else {
                completion(false)
                debugPrint("Remote config not fetched")
            }
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
