//
//  SBArticle.swift
//  SwiftByte
//
//  Created by Cédric Bahirwe on 20/12/2022.
//

import Foundation
import SwiftUI

typealias Codifiable = Codable & Identifiable

struct SBArticle: Codifiable {
    var id: Int
    var title: String
    var intro: SBArticleContent?
    var author: SBAuthor?
    var createdDate: Date
    var updateDate: Date?
    var content: [SBArticleContent]
    var keywords: [KeyWord]
}

struct SBArticleContent: Codable {
    var body: String
    var color: String?
    var background: String?
    var style: Style = .body
    var weight: Weight?
    var design: Design?
    var radius: Double?

    var font: Font {
        Font.system(style.value,
                    design: design?.value,
                    weight: weight?.value)
    }

    var fontColor: Color? {
        if let color, !color.isEmpty {
            return Color(hex: color)
        }
        return nil
    }

    var backgroundColor: Color? {
        if let background, !background.isEmpty {
            return Color(hex: background)
        }
        return nil
    }

    var cornerRadius: CGFloat? {
        if let radius, radius >= 0 {
            return CGFloat(radius)
        }
        return nil
    }

    enum Weight: String, Codable {
         case ultraLight
         case thin
         case light
         case regular
         case medium
         case semibold
         case bold
         case heavy
         case black

        var value: Font.Weight {
            switch self {
            case .ultraLight:
                return .ultraLight
            case .thin:
                return .thin
            case .light:
                return .light
            case .regular:
                return .regular
            case .medium:
                return .medium
            case .semibold:
                return .semibold
            case .bold:
                return .bold
            case .heavy:
                return .heavy
            case .black:
                return .black
            }
        }
    }

    enum Style: String, CaseIterable,  Codable {
        case largeTitle
        case title
        case title2
        case title3
        case headline
        case subheadline
        case body
        case callout
        case footnote
        case caption
        case caption2

        var value: Font.TextStyle {
            switch self {
            case .largeTitle:
                return .largeTitle
            case .title:
                return .title
            case .title2:
                return .title2
            case .title3:
                return .title3
            case .headline:
                return .headline
            case .subheadline:
                return .subheadline
            case .body:
                return .body
            case .callout:
                return .callout
            case .footnote:
                return .footnote
            case .caption:
                return .caption
            case .caption2:
                return .caption2
            }
        }
    }

    enum Design: String, Codable {
        case `default`
        case serif
        case rounded
        case monospaced

        var value: Font.Design {
            switch self {
            case .`default`:
                return .default
            case .serif:
                return .serif
            case .rounded:
                return .rounded
            case .monospaced:
                return .monospaced
            }
        }
    }
}

struct SBAuthor: Codifiable {
    var id: UUID = UUID()
    let firstName: String
    let lastName: String
    let joinedDate: Date?

    var fullName: String {
        "\(firstName) \(lastName)"
    }

    static var anonymous: SBAuthor {
        SBAuthor(firstName: "Anonymous", lastName: "", joinedDate: nil)
    }
}

struct KeyWord: Codable {
    let name: String
    init(_ name: String) {
        self.name = name
    }
}
