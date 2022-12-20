//
//  SBArticle.swift
//  SwiftByte
//
//  Created by Cédric Bahirwe on 20/12/2022.
//

import Foundation

typealias Codifiable = Codable & Identifiable

struct SBArticle: Codifiable {
    var id: Int
    var title: String
    var author: String
    var createdDate: Date
    var updateDate: Date?
    var content: SBArticleContent
}

struct SBArticleContent: Codifiable {
    let id: Int

}
