//
//  SceneDelegate.swift
//  SwiftByte
//
//  Created by Cédric Bahirwe on 20/12/2022.
//

import SwiftUI

@MainActor
class SceneDelegate: NSObject, UIWindowSceneDelegate, ObservableObject {
    func windowScene(_ windowScene: UIWindowScene, performActionFor shortcutItem: UIApplicationShortcutItem) async -> Bool {
        // Do something with the shortcut...
        return true
    }
}
