//
//  AppSignInAuthenticator.swift
//  SwiftByte
//
//  Created by Cédric Bahirwe on 20/12/2022.
//

import Foundation
import GoogleSignIn
import FirebaseAuth

/// An observable class for authenticating via Google.
final class AppSignInAuthenticator: NSObject, ObservableObject {
    typealias UserCompletion = Result<User, Error>
    private var authViewModel: AuthenticationViewModel

    /// Creates an instance of this authenticator.
    /// - parameter authViewModel: The view model this authenticator will set logged in status on.
    init(authViewModel: AuthenticationViewModel) {
        self.authViewModel = authViewModel
    }

    /// Signs in the user based upon the selected account.'
    /// - note: Successful calls to this will set the `authViewModel`'s `state` property.
    func signInWithGoogle() {
        guard let rootViewController = getAppRootView() else {
            print("There is no root view controller!")
            return
        }

        GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController) { signInResult, error in
            guard let signInResult = signInResult else {
                print("Error! \(String(describing: error))")
                return
            }

            signInResult.user.refreshTokensIfNeeded { [weak self] user, error in
                guard let self = self else { return }
                guard error == nil else { return }
                guard let user = user else { return }

                guard let idToken = user.idToken else { return }
                let accessToken = user.accessToken

                // Send ID token to firebase.
                self.sendUserTokenToFirebase(with: idToken,
                                        accessToken: accessToken)
            }
        }
    }
    

    private func sendUserTokenToFirebase(with idToken: GIDToken,
                                         accessToken: GIDToken) {
        let credential = GoogleAuthProvider.credential(withIDToken: idToken.tokenString,
                                                       accessToken: accessToken.tokenString)

        // Sign in in FireBase Auth
        Auth.auth().signIn(with: credential) { result, error in
            if let error = error {
//                completion()
                printf("There was firebase error: \(error.localizedDescription)")
                return
            }

            guard let user = result?.user else {
                printf("No user found")
                return
            }

            self.authViewModel.state = .signedIn(user)


            print("User ID: \(String(describing: user.uid))")

            print("User name: \(String(describing: user.displayName))")

            print("User Photo URL: \(String(describing: user.photoURL))")

            print("User email: \(user.email ?? "No email found")")

            print("User phone: \(user.phoneNumber ?? "No phone found")")
        }
    }

    /// Sign up new user using Firebase
    /// - Parameters:
    ///   - email: user's email
    ///   - password: user's password
    ///   - completion: whether the Sign Up process was successful
    func signUpWith(email: String,
                    password: String,
                    completion: @escaping(UserCompletion) -> Void) {
        Auth.auth().createUser(withEmail: email,
                                password: password)
        { result, error in
            if let error {
                completion(.failure(error))
                return
            }

            guard let user = result?.user else {
                completion(.failure(SBErrors.userNotFound))
                return
            }

            completion(.success(user))
        }
    }

    /// Sign In existing user using `Firebase`
    /// - Parameters:
    ///   - email: user's email
    ///   - password: user's password
    ///   - completion: whether the Sign In process was successful
    func signInWith(_ email: String,
                    _ password: String,
                    completion: @escaping(UserCompletion) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password)
        { result, error in

            if let error {
                completion(.failure(error))
                return
            }

            guard let user = result?.user else {
                completion(.failure(SBErrors.userNotFound))
                return
            }

            self.authViewModel.state = .signedIn(user)
        }
    }


    /// Signs out the current user from both  `GoogleSignIn` and `FireBase`
    func signOut() {
        do {
            GIDSignIn.sharedInstance.signOut()
            try Auth.auth().signOut()
            authViewModel.state = .signedOut
        }
        catch {
           printf("Encountered error signing out: \(error).")
       }
    }

    /// Disconnects the previously granted scope and signs the user out.
    func disconnect() {
        GIDSignIn.sharedInstance.disconnect { error in
            if let error = error {
                print("Encountered error disconnecting scope: \(error).")
            }
            self.signOut()
        }
    }
}
