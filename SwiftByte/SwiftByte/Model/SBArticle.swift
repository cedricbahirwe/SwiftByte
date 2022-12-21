//
//  SBArticle.swift
//  SwiftByte
//
//  Created by Cédric Bahirwe on 20/12/2022.
//

import Foundation
import SwiftUI

typealias Codifiable = Codable & Identifiable

struct SBArticle: Codifiable, Hashable {
    var id: Int
    var title: String
    var intro: SBArticleContent?
    var author: SBAuthor?
    var createdDate: Date
    var updateDate: Date?
    var content: [SBArticleContent]
    var keywords: [SBArticleKeyWord]
    var moreResources: [SBLink]

    // Social
    var likes: Int = 0
    var views: Int = 0
}

struct SBArticleContent: Hashable, Codable {
    var body: String
    var color: String?
    var background: String?
    var style: Style = .body
    var weight: Weight?
    var design: Design?
    var radius: Double?

    /// The font of the content
    var font: Font {
        Font.system(style.value,
                    design: design?.value,
                    weight: weight?.value)
    }

    /// The color of the content
    var fontColor: Color? {
        if let color, !color.isEmpty {
            return Color(hex: color)
        }
        return nil
    }

    var isBackgroundStyled: Bool {
        backgroundColor != nil
    }

    /// The background of the content
    var backgroundColor: Color? {
        if let background, !background.isEmpty {
            return Color(hex: background)
        }
        return nil
    }

    var cornerRadius: CGFloat {
        if let radius, radius >= 0 {
            return CGFloat(radius)
        }
        return 0
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

struct SBAuthor: Hashable, Codifiable {
    var id: UUID = UUID()
    var firstName: String
    var lastName: String
    var bio: String?
    var joinedDate: Date?

    var fullName: String {
        "\(firstName) \(lastName)"
    }

    static var anonymous: SBAuthor {
        SBAuthor(firstName: "Anonymous", lastName: "", joinedDate: nil)
    }
}

struct SBArticleKeyWord: Hashable, Codable {
    var name: String
    init(_ name: String) {
        self.name = name
    }
}

struct SBLink: Hashable, Codable {
    var name: String?
    var url: URL

    var description: String {
        name ?? url.description
    }

    init(name: String? = nil, url: URL) {
        self.name = name
        self.url = url
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = try container.decodeIfPresent(String.self, forKey: .name)
        self.url = try container.decode(URL.self, forKey: .url)
    }
}
