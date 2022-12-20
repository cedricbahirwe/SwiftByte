//
//  SBErrors.swift
//  SwiftByte
//
//  Created by Cédric Bahirwe on 20/12/2022.
//

import Foundation

public enum SBErrors: Error {
    case genericError
    case internetError
    case timeout
    case localUserNotFound
    case dataBaseError
    case apiError(code: Int, message: String, reason: String)
    case retryError(message: String, retryAction: () -> Void)
    case unauthorized
    case userNotFound
    case invalidUser
    case parseData
    case noDataFound
    case unknownError(_ error: Error?)
    case clientIDMissing
    case appRootMissing
}
