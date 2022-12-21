//
//  SBSearchToken.swift
//  SwiftByte
//
//  Created by Cédric Bahirwe on 21/12/2022.
//

import Foundation

struct SBSearchToken: Hashable, Codifiable {
    var id: String { value }
    let value: String


    static func == (lhs: SBSearchToken, rhs: SBSearchToken) -> Bool {
        lhs.value == rhs.value
    }

    init(_ value: String) {
        self.value = value
    }
}
