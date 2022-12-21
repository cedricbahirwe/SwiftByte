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
    private let localStorage = AppLocalStorage.shared
    private var authenticator: AppSignInAuthenticator {
        return AppSignInAuthenticator(authViewModel: self)
    }

    /// Creates an instance of this view model.
    init() {
        if let sbUser = localStorage.getUser() {
            self.state = .signedIn(sbUser)
        } else {
            self.state = .signedOut
        }
    }

    func getCurrentUser() -> SBUser? {
        localStorage.getUser()
    }

    /// Signs the user in with `GoogleSignIn`.
    func signInWithGoogle() async -> Bool {
        do {
            let user = try await authenticator.signInWithGoogle()
            if let sbUser = await authenticator.getUser(user.uid) {
                DispatchQueue.main.async {
                    self.state = .signedIn(sbUser)
                }
            }
            return true
        } catch {
            printf("Could not Sign In with Google: \(error).")
            return false
        }
    }

    /// Signs the user in with `Firebase`.
    func signInWith(email: String,
                    password: String) async -> Bool {
        do {
            let user = try await authenticator.signInWith(email, password)
            DispatchQueue.main.async {
                self.state = .signedIn(user)
            }
            return true
        } catch {
            printf("Could not Sign Up with Firebase: \(error).")
            return false
        }
    }

    func signUpWith(_ authModel: AuthenticationView.AuthModel) async -> Bool {
        do {
            let firebaseUser = try await authenticator.signUpWith(email: authModel.email,
                                                            password: authModel.password)
            let isNotificationOn = UserDefaults.standard.bool(for: .allowNotifications)
            let newUser = SBUser.build(from: authModel, allowNotification: isNotificationOn)
            try saveUser(firebaseUser.uid, user: newUser)

            DispatchQueue.main.async {
                self.state = .signedIn(newUser)
            }
            return true
        } catch {
            printf("Could not Sign Up: \(error).")
            return false
        }
    }

    /// Signs the user out.
    func signOut() {
        authenticator.signOut()
    }

    /// Delete User Account
    func deleteAccount() async {
        await authenticator.deleteAccount()
    }

    /// Disconnects the previously granted scope and logs the user out.
    func disconnect() async {
        await authenticator.disconnect()
    }

    /// Get current Firebase user id
    func getCurrentUserID() -> String? {
        switch state {
        case .signedIn(let user):
            return user.id
        case .signedOut:
            return nil
        }
    }
}

// MARK: - Local Storage
extension AuthenticationViewModel {
    /// Save user to UserDefaults storage
    func saveUser(_ sbUser: SBUser) throws {
        try localStorage.saveUser(sbUser)
    }

    /// Remove All caches data
    func clearStorage() {
        localStorage.clearAll()
    }
}

extension AuthenticationViewModel {
    /// An enumeration representing logged in status.
    enum State {
        /// The user is logged in and is the associated value of this case.
        case signedIn(SBUser)
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
