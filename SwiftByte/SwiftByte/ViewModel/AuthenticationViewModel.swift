//
//  AuthenticationViewModel.swift
//  SwiftByte
//
//  Created by Cédric Bahirwe on 20/12/2022.
//

import SwiftUI
import Firebase
import GoogleSignIn
import FirebaseFirestore

/// A class conforming to `ObservableObject` used to represent a user's authentication status.
final class AuthenticationViewModel: ObservableObject {
    @AppStorage(SBKeys.isUserLoggedIn.rawValue)
    private var isLoggedIn = false

    /// The user's log in status.
    /// - note: This will publish updates when its value changes.
    @Published var state: State
    private var authenticator: AppSignInAuthenticator {
        return AppSignInAuthenticator(authViewModel: self)
    }

    /// Creates an instance of this view model.
    init() {
        if let user = Auth.auth().currentUser {
            self.state = .signedIn(user)
        } else {
            self.state = .signedOut
        }
    }

    /// Signs the user in.
    func signIn() {
        authenticator.signIn()
    }

    func signUpWith(_ authModel: AuthenticationView.AuthModel,
                    completion: @escaping(Bool) -> Void) {
        authenticator.signUpWith(email: authModel.email,
                                 password: authModel.password)
        { [weak self] result in
            guard let self else { return }

            switch result {
            case .failure(let error):
                completion(false)
                printf("There was an error: \(error).")
                break
            case .success(let user):
                do {
                    let isNotificationOn = UserDefaults.standard.bool(for: .allowNotifications)
                    let newUser = SBUser.getUser(from: authModel, allowNotification: isNotificationOn)
                    try self.saveUser(user.uid, user: newUser)

                    self.state = .signedIn(user)
                    completion(true)
                } catch {
                    printf("Could not save user \(error).")
                    completion(false)
                }
            }
        }
    }

    /// Signs the user out.
    func signOut() {
        authenticator.signOut()
    }

    /// Disconnects the previously granted scope and logs the user out.
    func disconnect() {
        authenticator.disconnect()
    }

    /// Get current Firebase user id
    func getCurrentUserID() -> String? {
        switch state {
        case .signedIn(let user):
            return user.uid
        case .signedOut:
            return nil
        }
    }
}

extension AuthenticationViewModel {
    /// An enumeration representing logged in status.
    enum State {
        /// The user is logged in and is the associated value of this case.
        case signedIn(User)
        /// The user is logged out.
        case signedOut
    }
}


// MARK: - SignIn Scopes
extension AuthenticationViewModel {
    enum SignInScope: String {
        case firebaseMessaging = "https://www.googleapis.com/auth/firebase.messaging"
    }

}
// MARK: - Store User in DB (Collection)
extension AuthenticationViewModel {
    func saveUser(_ id: String, user: SBUser) throws {
        let reference = Firestore.firestore()
        try reference
            .collection(.users)
            .document(id)
            .setData(from: user) { error in
                if let error = error {
                    print(error.localizedDescription)
                    return
                }
            }
    }
}

// MARK: - Notification Toke Manager
private extension AuthenticationViewModel {
     func handleUserRegistration(for userId: String) {
        let ref = Firestore.firestore()
        ref.collection(.users)
            .document(userId)
            .addSnapshotListener { [weak self] (querySnapshot, error) in
                guard let self else { return }
                guard let document = querySnapshot?.data() else { return }

                if (document["messageToken"] == nil) {
                    self.getToken { token, error in
                        if let error = error {
                            sbPrint("Error fetching FCM registration token: \(error)")
                        } else if let token = token {
                            sbPrint("FCM registration token: \(token)")
                            self.updateUserToken(ref, userId, token)
                        }
                    }
                }
            }
    }

    func getToken(completion: @escaping (String?, Error?) -> Void) {
        Messaging.messaging().token(completion: completion)
    }

    func updateUserToken(_ ref: Firestore, _ userId: String, _ token: String) {
        ref.collection(.users)
            .document(userId)
            .setData(["messageToken": token], merge: true) { error in
                if  let error = error {
                    printf(error.localizedDescription)
                    return
                }
            }
    }
}
