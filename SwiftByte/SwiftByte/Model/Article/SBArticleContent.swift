//
//  SBArticleContent.swift
//  SwiftByte
//
//  Created by Cédric Bahirwe on 21/12/2022.
//

import SwiftUI

struct SBArticleContent: Hashable, Codable {
    var body: String
    var color: String?
    var background: String?
    var style: Style?
    var weight: Weight?
    var design: Design?
    var radius: Double?

    /// The font of the content
    var font: Font {
        Font.system(style?.value ?? .body,
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

    enum Weight: String, CaseIterable, Codable {
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

    enum Design: String, CaseIterable, Codable {
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
