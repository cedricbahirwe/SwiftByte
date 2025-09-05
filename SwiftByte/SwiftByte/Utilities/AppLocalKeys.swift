//
//  AppLocalKeys.swift
//  SwiftByte
//
//  Created by Cédric Bahirwe on 20/12/2022.
//

import Foundation

public typealias SBKeys = AppLocalKeys
public enum AppLocalKeys: String, CaseIterable, Codable {
    case isUserLoggedIn = "isUserLoggedIn"
//    case snUserType = "snUserType"
    case allowNotifications = "allowNotifications"

    case showWelcomeView = "showWelcomeView"

    case userSession

    static var sessionKeys: Set<AppLocalKeys> {
        return [.isUserLoggedIn, .userSession]
    }
}
