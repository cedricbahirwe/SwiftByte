//
//  SBUser.swift
//  SwiftByte
//
//  Created by Cédric Bahirwe on 20/12/2022.
//

import FirebaseFirestore
import FirebaseFirestoreSwift
import Firebase
import GoogleSignIn

struct SBUser: Identifiable, Codable, FirestoreEntity {
    static var collectionName: SBCollectionName { .users }

    @DocumentID var id: String?
    var firstName: String
    var lastName: String
    var email: String

    var notificationAuthorized: Bool
    var gender: SBGender
    var notificationToken: String?
    var points: Double
    var isActive: Bool

    var phoneNumber: String?
    var profilePicture: String?
    var messageToken: String?
    var birthdate: Date?
    var joinDate: Date?

    func getFullName() -> String {
        "\(firstName) \(lastName)"
    }
}

extension SBUser {
    static func getUser(from user: Firebase.User) -> Self {
        return Self(firstName: "John"
                    lastName: "DOe",
                    email: user.email ?? "",
                    notificationAuthorized: true,
                    gender: .nonBinary,
                    points: 100,
                    isActive: true,
                    profilePicture: "profilePicture",
                    birthdate: Date.now,
                    joinDate: Date())
    }

    static func getUser(from user: GIDGoogleUser) -> Self {
        return Self(firstName: user.profile?.givenName ?? "John"
                    lastName: user.profile?.familyName ?? "DOe",
                    email: user.profile?.email ?? "",
                    notificationAuthorized: true,
                    gender: .nonBinary,
                    points: 100,
                    isActive: true,
                    profilePicture: "profilePicture",
                    birthdate: Date.now,
                    joinDate: Date())
    }
    static func getUser(from model: AuthenticationView.AuthModel, allowNotification: Bool = true) -> Self {
        return Self(firstName: model.firstName,
                    lastName: model.lastName,
                    email: model.email,
                    notificationAuthorized: allowNotification,
                    gender: model.gender,
                    points: 100,
                    isActive: true,
                    profilePicture: model.profilePicture,
                    birthdate: model.birthdate,
                    joinDate: Date())
    }
    //    static func buildUser(from data: SNDictionary) -> Self { }
}
