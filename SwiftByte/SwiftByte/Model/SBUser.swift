//
//  SBUser.swift
//  SwiftByte
//
//  Created by Cédric Bahirwe on 20/12/2022.
//

import FirebaseFirestore

struct SBUser: Identifiable, SBAppUser, FirestoreEntity {
    static var collectionName: SBCollectionName { .users }

    @DocumentID var id: String?
    // User collected Info
    var firstName: String
    var lastName: String
    var email: String
    var profilePicture: String?

    // App Generated Info
    var messageToken: String?
    var joinDate: Date = Date()
    var notificationAuthorized: Bool

    enum CodingKeys: String, CodingKey {
      case firstName
      case lastName
      case email
      case profilePicture
      case messageToken
      case joinDate
      case notificationAuthorized
    }
}

extension SBUser {
    func toAuthor() -> SBAuthor {
        SBAuthor(firstName: firstName,
                 lastName: lastName,
                 email: email,
                 joinedDate: joinDate)
    }
    static func build(from model: AuthModel, allowNotification: Bool = true) -> Self {
        .init(firstName: model.firstName,
              lastName: model.lastName,
              email: model.email,
              profilePicture: model.profilePicture,
              joinDate: Date(),
              notificationAuthorized: allowNotification)
    }
}

#if DEBUG
extension SBUser {
    static let sample = SBUser(id: UUID().uuidString, firstName: "Cédric", lastName: "Bahirwe", email: "cedbahirwe@gmail.com", profilePicture: nil, messageToken: nil, joinDate: Date(timeIntervalSinceNow: -86400), notificationAuthorized: false)
}
#endif
