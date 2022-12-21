//
//  SBAuthor.swift
//  SwiftByte
//
//  Created by Cédric Bahirwe on 21/12/2022.
//

import Foundation

struct SBAuthor: Hashable, Codifiable {
    var id: UUID = UUID()
    var firstName: String
    var lastName: String
    var bio: String?
    var joinedDate: Date?

    var fullName: String {
        "\(firstName) \(lastName)"
    }

    static var anonymous: SBAuthor {
        SBAuthor(firstName: "Anonymous", lastName: "", joinedDate: nil)
    }
}
