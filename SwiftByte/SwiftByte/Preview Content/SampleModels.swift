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
                                  content: [.sample, .sample1, .sample2, .sample],
                                  keywords: SBArticleKeyWord.samples,
                                  moreResources: [.sample, .sample])
}

extension SBArticleContent{
    static let intro = SBArticleContent(body: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aliquam suscipit nulla enim, eu gravida metus dictum non. Nam quis nunc urna. Proin elementum, dui eu placerat ullamcorper, est sapien laoreet urna, mattis rutrum justo ")

    static let sample = SBArticleContent(body: "Humm!, Why do I do this!!?",
                                         color: "dc817d",
                                         background: "fffeee",
                                         style: .body,
                                         weight: .regular,
                                         radius: 10)

    static let sample1 = SBArticleContent(body: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aliquam suscipit nulla enim, eu gravida metus dictum non. Nam quis nunc urna. Proin elementum, dui eu placerat ullamcorper, est sapien laoreet urna, mattis rutrum justo ",
                                          color: "ffffff",
                                          background: "000000",
                                          style: .headline,
                                          weight: .semibold,
                                          radius: 20)

    static let sample2 = SBArticleContent(
        body: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aliquam suscipit nulla enim, eu gravida metus dictum non. Nam quis nunc urna. Proin elementum, dui eu placerat ullamcorper, est sapien laoreet urna, mattis rutrum justo ",
        color: "38382f",
        style: .caption,
        weight: .bold,
        radius: 20)
}

extension SBArticleKeyWord {
    static let samples: [SBArticleKeyWord] = [
        .init("iOS"),
        .init("SwiftUI"),
        .init("Swift"),
        .init("Layout"),
    ]
}

extension SBAuthor {
    static let sample = SBAuthor(firstName: "Cédric", lastName: "Drios", joinedDate: Date())
}

extension SBLink {
    static let sample = SBLink(name: "How to write better code",
                               url: URL(string: "https://www.google.com")!)
}
