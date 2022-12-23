//
//  SBArticle.swift
//  SwiftByte
//
//  Created by Cédric Bahirwe on 20/12/2022.
//

import Foundation
import FirebaseFirestoreSwift

typealias Codifiable = Codable & Identifiable

struct SBArticle: Codifiable, Hashable {
    @DocumentID var id: String?
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

extension SBArticle {
    static let empty = SBArticle(title: "",
                                 createdDate: Date(),
                                 content: [],
                                 keywords: [],
                                 moreResources: [])
}
