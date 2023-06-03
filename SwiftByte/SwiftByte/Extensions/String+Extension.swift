//
//  String+Extension.swift
//  SwiftByte
//
//  Created by Cédric Bahirwe on 17/01/2023.
//

import Foundation

extension String {
    var removeWhitespacesAndNewlines: String {
        self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
