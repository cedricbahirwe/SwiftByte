//
//  SampleModels.swift
//  SwiftByte
//
//  Created by Cédric Bahirwe on 20/12/2022.
//

import Foundation

extension SBArticle {
    static let sample = SBArticle(id: 1,
                                  title: "The most popular iOS UI Frameworks",
                                  intro: .intro,
                                  author: .sample,
                                  createdDate: Date(),
                                  content: [.sample],
                                  keywords: KeyWord.samples)
}

extension SBArticleContent{
    static let intro = SBArticleContent(body: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aliquam suscipit nulla enim, eu gravida metus dictum non. Nam quis nunc urna. Proin elementum, dui eu placerat ullamcorper, est sapien laoreet urna, mattis rutrum justo ")

    static let sample = SBArticleContent(body: "Humm!, Why do I do this!!?",
                                         color: "dc817d",
                                         background: "fffeee",
                                         style: .body,
                                         weight: .semibold,
                                         radius: 20)
}

extension KeyWord {
    static let samples: [KeyWord] = [
        .init("iOS"),
        .init("SwiftUI"),
        .init("Swift"),
        .init("Layout"),
    ]
}

extension SBAuthor {
    static let sample = SBAuthor(firstName: "Cédric", lastName: "Drios", joinedDate: Date())
}
