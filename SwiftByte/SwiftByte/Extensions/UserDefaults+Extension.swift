//
//  UserDefaults+Extension.swift
//  SwiftByte
//
//  Created by Cédric Bahirwe on 20/12/2022.
//

import Foundation

extension UserDefaults {
    func setValue(_ value: Any?, forKey key: SBKeys) {
        setValue(value, forKey: key.rawValue)
    }

    func bool(for key: SBKeys) -> Bool {
        bool(forKey: key.rawValue)
    }
}
