//
//  View+Extension.swift
//  SwiftByte
//
//  Created by Cédric Bahirwe on 20/12/2022.
//

import SwiftUI

extension NSObject {
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
