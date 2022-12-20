//
//  View+Extension.swift
//  SwiftByte
//
//  Created by Cédric Bahirwe on 20/12/2022.
//

import SwiftUI

extension NSObject {
    func getAppRootView() -> UIViewController? {
        guard let screen = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
            return nil
        }
        guard let root = screen.windows.first?.rootViewController else {
            return nil
        }
        return root
    }
}
