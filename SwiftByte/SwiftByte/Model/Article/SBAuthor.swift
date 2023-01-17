//
//  SBAuthor.swift
//  SwiftByte
//
//  Created by Cédric Bahirwe on 21/12/2022.
//

import Foundation

struct SBAuthor: Codifiable, SBAppUser {
    var id: String? = UUID().uuidString
    var firstName: String
    var lastName: String
    var email: String = ""
    var bio: String?
    var joinedDate: Date?
}

extension SBAuthor {
    static var anonymous: SBAuthor {
        SBAuthor(firstName: "Anonymous",
                 lastName: "Boy",
                 email: "Some random Name",
                 joinedDate: nil)
    }

    func toSBUSer() -> SBUser {
        SBUser(id: id,
               firstName: firstName,
               lastName: lastName,
               email: email,
               notificationAuthorized: false)
    }
}
