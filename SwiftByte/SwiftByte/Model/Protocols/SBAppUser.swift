//
//  SBAppUser.swift
//  SwiftByte
//
//  Created by Cédric Bahirwe on 17/01/2023.
//

import Foundation

protocol SBAppUser: Hashable {
    var id: String? { get set }
    var firstName: String { get set }
    var lastName: String { get set }
}

extension SBAppUser {
    func getFullName() -> String {
        "\(firstName) \(lastName)"
    }
}
