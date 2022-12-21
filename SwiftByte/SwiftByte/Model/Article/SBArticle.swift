//
//  SBArticle.swift
//  SwiftByte
//
//  Created by Cédric Bahirwe on 20/12/2022.
//

import Foundation

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
