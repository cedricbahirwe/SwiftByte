//
//  AppleSignIn.swift
//  SwiftByte
//
//  Created by Cédric Bahirwe on 06/06/2023.
//

import Foundation
import AuthenticationServices

protocol AppleSignInDelegate: ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
}

class AppleSignIn {
    class var shared: AppleSignIn {
        AppleSignIn()
    }

    func logIn(delegate: AppleSignInDelegate?) {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]

        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = delegate
        authorizationController.presentationContextProvider = delegate
        authorizationController.performRequests()
    }
}

class ControllerHandler: UIViewController {

    @available(iOS 13.0, *)
    func addAppleButton() {
        let authorizationButton = ASAuthorizationAppleIDButton(type: .signIn, style: .black)
        authorizationButton.cornerRadius = 20
        authorizationButton.addAction(
            UIAction { _ in
                appleButtonPressed()
            },
            for: .touchUpInside)
        

//        authorizationButton.snp.makeConstraints { maker in
//            maker.top.equalToSuperview()
//            maker.bottom.equalToSuperview()
//            maker.leading.equalToSuperview()
//            maker.trailing.equalToSuperview()
//        }
        func appleButtonPressed() {
            AppleSignIn.shared.logIn(delegate: self)
        }
    }
}
extension ControllerHandler: AppleSignInDelegate {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }

    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        switch authorization.credential {
        case let appleIDCredential as ASAuthorizationAppleIDCredential:
            let token = appleIDCredential.user
            print(token)

        default:
            break
        }
    }

    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {

    }
}
