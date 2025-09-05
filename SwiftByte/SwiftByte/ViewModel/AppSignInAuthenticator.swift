//
//  AppSignInAuthenticator.swift
//  SwiftByte
//
//  Created by Cédric Bahirwe on 20/12/2022.
//

import Foundation
import GoogleSignIn
import Firebase
import FirebaseAuth

/// An observable class for authenticating via Google.
final class AppSignInAuthenticator: NSObject, ObservableObject {
    typealias UserCompletion = Result<SBUser, Error>
    private var authViewModel: AuthenticationViewModel

    /// Creates an instance of this authenticator.
    /// - parameter authViewModel: The view model this authenticator will set logged in status on.
    init(authViewModel: AuthenticationViewModel) {
        self.authViewModel = authViewModel
    }

    /// Signs in the user based upon the selected account.'
    /// - note: Successful calls to this will set the `authViewModel`'s `state` property.
    func signInWithGoogle() async throws -> User {

        guard let rootViewController = await getAppRootView() else {
            throw SBErrors.appRootMissing
        }

        guard let clientID = FirebaseApp.app()?.options.clientID else {
            printf("There is no Firebase clietID.")
            throw SBErrors.clientIDMissing
        }

        // Create Google Sign In configuration object.
        let config = GIDConfiguration(clientID: clientID)

        GIDSignIn.sharedInstance.configuration = config

        let result = try await GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController)

        let refreshUser = try await result.user.refreshTokensIfNeeded()

        guard let idToken = refreshUser.idToken else {
            throw SBErrors.invalidUser
        }

        let accessToken = refreshUser.accessToken

        // Send ID token to Firebase.
        return try await sendUserTokenToFirebase(with: idToken,
                                accessToken: accessToken)
    }

    private func sendUserTokenToFirebase(with idToken: GIDToken,
                                         accessToken: GIDToken) async throws -> User {
        let credential = GoogleAuthProvider.credential(withIDToken: idToken.tokenString,
                                                       accessToken: accessToken.tokenString)

        // Sign in in FireBase Auth
        let result = try await Auth.auth().signIn(with: credential)
        
        let user = result.user

        if await getUser(user.uid) == nil {
            let isNotificationOn = UserDefaults.standard.bool(for: .allowNotifications)

            let sbUser = SBUser(firstName: user.displayName ?? "Unknown",
                                lastName: "",
                                email: user.email ?? "-",
                                profilePicture: user.photoURL?.absoluteString,
                                notificationAuthorized: isNotificationOn)
            try authViewModel.saveUserToFirestore(user.uid, user: sbUser)
        }

        return user
    }

    /// Sign up new user using Firebase
    /// - Parameters:
    ///   - email: user's email
    ///   - password: user's password
    ///   - completion: whether the Sign Up process was successful
    func signUpWith(email: String,
                    password: String) async throws -> User {

        let auth = Auth.auth()
        let result = try await auth.createUser(withEmail: email,
                                            password: password)

        return result.user
    }

    /// Sign In existing user using `Firebase`
    /// - Parameters:
    ///   - email: user's email
    ///   - password: user's password
    ///   - completion: whether the Sign In process was successful
    func signInWith(_ email: String,
                    _ password: String) async throws -> SBUser {

        let result = try await Auth.auth().signIn(withEmail: email,
                                                  password: password)

        let user = result.user

        let sbUser: SBUser = try await getUser(user.uid)

        return sbUser

    }

    /// Signs out the current user from both  `GoogleSignIn` and `FireBase`
    func signOut() {
        do {
            try Auth.auth().signOut()
            GIDSignIn.sharedInstance.signOut()
            DispatchQueue.main.async {
                self.authViewModel.state = .signedOut
            }
            authViewModel.clearSession()
        }
        catch {
           printf("Encountered error signing out: \(error).")
       }
    }

    ///
    func deleteAccount() async {
        do {
            guard let user = Auth.auth().currentUser else { return }
            try await user.delete()
            try await authViewModel.deleteUser(user.uid)
            GIDSignIn.sharedInstance.signOut()
            await MainActor.run {
                self.authViewModel.state = .signedOut
            }
            authViewModel.clearSession()
        }
        catch {
           printf("Could not delete account: \(error).")
       }
    }

    /// Disconnects the previously granted scope and signs the user out.
    func disconnect() async {
        do {
            try await GIDSignIn.sharedInstance.disconnect()
            signOut()
        } catch {
            print("Encountered error disconnecting scope: \(error).")
        }
    }

    /// Get User Object
    func getUser(_ id: String) async throws -> SBUser {
        let db = Firestore.firestore()
        let docRef = db.collection(.users).document(id)

        let sbUser = try await docRef.getDocument(as: SBUser.self)
        try authViewModel.saveUserToLocalStore(sbUser)
        return sbUser
    }

    /// Get User Object
    func getUser(_ id: String) async -> SBUser? {
        do {
            let sbUser: SBUser = try await getUser(id)
            return sbUser
        } catch {
            prints("Encountered error fetching user: \(error).")
            return nil
        }
    }
}
