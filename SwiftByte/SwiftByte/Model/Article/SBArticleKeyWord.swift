//
//  SBArticleKeyWord.swift
//  SwiftByte
//
//  Created by Cédric Bahirwe on 21/12/2022.
//

import Foundation

struct SBArticleKeyWord: Hashable, Codable {
    let name: String
    init(_ name: String) {
        self.name = name
    }
}
