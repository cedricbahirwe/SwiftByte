//
//  ForceUpdateManager.swift
//  SwiftByte
//
//  Created by Cédric Bahirwe on 16/01/2023.
//

import Foundation
import UIKit
import SwiftUI

enum AppUpdateType: Int {
    case majorUpdates, minorUpdates, noUpdates
}

class ForceUpdateManager: ObservableObject {
    private let minimalVersionNumbers = 2

    @Published private(set) var updateAlert: UpdateAlert?

    var isPresented: Binding<Bool> {
        Binding { [weak self] in
            self?.updateAlert != nil
        } set: { [weak self] newValue in
            guard !newValue else { return }
            self?.updateAlert = nil
        }

    }

    init() {
        checkAppVersion()
    }

    func checkAppVersion() {
//        RemoteConfigs.shared.fetchRemoteValue
        guard  let storeAppVersion = RemoteConfigs.shared.string(for: .latestAppVersion) else { fatalError() }
        printf("Damn version", storeAppVersion)
        let update = getTypeOfUpdate(storeAppVersion: storeAppVersion)
        switch update {
        case .noUpdates:
            break
        case .majorUpdates:
            let actions = [
                UpdateAlert.Action("Download", action: openAppOnStore)
            ]
            self.updateAlert = .init(title: "Please, Update your app!",
                                     message: "You haven't updated your app for a long time! Quickly download the latest version of the app to take advantage of the new features. It's quick and easy !",
                                     buttons: actions)

        case .minorUpdates:
            let actions = [
                UpdateAlert.Action("Not Now", action:  {}),
                UpdateAlert.Action("Download", action: openAppOnStore)
            ]

            self.updateAlert = .init(title: "New Version available!",
                                     message: "A new version of the app is available. Download it as soon as possible to enjoy all the latest features!",
                                     buttons: actions)

        }
    }

    private func getTypeOfUpdate(storeAppVersion: String) -> AppUpdateType {
        let version = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? ""
        print("my version: \(version)")
        let currentVersionArray = version.components(separatedBy: ".")
        let storeVersionArray = storeAppVersion.components(separatedBy: ".")

        if (currentVersionArray.count > minimalVersionNumbers && storeVersionArray.count > minimalVersionNumbers) {
            let currentMajorVersion = currentVersionArray[0]
            let storeMajorVersion = storeVersionArray[0]
            if (currentMajorVersion < storeMajorVersion) {
                return .majorUpdates
            } else if (currentMajorVersion == storeMajorVersion) &&
                        (currentVersionArray[1] < storeVersionArray[1]) {
                return .minorUpdates
            }
        }

        return .noUpdates
    }

    struct UpdateAlert: Identifiable {
        let id: UUID = UUID()
        let title: String
        let message: String
        let buttons: [UpdateAlert.Action]

        struct Action: Identifiable {
            let title: String
            let action: () -> Void

            var id: String { self.title }

            init(_ title: String, action: @escaping () -> Void) {
                self.title = title
                self.action = action
            }
        }
        
    }

    private func openAppOnStore() {
        guard let appLink = URL(string: AppConstants.appStoreURL)
        else { return }
        UIApplication.shared.open(appLink, options: [:], completionHandler: nil)
    }
}
