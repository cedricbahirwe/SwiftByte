//
//  SBGender.swift
//  SwiftByte
//
//  Created by Cédric Bahirwe on 20/12/2022.
//

import Foundation

public enum SBGender: String, Codable, CaseIterable, Equatable {
    case male
    case female
    case nonBinary

    var formatted: String {
        switch self {
        case .male, .female:
            return rawValue.capitalized
        case .nonBinary:
            return "Non Binary"
        }
    }
}
