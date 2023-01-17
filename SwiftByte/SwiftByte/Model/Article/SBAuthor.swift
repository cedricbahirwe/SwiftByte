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
    var email: String
    var bio: String?
    var joinedDate: Date?

    init(id: String? = nil, firstName: String, lastName: String, email: String, bio: String? = nil, joinedDate: Date? = nil) {
        self.id = id
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.bio = bio
        self.joinedDate = joinedDate
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decodeIfPresent(String.self, forKey: .id)
        self.firstName = try container.decode(String.self, forKey: .firstName)
        self.lastName = try container.decode(String.self, forKey: .lastName)
        self.email =  try container.decodeIfPresent(String.self, forKey: .bio) ?? ""
        self.bio = try container.decodeIfPresent(String.self, forKey: .bio)
        self.joinedDate = try container.decodeIfPresent(Date.self, forKey: .joinedDate)
    }

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
