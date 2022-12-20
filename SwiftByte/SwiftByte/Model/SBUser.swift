//
//  SBUser.swift
//  SwiftByte
//
//  Created by Cédric Bahirwe on 20/12/2022.
//

import FirebaseFirestore
import FirebaseFirestoreSwift

struct SBUser: Codifiable, FirestoreEntity {
    static var collectionName: SBCollectionName { .users }

    @DocumentID var id: String?
    var firstName: String
    var lastName: String
    var email: String

    var profilePicture: String?
    var messageToken: String?
    var joinDate: Date = Date()

    var notificationAuthorized: Bool
    var gender: SBGender

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
                     notificationAuthorized: allowNotification,
                     gender: model.gender)
    }
}
