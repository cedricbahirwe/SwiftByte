//
//  View+Extension.swift
//  SwiftByte
//
//  Created by Cédric Bahirwe on 20/12/2022.
//

import SwiftUI

extension View {
    /// Dismiss keyboard
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

extension NSObject {
    /// Get App Root ViewController
    func getAppRootView() async -> UIViewController? {
        guard let screen = await UIApplication.shared.connectedScenes.first as? UIWindowScene else {
            return nil
        }
        guard let root = await screen.windows.first?.rootViewController else {
            return nil
        }
        return root
    }
}

extension EnvironmentValues {

    var isPreview: Bool {
        return ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1"
    }

}
