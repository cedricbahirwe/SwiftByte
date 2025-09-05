//
//  AuthModel.swift
//  SwiftByte
//
//  Created by Cédric Bahirwe on 03/09/2025.
//

import Foundation

struct AuthModel {
    var firstName = ""
    var lastName = ""
    var email: String = ""
    var password: String = ""
    var profilePicture: String?
}


private extension AuthModel {
    var isEmailValid: Bool {
        SBEmailAddress(rawValue: email) != nil
    }
    var isPasswordValid: Bool {
        password.removeWhitespacesAndNewlines.count >= 6
    }

    var isFirstNameValid: Bool {
        firstName.removeWhitespacesAndNewlines.count > 1
    }

    var isLastNameValid: Bool {
        lastName.removeWhitespacesAndNewlines.count > 1
    }
}

extension AuthModel {
    enum Field: Int {
        case firstName
        case lastName
        case email
        case password
    }

    enum ValidationError: Error {
        case invalidEmail
        case invalidPassword
        case invalidFirstName
        case invalidLastName

        var localizedDescription: String {
            switch self {
            case .invalidEmail:
                return "Please enter a valid email address."
            case .invalidPassword:
                return "Please enter a password with at least 6 characters."
            case .invalidFirstName:
                return "Please enter a valid first name."
            case .invalidLastName:
                return "Please enter a valid last name."
            }
        }
    }

    func isEmailAndPasswordValid() throws(ValidationError) {
        guard isEmailValid else {
            throw .invalidEmail
        }
        guard isPasswordValid else {
            throw .invalidPassword
        }
    }

    func isReadyForRegistration() throws(ValidationError) {
        try isEmailAndPasswordValid()

        guard isFirstNameValid else {
            throw .invalidFirstName
        }

        guard isLastNameValid else {
            throw .invalidLastName
        }
    }
}
