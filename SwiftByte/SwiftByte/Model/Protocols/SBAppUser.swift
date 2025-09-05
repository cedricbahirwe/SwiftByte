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
    func getInitials() -> String {
        "\(firstName.prefix(1))\(lastName.prefix(1))"
    }
    func getFullName() -> String {
        "\(firstName) \(lastName)"
    }
}
