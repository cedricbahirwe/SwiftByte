//
//  SBUser.swift
//  SwiftByte
//
//  Created by Cédric Bahirwe on 20/12/2022.
//

import FirebaseFirestore
import FirebaseFirestoreSwift

struct SBUser: Identifiable, Hashable, FirestoreEntity {
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

    func getFullName() -> String {
        "\(firstName) \(lastName)"
    }
}

extension SBUser {
    static func build(from model: AuthenticationView.AuthModel, allowNotification: Bool = true) -> Self {
        return .init(firstName: model.firstName,
                     lastName: model.lastName,
                     email: model.email,
                     joinDate: Date(),
                     notificationAuthorized: allowNotification)
    }
}

#if DEBUG
extension SBUser {
    static let sample = SBUser(id: UUID().uuidString, firstName: "John", lastName: "Doe", email: "john@gmail.com", profilePicture: nil, messageToken: nil, joinDate: Date(timeIntervalSinceNow: -86400), notificationAuthorized: false)
}
#endif
